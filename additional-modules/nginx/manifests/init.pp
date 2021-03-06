class nginx($version, $max_pool_size = 20) {
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

  $nginx_start = "${sbin_path}/nginx -c ${config_file}"
  $nginx_stop =  "${sbin_path}/nginx -s stop -c ${config_file}"
  god_init { $name:
    start => $nginx_start,
    stop => $nginx_stop,
    restart => "${nginx_stop} ; ${nginx_start}",
    pid_file => $pid_file,
    ensure => present,
    require => Exec['install-passenger']
  }

  file { $config_path:
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
    mode => 644,
    require => File[$config_file]
  }

  file { "${config_path}/fastcgi_params":
    content => template('nginx/fastcgi_params'),
    mode => 644,
    require => File[$config_file]
  }

  file { '/var/www':
    ensure => directory,
    group => web,
    mode => 2775,
    require => Group['web']
  }

  file { $symlink_path:
    ensure => $install_path,
    require => Exec['install-passenger']
  }
}

