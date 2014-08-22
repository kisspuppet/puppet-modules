class standard::install {
  ## Managed package
  if $standard::package {
    package { 'standard':
      name   => $standard::package,
      ensure => $standard::package_ensure,
    }
  }
}
