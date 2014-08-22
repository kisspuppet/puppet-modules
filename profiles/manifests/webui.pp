class profiles::webui {
  $master_uri                      = hiera('profiles::master::master_uri')
  $mq_uri                          = hiera('profiles::master::mq_uri')
  $mq_mcollective_password         = hiera('profiles::master::mq_mcollective_password')

  class hack_foreman {
    exec { 'install_foreman_bootdisk':
      command => "yum install -y ruby193-rubygem-foreman_bootdisk",
      unless  => "rpm -q ruby193-rubygem-foreman_bootdisk",
      path    => "/bin:/sbin:/usr/bin:/usr/sbin",
      before  => $foreman::install_reference,
    }

    exec { 'install_foreman_setup':
      command => "yum install -y ruby193-rubygem-foreman_setup",
      unless  => "rpm -q ruby193-rubygem-foreman_setup",
      path    => "/bin:/sbin:/usr/bin:/usr/sbin",
      before  => $foreman::install_reference,
    }
  }
  class {'puppet':
    options => {
      master_uri  => $master_uri,
    },
    template => "profiles/webui/puppet/puppet.conf.erb",
  }

  class { 'mcollective_server':
    enable_module => ['puppet', 'service'],
    template => "profiles/agent/mcollective_server/server.cfg.erb",
    options  => {
      mcollective_password => $mq_mcollective_password,
      mq_uri => $mq_uri,
    },
  }

  class { 'foreman':
    my_class => 'profiles::webui::hack_foreman',
    ## only for foreman-1.5.2
    install_options => '--enable-foreman --enable-foreman-proxy --no-enable-puppet --puppet-server=false --foreman-proxy-puppetrun=false  --foreman-proxy-puppetca=false --foreman-proxy-tftp=true --foreman-proxy-dhcp=true --foreman-proxy-dhcp-managed=true --foreman-proxy-dns=true --foreman-proxy-dns-managed=true --foreman-configure-epel-repo=false --foreman-configure-scl-repo=false --foreman-custom-repo=true --enable-foreman-plugin-bootdisk   --enable-foreman-plugin-setup',
  }

  contain 'puppet'
  contain 'foreman'
  contain 'mcollective_server'

  Class['puppet'] -> Class['foreman'] -> Class['mcollective_server']
}
