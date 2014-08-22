class foreman_proxy::service {
  ## Managed service
  if $foreman_proxy::service {
    service { 'foreman_proxy':
      name       => $foreman_proxy::service,
      ensure     => $foreman_proxy::service_ensure,
      enable     => $foreman_proxy::service_enable,
      hasstatus  => $foreman_proxy::service_hasstatus,
      hasrestart => $foreman_proxy::service_hasrestart,
      restart    => $foreman_proxy::service_restart,
      start      => $foreman_proxy::service_start,
      status     => $foreman_proxy::service_status,
      stop       => $foreman_proxy::service_stop,
    }
  }
}
