define php::confdir (
  $config_file = $title,
  $template     = '',
  $source       = '',
  $ensure       = $php::config_file_ensure,
  $owner        = $php::config_file_owner,
  $group        = $php::config_file_group,
  $mode         = $php::config_file_mode,
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

  if $php::config_dir {
    file { "php_config_${config_file}":
      path    => "${php::config_dir}/${config_file}",
      ensure  => $config_file_ensure,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $config_file_content,
      recurse => $config_file_recurse,
      replace => $php::config_file_replace,
      audit   => $php::config_file_audit,
      notify  => $php::service_reference,
      backup  => ".${php::system_date}.bak",
    }
  }
}

