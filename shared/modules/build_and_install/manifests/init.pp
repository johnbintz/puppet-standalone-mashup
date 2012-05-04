define build_and_install($version, $original_name = '', $source, $path = '', $configure = '', $config_status = 'config.status') {
  $full_source = inline_template($source)

  $build_path   = build_path($name, $version)
  $install_path = install_path($name, $version)
  $symlink_path = symlink_path($name)

  download_and_unpack { $name:
    url => $full_source,
    src_path => $base::src_path,
    original_name => $original_name,
    version => $version,
    ensure => present
  }

  configure { $name:
    build_path => $build_path,
    install_path => $install_path,
    options => $configure,
    path => $path,
    require => Download_and_unpack[$name],
    config_status => $config_status,
    ensure => present
  }

  make_and_install { $name:
    build_path => $build_path,
    install_path => $install_path,
    path => $path,
    require => Configure[$name],
    ensure => present
  }
}

