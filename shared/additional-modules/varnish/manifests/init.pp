class varnish($version, $store_file_mb = 1024) {
  $install_path = install_path($name, $version)
  $config = config_path($name)
  $share = share_path($name)
  $data = data_path($name)
  $sbin = sbin_path($name)
  $bin_path = bin_path($name)

  $bin = "${sbin}/${name}d"
  $pid = pid_path($name)
  $log = log_path($name)

  $ncsa_bin = "${bin_path}/varnishncsa"
  $ncsa_pid = pid_path('varnishncsa')
  $ncsa_log = $log

  $sysconfig_dir = "${config}/sysconfig"
  $vcl_path = "${config}/default.vcl"

  $override_config = "${sysconfig_dir}/${name}"

  $store_file_path = "${data}/store"
  $store_file_size = $store_file_mb * 1024 * 1024

  $backend_port = '8080'
  $assets_age = 86400
  $no_ttl_time = "10m"

  $healthy_grace_time = "1m"
  $sick_grace_time = "24h"
  $probe_interval = "3s"

  build_and_install { $name:
    version => $version,
    source => "http://repo.varnish-cache.org/source/varnish-<%= scope.lookupvar('version') %>.tar.gz"
  }

  mkdir_p { [ $config, $log, $share, $sysconfig_dir, $data ]:
    path => $base::path,
    require => Build_and_install[$name]
  }

  file { $override_config:
    ensure => present,
    mode => 644,
    content => template('varnish/defaults'),
    require => Mkdir_p[$sysconfig_dir],
  }

  exec { 'create-store-file':
    command => "dd if=/dev/zero of=${store_file_path} bs=${store_file_size} count=1",
    timeout => 0,
    unless => "test -f ${store_file_path}",
    path => $base::path,
    require => Mkdir_p[$data],
    logoutput => true
  }

  $varnish_start = "service varnish start"
  $varnish_stop = "service varnish stop"

  god_init { $name:
    start => $varnish_start,
    stop => $varnish_stop,
    restart => "${varnish_stop} && ${varnish_start}",
    pid_file => $pid,
    ensure => present,
    require => Build_and_install[$name]
  }
}
