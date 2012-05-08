class varnish-default-vcl {
  $backend_port = '8080'
  $assets_age = 86400
  $no_ttl_time = "10m"

  $healthy_grace_time = "1m"
  $sick_grace_time = "24h"
  $probe_interval = "3s"

  file { $varnish::vcl_path:
    content => template('varnish-default-vcl/default.vcl'),
    require => [ Build_and_install[$name], Mkdir_p[$config_path] ],
  }
}

