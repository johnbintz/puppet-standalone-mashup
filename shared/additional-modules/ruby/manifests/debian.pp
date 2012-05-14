class ruby::debian($version) {
  $packages = [
    'libyaml-dev', 'libreadline-dev', 'libssl-dev', 'libffi-dev',
    'libncurses5-dev', 'libcurl4-openssl-dev', 'zlib1g-dev',
    'libxml2', 'libxml2-dev', 'libxslt1.1', 'libxslt1-dev'
  ]

  package { $packages: ensure => installed }

  class { ruby: version => $version, require => Package[$packages] }

  bash_rc_d { 'ruby':
    ensure => present,
    path => $base::local_path
  }
}

