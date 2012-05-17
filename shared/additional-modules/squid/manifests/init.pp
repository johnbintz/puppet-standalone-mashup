class squid($version, $user, $config_template) {
  $build_command = template('squid/build-squid.sh')

  $log_dir = log_path($name)
  $pid = pid_path($name)
  $data_dir = data_path($name)
  $config_dir = config_path($name)
  $config = "${config_dir}/squid.conf"

  file { [ $log_dir, $data_dir, $config_dir ]:
    ensure => directory
  }

  build_and_install { $name:
    version => $version,
    source => "http://www.squid-cache.org/Versions/v3/3.1/squid-${version}.tar.bz2",
    configure => template('squid/configure'),
    preconfigure => template('squid/preconfigure')
  }

  $squid_imgsrc_ip = extlookup('squid_imgsrc_ip')
  $squid_cache_dir_size = extlookup('squid_cache_dir_size')

  $config = '/etc/squid3/squid.conf'

  file { $config:
    content => template($config_template),
    require => Exec['build-squid']
  }

  exec { 'squid -z':
    require => [ File['/var/log/squid3'], File['/var/spool/squid3'] ],
    path => '/usr/bin:/usr/sbin:/bin:/sbin',
    unless => 'test -d /var/spool/squid3/10'
  }

  god_conf { $name: }

  file { [
           '/usr/share/squid3/errors/en/ERR_CANNOT_FORWARD',
           '/usr/share/squid3/errors/templates/ERR_CANNOT_FORWARD'
         ]:
    content => template('squid/error_page.html'),
    require => Build_and_install['squid']
  }
}

