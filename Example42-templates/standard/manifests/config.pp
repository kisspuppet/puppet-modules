class standard::config{
  ## Managed main configuration file
  if $standard::config_file {
    file { 'standard.conf':
      path    => $standard::config_file,
      ensure  => $standard::config_file_ensure,
      mode    => $standard::config_file_mode,
      owner   => $standard::config_file_owner,
      group   => $standard::config_file_group,
      source  => $standard::config_file_source,
      content => $standard::config_file_content,
      replace => $standard::config_file_replace,
      audit   => $standard::config_file_audit,
      notify  => $standard::service_reference,
      backup  => ".${standard::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if $standard::confdir {
    create_resources(standard::confdir,$standard::confdir)
  }
}
