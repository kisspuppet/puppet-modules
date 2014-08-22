class apache::service {
  ## Managed service
  if $apache::service {
    service { 'apache':
      name       => $apache::service,
      ensure     => $apache::service_ensure,
      enable     => $apache::service_enable,
      hasstatus  => $apache::service_hasstatus,
      hasrestart => $apache::service_hasrestart,
      restart    => $apache::service_restart,
      start      => $apache::service_start,
      status     => $apache::service_status,
      stop       => $apache::service_stop,
    }
  }
}
