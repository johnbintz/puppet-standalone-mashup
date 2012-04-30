class basics {
  $packages = [ "ntp", "ntpdate", "gcc", "curl", "build-essential", "patch", 'sysstat', 'git-core' ]
  package { $packages: ensure => installed }

  bash_rc { "/etc/bash.bashrc": ensure => present }
}

class base {
  $path = "/usr/bin:/bin:/usr/sbin:/sbin"
  $src_path = "/usr/src"
  $install_path = "/usr/local"
  $config_path = "/etc"
  $pid_path = "/var/run"
  $local_path = $install_path
}

node default {
  include basics
  include debian

  class { base: require => Class['basics'] }

  include umask
}

