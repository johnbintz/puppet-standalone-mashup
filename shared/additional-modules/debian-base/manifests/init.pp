class basics {
  $packages = [ "ntp", "ntpdate", "gcc", "curl", "build-essential", "patch", 'sysstat', 'git-core', 'vim' ]
  package { $packages: ensure => installed }

  bash_rc { "/etc/bash.bashrc": ensure => present }
}

class base {
  $path = "/usr/bin:/bin:/usr/sbin:/sbin"
  $src_path = "/usr/src"
  $install_path = "/usr/local"
  $config_path = "/etc"
  $pid_path = "/var/run"
  $data_path = "/var/data"
  $log_path = "/var/log"
  $local_path = $install_path
  $share_path = "/usr/local/share"
  $data_path = "/var/data"
}

node default {
  include basics
  include debian

  class { base: require => Class['basics'] }
}

