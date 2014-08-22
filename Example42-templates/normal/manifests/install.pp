class normal::install {
  ## Managed package
  if $normal::package {
    package { 'normal':
      name   => $normal::package,
      ensure => $normal::package_ensure,
    }
  }
}
