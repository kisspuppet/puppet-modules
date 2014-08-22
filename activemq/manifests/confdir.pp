define activemq::confdir (
  $config_file = $title,
  $template     = '',
  $source       = '',
  $ensure       = $activemq::config_file_ensure,
  $owner        = $activemq::config_file_owner,
  $group        = $activemq::config_file_group,
  $mode         = $activemq::config_file_mode,
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

  if $activemq::config_dir {
    file { "activemq_config_${config_file}":
      path    => "${activemq::config_dir}/${config_file}",
      ensure  => $config_file_ensure,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $config_file_content,
      recurse => $config_file_recurse,
      replace => $activemq::config_file_replace,
      audit   => $activemq::config_file_audit,
      notify  => $activemq::service_reference,
      backup  => ".${activemq::system_date}.bak",
    }
  }
}

