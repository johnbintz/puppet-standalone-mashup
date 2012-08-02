define remotedeb($url, $version) {
  $deb = "/tmp/${name}.deb"

  exec { "remotedeb-${name}":
    command => "curl -o ${deb} ${url} && dpkg -i ${deb}",
    unless => "test $(dpkg -l ${name} | grep ${version} | wc -l) -eq 0",
    path => $base::path
  }
}

