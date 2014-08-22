class rabbitmq::service {
  ## Managed service
  if $rabbitmq::service {
    service { 'rabbitmq':
      name       => $rabbitmq::service,
      ensure     => $rabbitmq::service_ensure,
      enable     => $rabbitmq::service_enable,
      hasstatus  => $rabbitmq::service_hasstatus,
      hasrestart => $rabbitmq::service_hasrestart,
      restart    => $rabbitmq::service_restart,
      start      => $rabbitmq::service_start,
      status     => $rabbitmq::service_status,
      stop       => $rabbitmq::service_stop,
    }
  }
}
