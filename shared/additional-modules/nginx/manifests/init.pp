class nginx($version) {
  gem { 'passenger':
    version => $version,
    path => "${ruby::with_ruby_path}",
    require => Build_and_install['ruby'],
    ensure => present
  }

  $install_path = install_path($name, $version)
  $symlink_path = symlink_path($name)

  exec { 'install-passenger':
    command => "passenger-install-nginx-module --auto --auto-download --prefix=${install_path}",
    path => $ruby::with_ruby_path,
    require => Gem['passenger'],
    unless => "test -d ${install_path}",
    timeout => 0,
    logoutput => on_failure
  }

  $pid_file  = pid_path($name)
  $sbin_path = sbin_path($name)

  $config_file = "${base::config_path}/nginx.conf"
  $config_path = "${base::config_path}/nginx"

  god_init { $name:
    start => "${sbin_path}/nginx -c ${config_file}",
    stop => "${sbin_path}/nginx -s stop -c ${config_file}",
    pid_file => $pid_file,
    ensure => present,
    notify => Service['god'],
    require => Exec['install-passenger']
  }

  file { [ '/var/log/nginx', $config_path ]:
    ensure => directory,
    before => God_init[$name]
  }

  file { [ "${config_path}/sites-available",  "${config_path}/sites-enabled" ]:
    ensure => directory,
    require => File[$config_path],
  }

  file { $config_file:
    content => template('nginx/nginx.conf'),
    before => God_init[$name]
  }

  file { "${config_path}/fastcgi.conf":
    content => template('nginx/fastcgi.conf'),
    require => File[$config_file]
  }

  file { "${config_path}/fastcgi_params":
    content => template('nginx/fastcgi_params'),
    require => File[$config_file]
  }

  file { '/var/www': ensure => directory }

  file { $symlink_path: ensure => $install_path }

  file { "${base::install_path}/bin/new-site":
    content => template('nginx/new-site'),
    mode => 755
  }
}

