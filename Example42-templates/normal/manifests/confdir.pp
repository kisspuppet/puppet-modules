define normal::confdir (
  $config_file = $title,
  $template     = '',
  $source       = '',
  $ensure       = $normal::config_file_ensure,
  $owner        = $normal::config_file_owner,
  $group        = $normal::config_file_group,
  $mode         = $normal::config_file_mode,
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

  if $normal::config_dir {
    file { "normal_config_${config_file}":
      path    => "${normal::config_dir}/${config_file}",
      ensure  => $config_file_ensure,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $config_file_content,
      recurse => $config_file_recurse,
      replace => $normal::config_file_replace,
      audit   => $normal::config_file_audit,
      notify  => $normal::service_reference,
      backup  => ".${normal::system_date}.bak",
    }
  }
}

