class flush_software {
  file { "${base::install_path}/flush-software":
    content => template('flush_software/flush-software'),
    mode => 0775
  }
}
