class mcollective_server::config{
  ## Managed main configuration file
  if $mcollective_server::config_file {
    file { 'mcollective_server.conf':
      path    => $mcollective_server::config_file,
      ensure  => $mcollective_server::config_file_ensure,
      mode    => $mcollective_server::config_file_mode,
      owner   => $mcollective_server::config_file_owner,
      group   => $mcollective_server::config_file_group,
      source  => $mcollective_server::config_file_source,
      content => $mcollective_server::config_file_content,
      replace => $mcollective_server::config_file_replace,
      audit   => $mcollective_server::config_file_audit,
      notify  => $mcollective_server::service_reference,
      backup  => ".${mcollective_server::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if $mcollective_server::confdir {
    create_resources(mcollective_server::confdir,$mcollective_server::confdir)
  }
}
