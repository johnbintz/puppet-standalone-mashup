define running_service {
  service { $name: ensure => running }
}
