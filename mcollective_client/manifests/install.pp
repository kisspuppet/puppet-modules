class mcollective_client::install {
  ## Managed package
  if $mcollective_client::package {
    package { 'mcollective_client':
      name   => $mcollective_client::package,
      ensure => $mcollective_client::package_ensure,
    }

    if $mcollective_client::enable_module {
      mcollective_client::module { $mcollective_client::enable_module: }
    }
  }
}
