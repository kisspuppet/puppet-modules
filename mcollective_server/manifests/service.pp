class mcollective_server::service {
  ## Managed service
  if $mcollective_server::service {
    service { 'mcollective_server':
      name       => $mcollective_server::service,
      ensure     => $mcollective_server::service_ensure,
      enable     => $mcollective_server::service_enable,
      hasstatus  => $mcollective_server::service_hasstatus,
      hasrestart => $mcollective_server::service_hasrestart,
      restart    => $mcollective_server::service_restart,
      start      => $mcollective_server::service_start,
      status     => $mcollective_server::service_status,
      stop       => $mcollective_server::service_stop,
    }
  }
}
