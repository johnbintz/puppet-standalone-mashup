define mkdir_p($path) {
  exec { "mkdir -p ${name}":
    path => $path,
    unless => "test -d ${name}"
  }
}

