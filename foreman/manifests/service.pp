class foreman::service {
  ## Managed service
  if $foreman::service {
    service { 'foreman':
      name       => $foreman::service,
      ensure     => $foreman::service_ensure,
      enable     => $foreman::service_enable,
      hasstatus  => $foreman::service_hasstatus,
      hasrestart => $foreman::service_hasrestart,
      restart    => $foreman::service_restart,
      start      => $foreman::service_start,
      status     => $foreman::service_status,
      stop       => $foreman::service_stop,
    }
  }
}
