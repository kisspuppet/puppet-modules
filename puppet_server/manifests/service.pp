class puppet_server::service {
  ## Managed service
  if $puppet_server::service {
    service { 'puppet_server':
      name       => $puppet_server::service,
      ensure     => $puppet_server::service_ensure,
      enable     => $puppet_server::service_enable,
      hasstatus  => $puppet_server::service_hasstatus,
      hasrestart => $puppet_server::service_hasrestart,
      restart    => $puppet_server::service_restart,
      start      => $puppet_server::service_start,
      status     => $puppet_server::service_status,
      stop       => $puppet_server::service_stop,
    }
  }
}
