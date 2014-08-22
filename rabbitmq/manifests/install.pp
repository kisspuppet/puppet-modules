class rabbitmq::install {
  ## Managed package
  if $rabbitmq::package {
    package { 'rabbitmq':
      name   => $rabbitmq::package,
      ensure => $rabbitmq::package_ensure,
    }
  }
}
