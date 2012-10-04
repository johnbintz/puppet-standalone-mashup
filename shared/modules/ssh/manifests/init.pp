define ssh {
  $ssh_dir = "/home/${name}/.ssh"

  file { $ssh_dir:
    ensure => directory,
    mode => '0700',
    owner => $name,
    group => $name,
    require => User[$name]
  }

  file { "${ssh_dir}/authorized_keys":
    content => template("ssh/${name}/authorized_keys"),
    require => File[$ssh_dir],
    mode => '0644',
    owner => $name,
    group => $name
  }

  file { "${ssh_dir}/id_dsa":
    content => template("ssh/${name}/id_dsa"),
    require => File[$ssh_dir],
    mode => '0600',
    owner => $name,
    group => $name
  }

  file { "${ssh_dir}/id_dsa.pub":
    content => template("ssh/${name}/id_dsa.pub"),
    require => File[$ssh_dir],
    mode => '0644',
    owner => $name,
    group => $name
  }
}

