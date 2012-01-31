class god {
  gem { 'god':
    path => "${ruby::path}:${base::path}",
    ensure => present,
    require => Make_and_install['ruby']
  }

  $god_bin = "${base::install_path}/ruby/bin/god"
  $god_dir = "${base::config_path}/god.d"
  $pid_path = pid_path($name)

  file { '/etc/init.d/god':
    content => template('god/god-init.d'),
    mode => 755
  }

  file { $god_dir:
    ensure => directory
  }

  update_rc_d_defaults { $name:
    require => File['/etc/init.d/god']
  }

  running_service { $name:
    require => Update_rc_d_defaults[$name]
  }

  file { '/usr/local/sbin/resurrect':
    content => template('god/resurrect'),
    mode => 755
  }
}

