class activemq::install {
  ## Managed package
  if $activemq::package {
    package { 'activemq':
      name   => $activemq::package,
      ensure => $activemq::package_ensure,
    }
  }
}
