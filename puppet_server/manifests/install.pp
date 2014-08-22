class puppet_server::install {
  ## Managed package
  if $puppet_server::package {
    package { 'puppet_server':
      name   => $puppet_server::package,
      ensure => $puppet_server::package_ensure,
    }
  }
}
