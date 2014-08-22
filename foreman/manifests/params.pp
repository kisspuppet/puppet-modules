# Class: foreman::params
#
# This class defines parameters used by all foreman sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to foreman for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main foreman class
#
class foreman::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['foreman'],
  }

  $service_reference = $foreman::audit_only ? {
    true    => undef,
    default => $foreman::restart ? {
      false   => undef,
      default => Service['foreman'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'foreman-installer',
    default       => '',
  }

  $package_ensure = $foreman::absent ? {
    true    => 'absent',
    default => $foreman::version ? {
      ''         => 'present',
      default    => $foreman::version,
    }
  }

  ## Configuration file related parameters
  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/foreman/settings.yaml',
    default => '',
  }

  $config_file_ensure = $foreman::absent ? {
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
    default       => 'foreman',
  }

  $config_file_content = $foreman::template ? {
    ''        => undef,
    default   => template($foreman::template),
  }

  $config_file_source = $foreman::source ? {
    ''        => undef,
    default   => $foreman::source,
  }

  $config_file_audit = $foreman::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $foreman::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'foreman',
    default       => '',
  }

  $service_enable = $foreman::disboot ? {
    true    => false,
    default => $foreman::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $foreman::disable ? {
    true    => 'stopped',
    default => $foreman::absent ? {
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
