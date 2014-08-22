class simple::install {
  ## Managed package
  if $simple::package {
    package { 'simple':
      name   => $simple::package,
      ensure => $simple::package_ensure,
    }
  }
}
