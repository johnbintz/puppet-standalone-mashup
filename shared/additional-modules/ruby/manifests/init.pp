class ruby($version, $configure = "--disable-install-doc", $build_path = '') {
  $path = bin_path($name)
  $with_ruby_path = "${path}:${base::path}"

  build_and_install { $name:
    version => $version,
    source => "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-<%= version %>.tar.gz",
    configure => $configure,
    path => "${base::path}:${path}:${build_path}"
  }

  if ($osfamily == 'debian') {
    $packages = [
      'libyaml-dev', 'libreadline-dev', 'libssl-dev', 'libffi-dev',
      'libncurses5-dev', 'libcurl4-openssl-dev', 'zlib1g-dev',
      'libxml2', 'libxml2-dev', 'libxslt1.1', 'libxslt1-dev'
    ]

    package { $packages:
      ensure => installed,
      before => Build_and_install[$name]
    }

    bash_rc_d { 'ruby':
      ensure => present,
      path => $base::local_path,
      require => Build_and_install[$name]
    }
  }

  gem { [ 'bundler', 'penchant' ]:
    require => Build_and_install[$name],
    path => $with_ruby_path,
    ensure => present
  }
}

