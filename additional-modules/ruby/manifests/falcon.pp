class ruby::falcon($version, $configure, $build_path) {
  class { ruby:
    version => $version,
    configure => $configure,
    build_path => $build_path
  }

  file { '/tmp/ruby-falcon-patch.sh':
    content => template('ruby/falcon-patch.sh'),
    before => Configure['ruby'],
    mode => 755
  }

  exec { 'patch-ruby':
    command => "ruby-falcon-patch.sh",
    before => Configure['ruby'],
    cwd => build_path('ruby', $version),
    unless => 'test -f patched',
    logoutput => true,
    path => "/tmp:$base::path"
  }
}

