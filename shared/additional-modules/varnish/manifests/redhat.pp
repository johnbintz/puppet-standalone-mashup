class varnish::redhat($version, $user, $group, $vcl) {
  $init_d_prolog = template('varnish/redhat/init-d-prolog')
  $init_d_prerun = template('varnish/redhat/init-d-prerun')

  class { varnish:
    vcl_template => $vcl,
    version => $version
  }

  $varnish_init_d = "${varnish::share}/varnish-init.d"
  file { $varnish_init_d:
    content => template('varnish/varnish-init.d'),
    require => Mkdir_p[$varnish::share],
    mode => 755
  }
}

