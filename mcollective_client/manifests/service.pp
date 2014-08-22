class mcollective_client::service {
  ## Managed service
  if $mcollective_client::service {
    service { 'mcollective_client':
      name       => $mcollective_client::service,
      ensure     => $mcollective_client::service_ensure,
      enable     => $mcollective_client::service_enable,
      hasstatus  => $mcollective_client::service_hasstatus,
      hasrestart => $mcollective_client::service_hasrestart,
      restart    => $mcollective_client::service_restart,
      start      => $mcollective_client::service_start,
      status     => $mcollective_client::service_status,
      stop       => $mcollective_client::service_stop,
    }
  }
}
