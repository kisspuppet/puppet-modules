# Class: puppet::params
#
# This class defines parameters used by all puppet sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to puppet for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main puppet class
#
class puppet::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['puppet'],
  }

  $service_reference = $puppet::audit_only ? {
    true    => undef,
    default => $puppet::restart ? {
      false   => undef,
      default => Service['puppet'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'puppet',
    default       => '',
  }

  $package_ensure = $puppet::absent ? {
    true    => 'absent',
    default => $puppet::version ? {
      ''         => 'present',
      default    => $puppet::version,
    }
  }

  ## Configuration file related parameters
  $config_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/etc/puppet',
    default => '',
  }

  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/puppet/puppet.conf',
    default => '',
  }

  $config_file_ensure = $puppet::absent ? {
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

  $config_file_content = $puppet::template ? {
    ''        => undef,
    default   => template($puppet::template),
  }

  $config_file_source = $puppet::source ? {
    ''        => undef,
    default   => $puppet::source,
  }

  $config_file_audit = $puppet::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $puppet::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'puppet',
    default       => '',
  }

  $service_enable = $puppet::disboot ? {
    true    => false,
    default => $puppet::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $puppet::disable ? {
    true    => 'stopped',
    default => $puppet::absent ? {
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
