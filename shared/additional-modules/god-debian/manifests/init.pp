class god-debian {
  class { god: }

  init_d_bundle { 'god':
    init_d_prolog => template('god-debian/init_d_prolog'),
    init_d_prerun => template('god-debian/init_d_prerun'),
    require => Class['god']
  }

  file { '/usr/local/sbin/resurrect':
    content => template('god-debian/resurrect'),
    mode => 755
  }
}

