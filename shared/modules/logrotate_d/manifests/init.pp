define logrotate_d($postrotate, $pattern) {
  file { "/etc/logrotate.d/${name}":
    content => template('logrotate_d/logrotate.d.erb')
  }
}

