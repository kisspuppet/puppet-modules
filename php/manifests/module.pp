define php::module {
  $module_package_basename = $::osfamily ? {
    /(?i:redhat)/ => 'php-',
    default => '',
  }

  $module_package_realname = "${module_package_basename}${title}"

  if $module_package_basename {
    package { "php_module_${titile}":
      name   => $module_package_realname,
      ensure => $php::package_ensure,
      before => $php::install_reference,
    }
  }
}

