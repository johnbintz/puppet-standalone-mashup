class basics {
  $packages = [
    "ntp", "ntpdate", "gcc", "curl",
    "build-essential", "patch", 'sysstat',
    'git-core', 'vim', 'libffi5'
  ]

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
}

define init_d {
  $init_d_prerun = template("${name}/${::osfamily}/init_d_prerun")
  $init_d_prolog = template("${name}/${::osfamily}/init_d_prolog")

  file { "/etc/init.d/${name}":
    content => template("${name}/${name}-init.d"),
    mode => 755
  }

  $update_rc_d = "update-rc.d ${name}"
  exec { $update_rc_d:
    command => "update-rc.d ${name} defaults",
    require => File["/etc/init.d/${name}"],
    path => $base::path
  }

  service { $name:
    require => Exec[$update_rc_d],
    ensure => running
  }
}

node default {
  include basics
  include debian

  class { base: require => Class['basics'] }
}

