class varnish::debian($version, $vcl_template) {
  $user = 'varnish'
  $group = 'varnish'

  user { $user: uid => 27835 }

  package { 'libpcre3-dev': ensure => installed }

  class { 'varnish':
    version => $version,
    require => Package['libpcre3-dev'],
    vcl_template => $vcl_template
  }

  init_d { 'varnish':
    init_d_prerun => template('varnish/debian/init-d-prerun'),
    init_d_prolog => template('varnish/debian/init-d-prolog'),
    require => Class['varnish']
  }
}

