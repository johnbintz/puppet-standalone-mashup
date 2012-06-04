class varnish($version, $vcl, $user = 'varnish', $group = 'varnish', $store_file_mb = 1024) {
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

  $varnish_start = "service varnish start"
  $varnish_stop = "service varnish stop"
  $varnish_rotate = "service varnish rotate"

  $source = "http://repo.varnish-cache.org/source/varnish-${version}.tar.gz"
  $dirs = [ $config, $log, $share, $data ]

  build_and_install { $name:
    version => $version,
    source => $source
  }

  mkdir_p { $dirs:
    path => $base::path,
    require => Build_and_install[$name]
  }

  exec { "${name} create-store-file":
    command => "dd if=/dev/zero of=${store_file_path} bs=${store_file_size} count=1",
    timeout => 0,
    unless => "test -f ${store_file_path}",
    path => $base::path,
    require => Mkdir_p[$data],
    logoutput => true
  }

  file { $vcl_path:
    content => $vcl,
    require => Build_and_install[$name]
  }

  god_init { $name:
    start => $varnish_start,
    stop => $varnish_stop,
    dir => config_path('god.d'),
    restart => "${varnish_stop} && ${varnish_start}",
    pid_file => $pid,
    ensure => present,
    require => File[$vcl_path],
    interval => 10
  }

  /* debian stuff */
  if ($osfamily == 'debian') {
    user { $user: uid => 27835 }

    $packages = [ 'libpcre3', 'libpcre3-dev', 'pkg-config' ]

    package { $packages:
      ensure => installed,
      before => Build_and_install[$name]
    }

    exec { 'ensure-data-store-ownership':
      command => "chown -R ${user}:${group} ${data}",
      path => $base::path,
      require => Exec["${name} create-store-file"]
    }

    logrotate_d { 'varnishncsa':
      postrotate => 'service varnish rotate',
      pattern => "${log}/access.log"
    }
  }

  init_d { $name:
    require => Mkdir_p[$dirs]
  }
}

