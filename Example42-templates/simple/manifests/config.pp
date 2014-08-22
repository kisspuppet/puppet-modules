class simple::config{
  ## Managed main configuration file
  if $simple::config_file {
    file { 'simple.conf':
      path    => $simple::config_file,
      ensure  => $simple::config_file_ensure,
      mode    => $simple::config_file_mode,
      owner   => $simple::config_file_owner,
      group   => $simple::config_file_group,
      source  => $simple::config_file_source,
      content => $simple::config_file_content,
      replace => $simple::config_file_replace,
      audit   => $simple::config_file_audit,
      notify  => $simple::service_reference,
      backup  => ".${simple::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if $simple::confdir {
    create_resources(simple::confdir,$simple::confdir)
  }
}
