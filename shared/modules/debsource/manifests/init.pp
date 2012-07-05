define debsource($apt_source, $keyfile = '', $host = '', $hash = '') {
  $file =  "/etc/apt/sources.list.d/${name}.list"
  file { $file: content => $apt_source }

  if ($host != '') {
    exec { "debsource-${name}":
      command => "apt-key adv --keyserver ${host} --recv ${hash} && apt-get update",
      unless => "test $(apt-key list | grep ${hash} | wc -l) -ne 0",
      path => $base::path,
      require => File[$file]
    }
  }

  if ($keyfile != '') {
    exec { "debsource-${name}":
      command => "curl $keyfile | apt-key add - && apt-get update",
      path => $base::path,
      require => File[$file],
      unless => "test $(apt-key list | grep ${hash} | wc -l) -ne 0"
    }
  }
}

