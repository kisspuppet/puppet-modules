define standard::confdir (
  $config_file = $title,
  $template     = '',
  $source       = '',
  $ensure       = $standard::config_file_ensure,
  $owner        = $standard::config_file_owner,
  $group        = $standard::config_file_group,
  $mode         = $standard::config_file_mode,
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

  if $standard::config_dir {
    file { "standard_config_${config_file}":
      path    => "${standard::config_dir}/${config_file}",
      ensure  => $config_file_ensure,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $config_file_content,
      recurse => $config_file_recurse,
      replace => $standard::config_file_replace,
      audit   => $standard::config_file_audit,
      notify  => $standard::service_reference,
      backup  => ".${standard::system_date}.bak",
    }
  }
}

