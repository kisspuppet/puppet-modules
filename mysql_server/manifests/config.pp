class mysql_server::config{
  ## Managed main configuration file
  if $mysql_server::config_file {
    file { 'mysql_server.conf':
      path    => $mysql_server::config_file,
      ensure  => $mysql_server::config_file_ensure,
      mode    => $mysql_server::config_file_mode,
      owner   => $mysql_server::config_file_owner,
      group   => $mysql_server::config_file_group,
      source  => $mysql_server::config_file_source,
      content => $mysql_server::config_file_content,
      replace => $mysql_server::config_file_replace,
      audit   => $mysql_server::config_file_audit,
      notify  => $mysql_server::service_reference,
      backup  => ".${mysql_server::system_date}.bak",
    }
  }
}
