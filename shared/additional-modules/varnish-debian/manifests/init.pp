class varnish-debian($version, $store_file_mb => '1024') {

  $varnish_user = 'varnish'
  $varnish_group = 'web'

  user { $varnish_user:
    ensure => present,
    uid => 25678,
    groups => [ 'web' ],
    require => Group['web']
  }

  class { varnish:
    version => $version,
    require => Package[$packages],
    store_file_mb
  }
}

