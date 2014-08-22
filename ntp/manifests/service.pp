class ntp::service {
  ## Managed service
  if $ntp::service {
    service { 'ntp':
      name       => $ntp::service,
      ensure     => $ntp::service_ensure,
      enable     => $ntp::service_enable,
      hasstatus  => $ntp::service_hasstatus,
      hasrestart => $ntp::service_hasrestart,
      restart    => $ntp::service_restart,
      start      => $ntp::service_start,
      status     => $ntp::service_status,
      stop       => $ntp::service_stop,
    }
  }
}
