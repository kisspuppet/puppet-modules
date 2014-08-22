define mcollective_client::confdir (
  $config_file = $title,
  $template     = '',
  $source       = '',
  $ensure       = $mcollective_client::config_file_ensure,
  $owner        = $mcollective_client::config_file_owner,
  $group        = $mcollective_client::config_file_group,
  $mode         = $mcollective_client::config_file_mode,
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

  if $mcollective_client::config_dir {
    file { "mcollective_client_config_${config_file}":
      path    => "${mcollective_client::config_dir}/${config_file}",
      ensure  => $config_file_ensure,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $config_file_content,
      recurse => $config_file_recurse,
      replace => $mcollective_client::config_file_replace,
      audit   => $mcollective_client::config_file_audit,
      notify  => $mcollective_client::service_reference,
      backup  => ".${mcollective_client::system_date}.bak",
    }
  }
}

