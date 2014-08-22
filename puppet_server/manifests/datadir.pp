define puppet_server::datadir (
  $data_file  = $title,
  $template      = '',
  $source        = '',
  $ensure        = present,
  $owner         = $puppet_server::data_file_owner,
  $group         = $puppet_server::data_file_group,
  $mode          = $puppet_server::data_file_mode,
  ) {

  $data_file_content = $template ? {
    ''        => undef,
    default   => template($template),
  }

  $data_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $data_file_recurse = $ensure ? {
      directory => true,
      default => undef,
  }

  $data_file_ensure = $ensure
  $data_file_owner  = $owner
  $data_file_group  = $group
  $data_file_mode   = $mode

  if $puppet_server::data_dir {
    file { "puppet_server_data_${data_file}":
      path    => "${puppet_server::data_dir}/${data_file}",
      ensure  => $data_file_ensure,
      mode    => $data_file_mode,
      owner   => $data_file_owner,
      group   => $data_file_group,
      source  => $data_file_source,
      content => $data_file_content,
      recurse => $data_file_recurse,
      replace => false,
    }
  }
}
