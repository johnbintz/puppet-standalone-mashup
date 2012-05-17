class squid::debian($version, $config_template) {
  $squid_user = 'squid'
  $squid_group = 'squid'

  user { $squid_user: uid => 6574 }

  class { 'squid':
    version => $version,
    user => 'squid',
    config_template => $config_template,
    require => User['squid']
  }

  init_d_bundle { 'squid':
    init_d_prolog => template('squid/debian/init-d-prolog'),
    init_d_prerun => template('squid/debian/init-d-prerun'),
    require => Class['squid']
  }

  exec { 'ensure-data-dir-ownership':
    command => "chown -R ${squid_user}:${squid_group} ${squid::data}",
    path => $base::path,
    require => Class['squid']
  }

  logrotate_d { 'squid':
    postrotate => 'service squid rotate',
    pattern => "${squid::log}/access.log"
  }
}
