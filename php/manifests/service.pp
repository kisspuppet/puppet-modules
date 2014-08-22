class php::service {
  ## Managed service
  if $php::service {
    service { 'php':
      name       => $php::service,
      ensure     => $php::service_ensure,
      enable     => $php::service_enable,
      hasstatus  => $php::service_hasstatus,
      hasrestart => $php::service_hasrestart,
      restart    => $php::service_restart,
      start      => $php::service_start,
      status     => $php::service_status,
      stop       => $php::service_stop,
    }
  }
}
