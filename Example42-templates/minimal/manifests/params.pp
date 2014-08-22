# Class: minimal::params
#
# This class defines parameters used by all minimal sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to minimal for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main minimal class
#
class minimal::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['minimal'],
  }

  $service_reference = $minimal::audit_only ? {
    true    => undef,
    default => $minimal::restart ? {
      false   => undef,
      default => Service['minimal'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'minimal',
    default       => '',
  }

  $package_ensure = $minimal::absent ? {
    true    => 'absent',
    default => $minimal::version ? {
      ''         => 'present',
      default    => $minimal::version,
    }
  }

  ## Configuration file related parameters
  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/minimal/minimal.conf',
    default => '',
  }

  $config_file_ensure = $minimal::absent ? {
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

  $config_file_content = $minimal::template ? {
    ''        => undef,
    default   => template($minimal::template),
  }

  $config_file_source = $minimal::source ? {
    ''        => undef,
    default   => $minimal::source,
  }

  $config_file_audit = $minimal::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $minimal::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'minimald',
    default       => '',
  }

  $service_enable = $minimal::disboot ? {
    true    => false,
    default => $minimal::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $minimal::disable ? {
    true    => 'stopped',
    default => $minimal::absent ? {
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
