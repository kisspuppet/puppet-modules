define apache::confdir (
  $config_file = $title,
  $template     = '',
  $source       = '',
  $ensure       = $apache::config_file_ensure,
  $owner        = $apache::config_file_owner,
  $group        = $apache::config_file_group,
  $mode         = $apache::config_file_mode,
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

  if $apache::config_dir {
    file { "apache_config_${config_file}":
      path    => "${apache::config_dir}/${config_file}",
      ensure  => $config_file_ensure,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $config_file_content,
      recurse => $config_file_recurse,
      replace => $apache::config_file_replace,
      audit   => $apache::config_file_audit,
      notify  => $apache::service_reference,
      backup  => ".${apache::system_date}.bak",
    }
  }
}

