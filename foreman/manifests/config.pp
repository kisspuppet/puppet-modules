class foreman::config{
  ## Managed main configuration file
  if $foreman::config_file {
    file { 'foreman.conf':
      path    => $foreman::config_file,
      ensure  => $foreman::config_file_ensure,
      mode    => $foreman::config_file_mode,
      owner   => $foreman::config_file_owner,
      group   => $foreman::config_file_group,
      source  => $foreman::config_file_source,
      content => $foreman::config_file_content,
      replace => $foreman::config_file_replace,
      audit   => $foreman::config_file_audit,
      notify  => $foreman::service_reference,
      backup  => ".${foreman::system_date}.bak",
    }
  }
}
