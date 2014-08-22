define rabbitmq::confdir (
  $config_file = $title,
  $template     = '',
  $source       = '',
  $ensure       = $rabbitmq::config_file_ensure,
  $owner        = $rabbitmq::config_file_owner,
  $group        = $rabbitmq::config_file_group,
  $mode         = $rabbitmq::config_file_mode,
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

  if $rabbitmq::config_dir {
    file { "rabbitmq_config_${config_file}":
      path    => "${rabbitmq::config_dir}/${config_file}",
      ensure  => $config_file_ensure,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $config_file_content,
      recurse => $config_file_recurse,
      replace => $rabbitmq::config_file_replace,
      audit   => $rabbitmq::config_file_audit,
      notify  => $rabbitmq::service_reference,
      backup  => ".${rabbitmq::system_date}.bak",
    }
  }
}

