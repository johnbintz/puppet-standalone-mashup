class ruby($version = '', $deb_url = '', $configure = "--disable-install-doc", $build_path = '') {
  gem { [ 'bundler', 'penchant' ]:
    path => "${path}:${base::path}",
    ensure => present
  }

  if ($::osfamily == 'debian') {
    $path = '/usr/bin'

    remotedeb { ruby:
      url => $deb_url,
      version => $version
    }

    Remotedeb[ruby] -> Gem['bundler', 'penchant']
  } else {
    $path = bin_path($name)

    build_and_install { $name:
      version => $version,
      source => "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-<%= version %>.tar.gz",
      configure => $configure,
      preconfigure => "LDFLAGS='-rdynamic -Wl,-export-dynamic'",
      path => "${build_path}:${with_ruby_path}"
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

    Build_and_install[ruby] -> Gem['bundler', 'penchant']
  }
}

