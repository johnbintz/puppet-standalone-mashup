class squid($version = '', $user = 'proxy', $group = 'proxy', $config_template, $error_template) {
  if ($::osfamily == 'debian') {
    $cache_dir = '/var/spool/squid3'
    $config_dir = "/etc/squid3"
    $config = "${config_dir}/squid.conf"
    $log_dir = "/var/log/squid3"
    $sbin = '/usr/sbin'

    package { 'squid3': ensure => latest }

    service { squid3:
      ensure => stopped,
      require => Package[squid3]
    }

    Package['squid3'] -> File[$config]

    exec { 'update-rc.d -f squid3 remove':
      path => $::base::path
    }
  } else {
    $bin = bin_path($name)
    $sbin = sbin_path($name)

    $build_dir = build_path($name, $version)
    $log_dir = log_path($name)
    $pid = pid_path($name)
    $cache_dir = data_path($name)
    $config_dir = config_path($name)
    $config = "${config_dir}/squid.conf"

    build_and_install { $name:
      version => $version,
      source => "http://www.squid-cache.org/Versions/v3/3.1/squid-${version}.tar.bz2",
      configure => template('squid/configure'),
      preconfigure => template('squid/preconfigure')
    }

    Build_and_install[$name] -> File[$config]
  }

  mkdir_p { [ $log_dir, $cache_dir, $config_dir ]:
    path => $base::path
  }

  exec { "chown -R ${user}:${group} ${log_dir}":
    path => $::base::path,
    require => Mkdir_p[$log_dir]
  }

  exec { cache_dir_perms:
    command => "chown -R ${user}:${group} ${cache_dir}",
    path => $::base::path,
    require => Mkdir_p[$cache_dir]
  }

  exec { "${sbin}/squid3 -z":
    path => $::base::path,
    require => Exec[cache_dir_perms]
  }

  file { $config:
    content => template($config_template)
  }

  god_init { $name:
    start => "${sbin}/squid3 -YC -f ${config} -N -a 80",
    dir => config_path('god.d'),
    ensure => present,
    require => File[$config],
    interval => 10
  }
}

