class puppet::install {
  ## Managed package
  if $puppet::package {
    package { 'puppet':
      name   => $puppet::package,
      ensure => $puppet::package_ensure,
    }
  }
}
