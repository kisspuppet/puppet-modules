class rabbitmq::config{
  ## Managed main configuration file
  if $rabbitmq::aconfig_file {
    file { 'rabbitmq.conf':
      path    => $rabbitmq::config_file,
      ensure  => $rabbitmq::config_file_ensure,
      mode    => $rabbitmq::config_file_mode,
      owner   => $rabbitmq::config_file_owner,
      group   => $rabbitmq::config_file_group,
      source  => $rabbitmq::config_file_source,
      content => $rabbitmq::config_file_content,
      replace => $rabbitmq::config_file_replace,
      audit   => $rabbitmq::config_file_audit,
      notify  => $rabbitmq::service_reference,
      backup  => ".${rabbitmq::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if $rabbitmq::confdir {
    create_resources(rabbitmq::confdir,$rabbitmq::confdir)
  }
}
