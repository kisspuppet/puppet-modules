class puppet_server::config{
  ## Managed main configuration file
  if $puppet_server::config_file {
    file { 'puppet_server.conf':
      path    => $puppet_server::config_file,
      ensure  => $puppet_server::config_file_ensure,
      mode    => $puppet_server::config_file_mode,
      owner   => $puppet_server::config_file_owner,
      group   => $puppet_server::config_file_group,
      source  => $puppet_server::config_file_source,
      content => $puppet_server::config_file_content,
      replace => $puppet_server::config_file_replace,
      audit   => $puppet_server::config_file_audit,
      notify  => $puppet_server::service_reference,
      backup  => ".${puppet_server::system_date}.bak",
    }
  }

  ## Managed initial configuration file
  if $puppet_server::config_file_init {
    file { 'puppet_server_init.conf':
      path    => $puppet_server::config_file_init,
      ensure  => $puppet_server::config_file_ensure,
      mode    => $puppet_server::config_file_mode,
      owner   => $puppet_server::config_file_owner,
      group   => $puppet_server::config_file_group,
      source  => $puppet_server::config_file_init_source,
      replace => $puppet_server::config_file_replace,
      audit   => $puppet_server::config_file_audit,
      notify  => $puppet_server::service_reference,
      backup  => ".${puppet_server::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if $puppet_server::confdir {
    create_resources(puppet_server::confdir,$puppet_server::confdir)
  }
}
