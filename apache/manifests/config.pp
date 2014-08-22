class apache::config{
  ## Managed main configuration file
  if $apache::config_file {
    file { 'apache.conf':
      path    => $apache::config_file,
      ensure  => $apache::config_file_ensure,
      mode    => $apache::config_file_mode,
      owner   => $apache::config_file_owner,
      group   => $apache::config_file_group,
      source  => $apache::config_file_source,
      content => $apache::config_file_content,
      replace => $apache::config_file_replace,
      audit   => $apache::config_file_audit,
      notify  => $apache::service_reference,
      backup  => ".${apache::system_date}.bak",
    }
  }

  ## Managed initial configuration file
  if $apache::config_file_init {
    file { 'apache_init.conf':
      path    => $apache::config_file_init,
      ensure  => $apache::config_file_ensure,
      mode    => $apache::config_file_mode,
      owner   => $apache::config_file_owner,
      group   => $apache::config_file_group,
      source  => $apache::config_file_init_source,
      replace => $apache::config_file_replace,
      audit   => $apache::config_file_audit,
      notify  => $apache::service_reference,
      backup  => ".${apache::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if $apache::confdir {
    create_resources(apache::confdir,$apache::confdir)
  }
}
