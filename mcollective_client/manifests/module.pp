define mcollective_client::module {
  $module_package_realname = $::osfamily ? {
    /(?i:redhat)/ => "mcollective-${title}-client",
    default => '',
  }

  if $module_package_realname {
    package { "mcollective_client_module_${title}":
      name   => $module_package_realname,
      ensure => $mcollective_client::package_ensure,
      notify => $mcollective_client::service_reference,
      before => $mcollective_client::install_reference,
    }
  }
}

