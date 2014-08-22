class profiles::agent {
  $mq_uri                          = hiera('profiles::master::mq_uri')
  $master_uri                      = hiera('profiles::master::master_uri')
  $mq_mcollective_password         = hiera('profiles::master::mq_mcollective_password')

  class {'puppet':
    options => {
      master_uri  => $master_uri,
    },
    template => "profiles/agent/puppet/puppet.conf.erb",
  }
  
  class { 'mcollective_server':
    enable_module => ['puppet', 'service'],
    template => "profiles/agent/mcollective_server/server.cfg.erb",
    options  => {
      mcollective_password => $mq_mcollective_password,
      mq_uri => $mq_uri,
    },
  }

  contain 'puppet'
  contain 'mcollective_server'
}
