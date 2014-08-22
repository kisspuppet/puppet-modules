class simple::service {
  ## Managed service
  if $simple::service {
    service { 'simple':
      name       => $simple::service,
      ensure     => $simple::service_ensure,
      enable     => $simple::service_enable,
      hasstatus  => $simple::service_hasstatus,
      hasrestart => $simple::service_hasrestart,
      restart    => $simple::service_restart,
      start      => $simple::service_start,
      status     => $simple::service_status,
      stop       => $simple::service_stop,
    }
  }
}
