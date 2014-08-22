class mysql_server::service {
  ## Managed service
  if $mysql_server::service {
    service { 'mysql_server':
      name       => $mysql_server::service,
      ensure     => $mysql_server::service_ensure,
      enable     => $mysql_server::service_enable,
      hasstatus  => $mysql_server::service_hasstatus,
      hasrestart => $mysql_server::service_hasrestart,
      restart    => $mysql_server::service_restart,
      start      => $mysql_server::service_start,
      status     => $mysql_server::service_status,
      stop       => $mysql_server::service_stop,
    }
  }
}
