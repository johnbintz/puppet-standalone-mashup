class squid($version, $user, $config_template, $error_template) {
  $bin = bin_path($name)
  $sbin = sbin_path($name)

  $build_dir = build_path($name, $version)
  $log_dir = log_path($name)
  $pid = pid_path($name)
  $data_dir = data_path($name)
  $config_dir = config_path($name)
  $config = "${config_dir}/squid.conf"

  mkdir_p { [ $log_dir, $data_dir, $config_dir ]:
    path => $base::path
  }

  build_and_install { $name:
    version => $version,
    source => "http://www.squid-cache.org/Versions/v3/3.1/squid-${version}.tar.bz2",
    configure => template('squid/configure'),
    preconfigure => template('squid/preconfigure')
  }

  file { $config:
    content => template($config_template),
    require => Build_and_install[$name]
  }

  $squid_start = 'service squid start'
  $squid_stop = 'service squid stop'

  god_init { $name:
    start => $squid_start,
    stop => $squid_stop,
    restart => "${squid_stop} && ${squid_start}",
    pid_file => $pid,
    ensure => present,
    require => File[$config],
    interval => 10
  }

  file { [
           "${data_dir}/errors/en/ERR_CANNOT_FORWARD",
           "${data_dir}/errors/templates/ERR_CANNOT_FORWARD"
         ]:
    content => template($error_template),
    require => Build_and_install['squid']
  }
}

