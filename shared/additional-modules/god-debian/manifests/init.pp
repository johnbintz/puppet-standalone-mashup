class god-debian {
  class { god: }

  $god_init_d = "${base::share_path}/god/god-init.d"
  file { $god_init_d:
    content => template('god/god-init.d'),
    require => File[$god::share],
    mode => 755
  }

  file { 'etc/init.d/god':
    ensure => $god_init_d,
    require => Class['god']
  }

  update_rc_d_defaults { 'god':
    require => File['/etc/init.d/god']
  }

  running_service { 'god':
    require => Update_rc_d_defaults['god']
  }

  file { '/usr/local/sbin/resurrect':
    content => template('god-debian/resurrect'),
    mode => 755
  }
}

