class php::install {
  ## Managed package
  if $php::package {
    package { 'php':
      name   => $php::package,
      ensure => $php::package_ensure,
    }

    if $php::enable_module {
      php::module { $php::enable_module: }
    }
  }
}
