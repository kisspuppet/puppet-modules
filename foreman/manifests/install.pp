class foreman::install {
  ## Managed package
  if $foreman::package {
    package { 'foreman':
      name   => $foreman::package,
      ensure => $foreman::package_ensure,
    }

    if $foreman::install_options {
      $install_command = "foreman-installer ${foreman::install_options}"
    }
    else {
      $install_command = "foreman-installer --enable-foreman --no-enable-foreman-proxy --no-enable-puppet  --foreman-configure-epel-repo=false --foreman-configure-scl-repo=false --foreman-custom-repo=true"
    }

    exec { 'foreman_install_installer':
      command => $install_command,
      path    => ['/bin','/sbin','/usr/bin','/usr/sbin'],
      timeout => 0,
#      unless  => "netstat -tulnp |grep 443",
      user    => 'root',
      require => $foreman::install_reference,
    }
  }
}
