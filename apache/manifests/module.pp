define apache::module {
  $module_package_basename = $::osfamily ? {
    /(?i:redhat)/ => 'mod_',
    default => '',
  }

  $module_package_realname = "${module_package_basename}${name}"

  if $module_package_basename {
    package { "apache_module_${name}":
      name   => $module_package_realname,
      ensure => $apache::package_ensure,
      notify => $apache::service_reference,
      before => $apache::install_reference,
    }
  }
}
