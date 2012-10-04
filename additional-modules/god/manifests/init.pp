class god {
  gem { 'god':
    path => "${ruby::path}:${base::path}",
    ensure => present,
    require => Class['ruby']
  }

  $bin = "${ruby::path}/god"
  $dir = config_path("god.d")
  $pid = pid_path($name)
  $log = log_path($name)
  $share = share_path($name)

  file { [ $dir, $share ]:
    ensure => directory
  }

  init_d { 'god':
    require => Gem['god']
  }
}

