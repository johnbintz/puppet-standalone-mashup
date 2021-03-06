class tc::debian($config) {
  $packages = [ 'ethtool' ]

  package { $packages: ensure => installed }

  init_d_bundle { 'tc':
    init_d_prolog => template('tc/debian/init-d-prolog'),
    init_d_prerun => template('tc/debian/init-d-prerun'),
    require => Class['squid']
  }
}
