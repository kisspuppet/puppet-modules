class activemq::service {
  ## Managed service
  if $activemq::service {
    service { 'activemq':
      name       => $activemq::service,
      ensure     => $activemq::service_ensure,
      enable     => $activemq::service_enable,
      hasstatus  => $activemq::service_hasstatus,
      hasrestart => $activemq::service_hasrestart,
      restart    => $activemq::service_restart,
      start      => $activemq::service_start,
      status     => $activemq::service_status,
      stop       => $activemq::service_stop,
    }
  }
}
