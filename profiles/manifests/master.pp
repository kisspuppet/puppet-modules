class profiles::master {
  $foreman_uri               = hiera('profiles::master::foreman_uri')
  $mq_uri                    = hiera('profiles::master::mq_uri')
  $master_uri                = hiera('profiles::master::master_uri')
  $share_cert                = hiera('profiles::master::share_cert')
  $mq_mcollective_password   = hiera('profiles::master::mq_mcollective_password')
  $mq_admin_password         = hiera('profiles::master::mq_admin_password')

  class initial {
    exec { 'puppet master initial':
      command => "service puppetmaster start && service puppetmaster stop",
      path    => ":/bin:/sbin:/usr/bin:/usr/sbin",
      unless  => "netstat -tulnp | grep 8140",
    }
  }

  class hack_puppet_server {
    file { 'foreman.rb':
      path    => "${::rubysitedir}/puppet/reports/foreman.rb",
      ensure  => $puppet_server::config_file_ensure,
      mode    => $puppet_server::config_file_mode,
      owner   => $puppet_server::config_file_owner,
      group   => $puppet_server::config_file_group,
      content => template('profiles/master/puppet_server_new/foreman.rb.erb'),
      require => $puppet_server::install_reference,
      notify  => $puppet_server::service_reference,
      backup  => ".${puppet_server::system_date}.bak",
    }
  }

  class { 'puppet_server':
    options => {
      master_uri  => $master_uri,
      foreman_uri => $foreman_uri,
    },
    template => 'profiles/master/puppet_server/puppet.conf.erb',
    confdir => {
      'environments' => {
        ensure => directory,
        source => "puppet:///modules/profiles/master/puppet_server/environments",
      },
      'node.rb' => {
        template => "profiles/master/puppet_server_new/node.rb.erb",
        mode => 0755,
      },
      'hiera.yaml' =>  {
        source => "puppet:///modules/profiles/master/puppet_server/hiera.yaml",
      },
      'rack' => {
        ensure => directory,
        source => "puppet:///modules/profiles/master/puppet_server/rack",
        owner  => 'puppet',
        group  => 'puppet',
      },
    },
    my_class => 'profiles::master::hack_puppet_server',
  }

  class { 'apache':
    enable_module => ['ssl','passenger'],
    confdir => {
      'puppetmaster.conf' => {
        template => "profiles/master/apache/puppetmaster.conf.erb"
      },
    },
  }

  class { 'mcollective_client':
    enable_module => ['puppet', 'service'],
    template => "profiles/master/mcollective_client/client.cfg.erb",
    options => {
      mcollective_password => $mq_mcollective_password,
      mq_uri             => $mq_uri,
    },
  }

  class hack_foreman_proxy {
    file { '/etc/sudoers.d/foreman-proxy':
      ensure  => present,
      mode    => '0440',
      owner   => 'root',
      group   => 'root',
      content => template('profiles/master/foreman_proxy/foreman-proxy.erb'),
      require => $foreman_proxy::install_reference,
      notify  => $foreman_proxy::service_reference,
      backup  => ".${foreman_proxy::system_date}.bak",
    }
  }

  class { 'foreman_proxy':
    my_class => 'profiles::master::hack_foreman_proxy',
    ## only for foreman-1.5.2
    install_options => "--no-enable-puppet --no-enable-foreman --enable-foreman-proxy  --foreman-proxy-puppetca=true   --foreman-proxy-register-in-foreman=false --foreman-proxy-tftp=false --foreman-proxy-dhcp=false --foreman-proxy-dns=false --foreman-configure-epel-repo=false --foreman-configure-scl-repo=false --foreman-custom-repo=true --foreman-proxy-custom-repo=true --foreman-proxy-puppetrun-provider=mcollective --no-enable-foreman-plugin-bootdisk --no-enable-foreman-plugin-setup",
  }

  class { 'mcollective_server':
    enable_module => ['puppet', 'service'],
    template => "profiles/agent/mcollective_server/server.cfg.erb",
    options  => {
      mcollective_password => $mq_mcollective_password,
      mq_uri => $mq_uri,
    },
  }

  contain 'profiles::master::initial'
  contain 'puppet_server'
  contain 'apache'
  contain 'mcollective_client'
  contain 'foreman_proxy'
  contain 'mcollective_server'

  Class['puppet_server'] -> Class['profiles::master::initial'] -> Class['apache'] -> Class['foreman_proxy'] -> Class['mcollective_client'] -> Class['mcollective_server']
}
