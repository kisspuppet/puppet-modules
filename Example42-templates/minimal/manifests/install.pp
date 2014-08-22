class minimal::install {
  ## Managed package
  if $minimal::package {
    package { 'minimal':
      name   => $minimal::package,
      ensure => $minimal::package_ensure,
    }
  }
}
