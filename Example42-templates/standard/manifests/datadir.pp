define standard::datadir (
  $data_file  = $title,
  $template      = '',
  $source        = '',
  $ensure        = present,
  $owner         = $standard::data_file_owner,
  $group         = $standard::data_file_group,
  $mode          = $standard::data_file_mode,
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

  if $standard::data_dir {
    file { "standard_data_${data_file}":
      path    => "${standard::data_dir}/${data_file}",
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
