class minimal::service {
  ## Managed service
  if $minimal::service {
    service { 'minimal':
      name       => $minimal::service,
      ensure     => $minimal::service_ensure,
      enable     => $minimal::service_enable,
      hasstatus  => $minimal::service_hasstatus,
      hasrestart => $minimal::service_hasrestart,
      restart    => $minimal::service_restart,
      start      => $minimal::service_start,
      status     => $minimal::service_status,
      stop       => $minimal::service_stop,
    }
  }
}
