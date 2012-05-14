class varnish::debian($version, $vcl_template, $store_file_mb = 1024) {
  $varnish_user = 'varnish'
  $varnish_group = 'varnish'

  user { $varnish_user: uid => 27835 }

  $packages = [ 'libpcre3', 'libpcre3-dev', 'pkg-config' ]

  package { $packages: ensure => installed }

  class { 'varnish':
    version => $version,
    require => Package[$packages],
    vcl_template => $vcl_template
  }

  init_d_bundle { 'varnish':
    init_d_prolog => template('varnish/debian/init-d-prolog'),
    init_d_prerun => template('varnish/debian/init-d-prerun'),
    require => Class['varnish']
  }

  exec { 'ensure-data-store-ownership':
    command => "chown -R ${varnish_user}:${varnish_group} ${varnish::data}",
    path => $base::path,
    require => Class['varnish']
  }

  logrotate_d { 'varnishncsa':
    postrotate => 'service varnish rotate',
    pattern => "${varnish::log}/access.log"
  }
}

