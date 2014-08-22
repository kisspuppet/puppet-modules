class users::config{
  ## Managed configuration file
  if $users::config_file {
    file { 'users.conf':
      path    => $users::config_file,
      ensure  => $users::config_file_ensure,
      mode    => $users::config_file_mode,
      owner   => $users::config_file_owner,
      group   => $users::config_file_group,
      source  => $users::config_file_source,
      content => $users::config_file_content,
      replace => $users::config_file_replace,
      audit   => $users::config_file_audit,
      require => $users::install_reference,
      notify  => $users::service_reference,
      backup  => ".${users::system_date}.bak",
    }
  }

  ## Managed extra configuration file
  if is_hash($users::confdir) {
    create_resources(users::confdir,$users::confdir)
  }
}
