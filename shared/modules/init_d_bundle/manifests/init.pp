define init_d_bundle($init_d_prolog, $init_d_prerun) {
  $init_d_source = "${base::share_path}/${name}/${name}-init.d"
  file { $init_d_source:
    content => template("${name}/${name}-init.d"),
    mode => 755
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

