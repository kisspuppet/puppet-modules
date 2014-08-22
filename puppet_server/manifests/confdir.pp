define puppet_server::confdir (
  $config_file = $title,
  $template     = '',
  $source       = '',
  $ensure       = $puppet_server::config_file_ensure,
  $owner        = $puppet_server::config_file_owner,
  $group        = $puppet_server::config_file_group,
  $mode         = $puppet_server::config_file_mode,
  ) {

  $config_file_content = $template ? {
    ''        => undef,
    default   => template($template),
  }

  $config_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $config_file_recurse = $ensure ? {
      directory => true,
      default => undef,
  }

  $config_file_ensure = $ensure
  $config_file_owner  = $owner
  $config_file_group  = $group
  $config_file_mode   = $mode

  if $puppet_server::config_dir {
    file { "puppet_server_config_${config_file}":
      path    => "${puppet_server::config_dir}/${config_file}",
      ensure  => $config_file_ensure,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $config_file_content,
      recurse => $config_file_recurse,
      replace => $puppet_server::config_file_replace,
      audit   => $puppet_server::config_file_audit,
      notify  => $puppet_server::service_reference,
      backup  => ".${puppet_server::system_date}.bak",
    }
  }
}

