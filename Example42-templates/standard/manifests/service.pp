class standard::service {
  ## Managed service
  if $standard::service {
    service { 'standard':
      name       => $standard::service,
      ensure     => $standard::service_ensure,
      enable     => $standard::service_enable,
      hasstatus  => $standard::service_hasstatus,
      hasrestart => $standard::service_hasrestart,
      restart    => $standard::service_restart,
      start      => $standard::service_start,
      status     => $standard::service_status,
      stop       => $standard::service_stop,
    }
  }
}
