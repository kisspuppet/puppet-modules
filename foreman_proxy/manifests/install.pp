class foreman_proxy::install {
  ## Managed package
  if $foreman_proxy::package {
    package { 'foreman_proxy':
      name   => $foreman_proxy::package,
      ensure => $foreman_proxy::package_ensure,
    }

    if $foreman_proxy::install_options {
      $install_command = "foreman-installer ${foreman_proxy::install_options}"
    }
    else {
      $install_command = "foreman-installer --no-enable-puppet --no-enable-foreman --enable-foreman-proxy  --puppet-server=true --foreman-proxy-puppetca=true   --foreman-proxy-register-in-foreman=false --foreman-proxy-tftp=true --foreman-proxy-dhcp=true  --foreman-configure-epel-repo=false --foreman-configure-scl-repo=false --foreman-custom-repo=true --foreman-proxy-custom-repo=true --foreman-proxy-puppetrun-provider=mcollective"
    }

    exec { 'foreman_proxy_install_installer':
      command => $install_command,
      path    => ['/bin','/sbin','/usr/bin','/usr/sbin'],
      timeout => 0,
      user    => 'root',
      require => $foreman_proxy::install_reference,
    }
  }
}
