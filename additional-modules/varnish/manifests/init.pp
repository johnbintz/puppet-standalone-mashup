class varnish($version = '', $vcl, $user = 'varnish', $group = 'varnish') {
  if ($::osfamily == 'debian') {
    $config = '/etc/varnish'

    $default_varnish = '/etc/default/varnish'
    $bin = "/usr/sbin/varnishd"
  } else {
    $install_path = install_path($name, $version)
    $config = config_path($name)
    $share = share_path($name)
    $data = data_path($name)
    $sbin = sbin_path($name)
    $bin_path = bin_path($name)

    $bin = "${sbin}/${name}d"
    $pid = pid_path($name)
    $log = log_path($name)

    $default_varnish = "${config}/defaults"
  }

  $vcl_path = "${config}/default.vcl"

  if ($::osfamily == 'debian') {
    debsource { varnish:
      apt_source => $debian::varnish_apt_source,
      keyfile => $debian::varnish_keyfile,
      hash => $debian::varnish_hash
    }

    $cache_root = "/var/lib"
    $cache_dir = "${cache_root}/varnish"

    package { varnish:
      ensure => latest,
      require => [
        Debsource['varnish'], Mkdir_p[$cache_dir]
      ]
    }

    service { varnish:
      ensure => stopped,
      require => Package[varnish]
    }

    exec { 'update-rc.d -f varnish remove':
      path => $::base::path,
      require => Package[varnish]
    }

    $store_file_size = dir_size($cache_root)

    Package['varnish'] -> File[$default_varnish, $vcl_path]
  } else {
    $source = "http://repo.varnish-cache.org/source/varnish-${version}.tar.gz"
    $dirs = [ $config, $log, $share, $data ]

    $cache_dir = "${data}/store"

    build_and_install { $name:
      version => $version,
      source => $source
    }

    mkdir_p { $dirs:
      path => $base::path,
      require => Build_and_install[$name]
    }

    init_d { $name:
      require => Mkdir_p[$dirs]
    }

    Build_and_install['varnish'] -> File[$default_varnish, $vcl_path]

    /*
    $ncsa_bin = "${bin_path}/varnishncsa"
    $ncsa_pid = pid_path('varnishncsa')
    $ncsa_log = "${log}/access.log"

    logrotate_d { 'varnishncsa':
      postrotate => 'service varnish rotate',
      pattern => "${log}/access.log"
    }
    */
  }

  file { $default_varnish:
    content => template("varnish/default"),
    notify => Service['god']
  }

  file { $vcl_path:
    content => $vcl,
    notify => Service['god']
  }

  mkdir_p { $cache_dir:
    path => $base::path
  }

  god_init { $name:
    start => "${bin} -T 127.0.0.1:6082 -F -u ${user} -g ${group} -w 1,1,3600 -f ${vcl_path} -s file,${cache_dir}/varnish",
    dir => config_path('god.d'),
    ensure => present,
    require => File[$vcl_path],
    interval => 10
  }
}

