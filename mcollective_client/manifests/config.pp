class mcollective_client::config{
  ## Managed main configuration file
  if $mcollective_client::config_file {
    file { 'mcollective_client.conf':
      path    => $mcollective_client::config_file,
      ensure  => $mcollective_client::config_file_ensure,
      mode    => $mcollective_client::config_file_mode,
      owner   => $mcollective_client::config_file_owner,
      group   => $mcollective_client::config_file_group,
      source  => $mcollective_client::config_file_source,
      content => $mcollective_client::config_file_content,
      replace => $mcollective_client::config_file_replace,
      audit   => $mcollective_client::config_file_audit,
      notify  => $mcollective_client::service_reference,
      backup  => ".${mcollective_client::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if $mcollective_client::confdir {
    create_resources(mcollective_client::confdir,$mcollective_client::confdir)
  }
}
