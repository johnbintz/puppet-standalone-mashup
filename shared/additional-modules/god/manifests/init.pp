class god {
  gem { 'god':
    path => "${ruby::path}:${base::path}",
    ensure => present,
    require => Make_and_install['ruby']
  }

  $god_bin = "${base::install_path}/ruby/bin/god"
  $god_dir = "${base::config_path}/god.d"
  $pid_path = pid_path($name)

  file { $god_dir:
    ensure => directory
  }

  $share = "${base::share_path}/god"
  file { $share: ensure => directory }
}

