define simple::confdir (
  $config_file = $title,
  $template     = '',
  $source       = '',
  $ensure       = $simple::config_file_ensure,
  $owner        = $simple::config_file_owner,
  $group        = $simple::config_file_group,
  $mode         = $simple::config_file_mode,
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

  if $simple::config_dir {
    file { "simple_config_${config_file}":
      path    => "${simple::config_dir}/${config_file}",
      ensure  => $config_file_ensure,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $config_file_content,
      recurse => $config_file_recurse,
      replace => $simple::config_file_replace,
      audit   => $simple::config_file_audit,
      notify  => $simple::service_reference,
      backup  => ".${simple::system_date}.bak",
    }
  }
}

