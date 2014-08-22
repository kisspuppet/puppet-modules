# Class: normal::params
#
# This class defines parameters used by all normal sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to normal for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main normal class
#
class normal::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['normal'],
  }

  $service_reference = $normal::audit_only ? {
    true    => undef,
    default => $normal::restart ? {
      false   => undef,
      default => Service['normal'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'normal',
    default       => '',
  }

  $package_ensure = $normal::absent ? {
    true    => 'absent',
    default => $normal::version ? {
      ''         => 'present',
      default    => $normal::version,
    }
  }

  ## Configuration file related parameters
  $config_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/etc/normal/conf.d',
    default => '',
  }

  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/normal/normal.conf',
    default => '',
  }

  $config_file_init = $::osfamily ? {
    /(?i:redhat)/ => '/etc/sysconfig/normal',
    default       => '',
  }

  $config_file_init_source = $normal::confinit ? {
    ''      => undef,
    default => $normal::confinit
  }

  $config_file_ensure = $normal::absent ? {
    true    => undef,
    default => 'present',
  }

  $config_file_mode = $::osfamily ? {
    default       => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default       => 'root',
  }

  $config_file_group = $::osfamily ? {
    default       => 'root',
  }

  $config_file_content = $normal::template ? {
    ''        => undef,
    default   => template($normal::template),
  }

  $config_file_source = $normal::source ? {
    ''        => undef,
    default   => $normal::source,
  }

  $config_file_audit = $normal::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $normal::audit_only ? {
    true  => false,
    false => true,
  }

  ## Data file related parameters
  $data_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/var/normal',
    default => '',
  }

  $data_file_mode = $::osfamily ? {
    default       => '0644',
  }

  $data_file_owner = $::osfamily ? {
    default       => 'normal',
  }

  $data_file_group = $::osfamily ? {
    default       => 'normal',
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'normald',
    default       => '',
  }

  $service_enable = $normal::disboot ? {
    true    => false,
    default => $normal::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $normal::disable ? {
    true    => 'stopped',
    default => $normal::absent ? {
      true    => undef,
      default => 'running',
    },
  }

  $service_hasstatus = $::osfamily ? {
    default => true,
  }

  $service_hasrestart = $::osfamily ? {
    default => true,
  }

  $service_restart = $::osfamily ? {
    default => undef,
  }

  $service_start = $::osfamily ? {
    default => undef,
  }

  $service_stop = $::osfamily ? {
    default => undef,
  }

  $service_status = $::osfamily ? {
    default => undef,
  }
}
