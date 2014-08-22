class ntp::config{
  ## Managed main configuration file
  if $ntp::config_file {
    file { 'ntp.conf':
      path    => $ntp::config_file,
      ensure  => $ntp::config_file_ensure,
      mode    => $ntp::config_file_mode,
      owner   => $ntp::config_file_owner,
      group   => $ntp::config_file_group,
      source  => $ntp::config_file_source,
      content => $ntp::config_file_content,
      replace => $ntp::config_file_replace,
      audit   => $ntp::config_file_audit,
      notify  => $ntp::service_reference,
      backup  => ".${ntp::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if $ntp::confdir {
    create_resources(ntp::confdir,$ntp::confdir)
  }
}
