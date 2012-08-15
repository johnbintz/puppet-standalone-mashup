define mkdir_p($path, $owner = '') {
  exec { "mkdir -p ${name}":
    path => $path,
    unless => "test -d ${name}"
  }

  if ($owner != '') {
    exec { "chown ${owner} ${name}":
      path => $path,
      require => Exec["mkdir -p ${name}"]
    }
  }
}

