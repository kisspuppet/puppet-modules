class foreman_proxy::config{
  ## Managed main configuration file
  if $foreman_proxy::config_file {
    file { 'foreman_proxy.conf':
      path    => $foreman_proxy::config_file,
      ensure  => $foreman_proxy::config_file_ensure,
      mode    => $foreman_proxy::config_file_mode,
      owner   => $foreman_proxy::config_file_owner,
      group   => $foreman_proxy::config_file_group,
      source  => $foreman_proxy::config_file_source,
      content => $foreman_proxy::config_file_content,
      replace => $foreman_proxy::config_file_replace,
      audit   => $foreman_proxy::config_file_audit,
      notify  => $foreman_proxy::service_reference,
      backup  => ".${foreman_proxy::system_date}.bak",
    }
  }
}
