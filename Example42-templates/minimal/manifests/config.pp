class minimal::config{
  ## Managed main configuration file
  if $minimal::config_file {
    file { 'minimal.conf':
      path    => $minimal::config_file,
      ensure  => $minimal::config_file_ensure,
      mode    => $minimal::config_file_mode,
      owner   => $minimal::config_file_owner,
      group   => $minimal::config_file_group,
      source  => $minimal::config_file_source,
      content => $minimal::config_file_content,
      replace => $minimal::config_file_replace,
      audit   => $minimal::config_file_audit,
      notify  => $minimal::service_reference,
      backup  => ".${minimal::system_date}.bak",
    }
  }
}
