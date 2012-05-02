class god {
  gem { 'god':
    path => "${ruby::path}:${base::path}",
    ensure => present,
    require => Make_and_install['ruby']
  }

  $bin = "${base::install_path}/ruby/bin/god"
  $dir = config_path("god.d")
  $pid = pid_path($name)
  $log = log_path($name)
  $share = share_path($name)

  file { [ $dir, $share ]:
    ensure => directory
  }
}

