define ntp::confdir (
  $config_file = $title,
  $template     = '',
  $source       = '',
  $ensure       = $ntp::config_file_ensure,
  $owner        = $ntp::config_file_owner,
  $group        = $ntp::config_file_group,
  $mode         = $ntp::config_file_mode,
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

  if $ntp::config_dir {
    file { "ntp_config_${config_file}":
      path    => "${ntp::config_dir}/${config_file}",
      ensure  => $config_file_ensure,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $config_file_content,
      recurse => $config_file_recurse,
      replace => $ntp::config_file_replace,
      audit   => $ntp::config_file_audit,
      notify  => $ntp::service_reference,
      backup  => ".${ntp::system_date}.bak",
    }
  }
}

