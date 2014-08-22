class mcollective_server::install {
  ## Managed package
  if $mcollective_server::package {
    package { 'mcollective_server':
      name   => $mcollective_server::package,
      ensure => $mcollective_server::package_ensure,
    }

    if $mcollective_server::enable_module {
      mcollective_server::module { $mcollective_server::enable_module: }
    }
  }
}
