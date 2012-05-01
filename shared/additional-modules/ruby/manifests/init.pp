class ruby($version) {
  $path = bin_path($name)
  $with_ruby_path = "${path}:${base::path}"

  build_and_install { $name:
    version => $version,
    source => "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-<%= version %>.tar.gz",
    configure => "--disable-install-doc"
  }

  gem { [ 'bundler', 'penchant' ]:
    require => Build_and_install[$name],
    path => $with_ruby_path,
    ensure => present
  }
}

