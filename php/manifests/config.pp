class php::config{
  ## Managed main configuration file
  if $php::config_file {
    file { 'php.conf':
      path    => $php::config_file,
      ensure  => $php::config_file_ensure,
      mode    => $php::config_file_mode,
      owner   => $php::config_file_owner,
      group   => $php::config_file_group,
      source  => $php::config_file_source,
      content => $php::config_file_content,
      replace => $php::config_file_replace,
      audit   => $php::config_file_audit,
      notify  => $php::service_reference,
      backup  => ".${php::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if $php::confdir {
    create_resources(php::confdir,$php::confdir)
  }
}
