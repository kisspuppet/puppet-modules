class activemq::config{
  ## Managed main configuration file
  if $activemq::config_file {
    file { 'activemq.conf':
      path    => $activemq::config_file,
      ensure  => $activemq::config_file_ensure,
      mode    => $activemq::config_file_mode,
      owner   => $activemq::config_file_owner,
      group   => $activemq::config_file_group,
      source  => $activemq::config_file_source,
      content => $activemq::config_file_content,
      replace => $activemq::config_file_replace,
      audit   => $activemq::config_file_audit,
      notify  => $activemq::service_reference,
      backup  => ".${activemq::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if $activemq::confdir {
    create_resources(activemq::confdir,$activemq::confdir)
  }
}
