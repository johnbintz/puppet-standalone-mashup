class nginx-debian {
  $log_root = "/var/log/nginx"

  file { $log_root:
    owner => root,
    group => web,
    mode => 2775,
    ensure => directory
  }

  file { "$log_root/sites":
    owner => root,
    group => web,
    mode => 2775,
    require => File[$log_root],
    ensure => directory
  }

  $pid_file = pid_path('nginx')

  logrotate_d { 'nginx':
    postrotate => "sudo /bin/kill -USR1 `cat ${pid_file}`",
    pattern => "/var/log/nginx/*/access.log /var/log/nginx/*/error.log",
    require => Class['nginx']
  }
}
