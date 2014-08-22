class normal::config{
  ## Managed main configuration file
  if $normal::config_file {
    file { 'normal.conf':
      path    => $normal::config_file,
      ensure  => $normal::config_file_ensure,
      mode    => $normal::config_file_mode,
      owner   => $normal::config_file_owner,
      group   => $normal::config_file_group,
      source  => $normal::config_file_source,
      content => $normal::config_file_content,
      replace => $normal::config_file_replace,
      audit   => $normal::config_file_audit,
      notify  => $normal::service_reference,
      backup  => ".${normal::system_date}.bak",
    }
  }

  ## Managed initial configuration file
  if $normal::config_file_init {
    file { 'normal_init.conf':
      path    => $normal::config_file_init,
      ensure  => $normal::config_file_ensure,
      mode    => $normal::config_file_mode,
      owner   => $normal::config_file_owner,
      group   => $normal::config_file_group,
      source  => $normal::config_file_init_source,
      replace => $normal::config_file_replace,
      audit   => $normal::config_file_audit,
      notify  => $normal::service_reference,
      backup  => ".${normal::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if $normal::confdir {
    create_resources(normal::confdir,$normal::confdir)
  }
}
