class debian {
  $varnish_apt_source = "deb http://repo.varnish-cache.org/debian/ squeeze varnish-3.0"
  $varnish_keyfile = "http://repo.varnish-cache.org/debian/GPG-key.txt"
  $varnish_hash = "C4DEFFEB"

  $mongo_apt_source = "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen"
  $mongo_host = "keyserver.ubuntu.com"
  $mongo_hash = "7F0CEB10"
}

