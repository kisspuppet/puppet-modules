class normal::service {
  ## Managed service
  if $normal::service {
    service { 'normal':
      name       => $normal::service,
      ensure     => $normal::service_ensure,
      enable     => $normal::service_enable,
      hasstatus  => $normal::service_hasstatus,
      hasrestart => $normal::service_hasrestart,
      restart    => $normal::service_restart,
      start      => $normal::service_start,
      status     => $normal::service_status,
      stop       => $normal::service_stop,
    }
  }
}
