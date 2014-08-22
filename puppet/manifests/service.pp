class puppet::service {
  ## Managed service
  if $puppet::service {
    service { 'puppet':
      name       => $puppet::service,
      ensure     => $puppet::service_ensure,
      enable     => $puppet::service_enable,
      hasstatus  => $puppet::service_hasstatus,
      hasrestart => $puppet::service_hasrestart,
      restart    => $puppet::service_restart,
      start      => $puppet::service_start,
      status     => $puppet::service_status,
      stop       => $puppet::service_stop,
    }
  }
}
