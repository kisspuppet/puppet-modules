define users::confdir (
  $config_file  = $title,
  $template     = '',
  $source       = '',
  $ensure       = $users::config_file_ensure,
  $owner        = $users::config_file_owner,
  $group        = $users::config_file_group,
  $mode         = $users::config_file_mode,
) {
  include users
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

  if $users::config_dir {
    file { "users::confdir::$config_file":
      path    => "${users::config_dir}/$config_file",
      ensure  => $config_file_ensure,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $config_file_content,
      replace => $users::config_file_replace,
      audit   => $users::config_file_audit,
      require => $users::install_reference,
      notify  => $users::service_reference,
      recurse => $config_file_recurse,
      backup  => ".${users::system_date}.bak",
    }
  }
}

