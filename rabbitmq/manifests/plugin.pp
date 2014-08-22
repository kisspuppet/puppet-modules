class rabbitmq::plugin {
  if $rabbitmq::enable_plugin {
    rabbitmq_plugin { $rabbitmq::enable_plugin :
      ensure  => present,
      require => $rabbitmq::install_reference,
      notify  => $rabbitmq::service_reference,
      provider => 'rabbitmqplugins'
    }
  }

  ## Add necessary plugin
  rabbitmq_plugin { 'rabbitmq_management':
    ensure  => present,
    require => $rabbitmq::install_reference,
    notify  => $rabbitmq::service_reference,
    provider => 'rabbitmqplugins'
  }

  file { 'rabbitmq_plugin_cli_management_tool':
    path    => '/usr/local/bin/rabbitmqadmin',
    source  => 'puppet:///modules/rabbitmq/rabbitmqadmin',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}
