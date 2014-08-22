class ntp::install {
  ## Managed package
  if $ntp::package {
    package { 'ntp':
      name   => $ntp::package,
      ensure => $ntp::package_ensure,
    }
  }
}
