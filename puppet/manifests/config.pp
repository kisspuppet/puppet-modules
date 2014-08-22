class puppet::config{
  ## Managed main configuration file
  if $puppet::config_file {
    file { 'puppet.conf':
      path    => $puppet::config_file,
      ensure  => $puppet::config_file_ensure,
      mode    => $puppet::config_file_mode,
      owner   => $puppet::config_file_owner,
      group   => $puppet::config_file_group,
      source  => $puppet::config_file_source,
      content => $puppet::config_file_content,
      replace => $puppet::config_file_replace,
      audit   => $puppet::config_file_audit,
      notify  => $puppet::service_reference,
      backup  => ".${puppet::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if $puppet::confdir {
    create_resources(puppet::confdir,$puppet::confdir)
  }
}
