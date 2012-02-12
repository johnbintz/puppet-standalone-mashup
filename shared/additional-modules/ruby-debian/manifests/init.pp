class ruby-debian {
  $packages = [
    'libyaml-dev', 'libreadline-dev', 'libssl-dev', 'libffi-dev',
    'libncurses5-dev', 'libcurl4-openssl-dev',
    'libxml2', 'libxml2-dev', 'libxslt1.1', 'libxslt1-dev'
  ]

  package { $packages: ensure => installed }
}

