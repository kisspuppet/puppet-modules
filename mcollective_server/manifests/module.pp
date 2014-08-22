define mcollective_server::module {
  $module_package_realname = $::osfamily ? {
    /(?i:redhat)/ => "mcollective-${title}-agent",
    default => '',
  }

  if $module_package_realname {
    package { "mcollective_server_module_${title}":
      name   => $module_package_realname,
      ensure => $mcollective_server::package_ensure,
      notify => $mcollective_server::service_reference,
      before => $mcollective_server::install_reference,
    }
  }
}

