class apache::install {
  ## Managed package
  if $apache::package {
    package { 'apache':
      name   => $apache::package,
      ensure => $apache::package_ensure,
    }

    if $apache::enable_module {
      apache::module { $apache::enable_module: }
    }
  }
}
