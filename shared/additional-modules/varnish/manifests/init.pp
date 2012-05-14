class varnish($version, $vcl_template, $store_file_mb = 1024) {
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
  $ncsa_log = "${log}/access.log"

  $vcl_path = "${config}/default.vcl"

  $store_file_path = "${data}/store"
  $store_file_size = $store_file_mb * 1024 * 1024

  build_and_install { $name:
    version => $version,
    source => "http://repo.varnish-cache.org/source/varnish-<%= scope.lookupvar('version') %>.tar.gz"
  }

  mkdir_p { [ $config, $log, $share, $data ]:
    path => $base::path,
    require => Build_and_install[$name]
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

  file { $vcl_path:
    content => template($vcl_template),
    require => Build_and_install[$name]
  }

  god_init { $name:
    start => $varnish_start,
    stop => $varnish_stop,
    restart => "${varnish_stop} && ${varnish_start}",
    pid_file => $pid,
    ensure => present,
    require => File[$vcl_path],
    interval => 10
  }
}
