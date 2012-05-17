define init_d_bundle($init_d_prolog, $init_d_prerun) {
  $share_path = "${base::share_path}/${name}"

  file { $share_path:
    ensure => directory
  }

  $init_d_source = "${share_path}/${name}-init.d"
  file { $init_d_source:
    content => template("${name}/${name}-init.d"),
    mode => 755,
    require => File[$share_path]
  }

  $init_d = "/etc/init.d/${name}"

  file { $init_d:
    ensure => $init_d_source,
    require => File[$init_d_source]
  }

  update_rc_d_defaults { $name:
    require => File[$init_d]
  }

  running_service { $name:
    require => Update_rc_d_defaults[$name]
  }
}

