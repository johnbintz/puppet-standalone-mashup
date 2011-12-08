define update_rc_d_defaults {
  exec { "update-rc.d-${name}":
    command => "update-rc.d ${name} defaults",
    path => $base::path
  }
}

