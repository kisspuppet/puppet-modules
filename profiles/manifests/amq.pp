class profiles::amq {
  $mq_mcollective_password = hiera('profiles::master::mq_mcollective_password')
  $mq_admin_password       = hiera('profiles::master::mq_admin_password')

  class { 'activemq':
    keystore_password             => $keystore_password,
    options => {
      activemq_mcollective_password => $mq_mcollective_password,
      activemq_admin_password       => $mq_admin_password,
      keystore_password             => "Sj38;e!",
    },
    template => "profiles/amq/activemq/activemq.xml.erb",
  }

  contain activemq
}
