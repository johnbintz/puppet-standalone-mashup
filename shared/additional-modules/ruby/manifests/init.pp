class ruby($version) {
  $path = bin_path($name)
  $with_ruby_path = "${path}:${base::path}"

  build_and_install { $name:
    version => $version,
    source => "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-<%= version %>.tar.gz",
    require => Class['base']
  }

  gem { 'bundler':
    require => Build_and_install[$name],
    path => $with_ruby_path,
    ensure => present
  }

  bash_rc_d { $name:
    ensure => present,
    path => $base::local_path,
    require => Build_and_install[$name]
  }
}

