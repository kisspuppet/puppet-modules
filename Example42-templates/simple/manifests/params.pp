# Class: simple::params
#
# This class defines parameters used by all simple sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to simple for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main simple class
#
class simple::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['simple'],
  }

  $service_reference = $simple::audit_only ? {
    true    => undef,
    default => $simple::restart ? {
      false   => undef,
      default => Service['simple'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'simple',
    default       => '',
  }

  $package_ensure = $simple::absent ? {
    true    => 'absent',
    default => $simple::version ? {
      ''         => 'present',
      default    => $simple::version,
    }
  }

  ## Configuration file related parameters
  $config_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/etc/simple/conf.d',
    default => '',
  }

  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/simple/simple.conf',
    default => '',
  }

  $config_file_ensure = $simple::absent ? {
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

  $config_file_content = $simple::template ? {
    ''        => undef,
    default   => template($simple::template),
  }

  $config_file_source = $simple::source ? {
    ''        => undef,
    default   => $simple::source,
  }

  $config_file_audit = $simple::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $simple::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'simpled',
    default       => '',
  }

  $service_enable = $simple::disboot ? {
    true    => false,
    default => $simple::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $simple::disable ? {
    true    => 'stopped',
    default => $simple::absent ? {
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
