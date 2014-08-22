class profiles::rmq {
  $mq_mcollective_password = hiera('profiles::master::mq_mcollective_password')
  $mq_admin_password       = hiera('profiles::master::mq_admin_password')

  class hack_rabbitmq {
    rabbitmq_user { 'guest':
      ensure => absent,
      require => $rabbitmq::service_reference,
    }
  }

  class { 'rabbitmq':
    enable_plugin => 'rabbitmq_stomp',
    instance => {
      'admin@/mcollective' => {
        user     => 'admin',
        password => "${mq_admin_password}",
        vhost    => '/mcollective',
        admin    => true,
      },
      'mcollective@/mcollecitve' => {
        user     => 'mcollective',
        password => "${mq_mcollective_password}",
        vhost    => '/mcollective',
      },
    },
    exchange => {
      'mcollective_broadcast@/mcollective' => {
        user     => 'admin',
        password => "${mq_admin_password}",
        type     => 'topic',
      },
      'mcollective_directed@/mcollective' => {
        user     => 'admin',
        password => "${mq_admin_password}",
        type     => 'direct',
      },
    },
    my_class => 'profiles::rmq::hack_rabbitmq',
  }

  contain 'rabbitmq'
}
