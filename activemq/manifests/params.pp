# Class: activemq::params
#
# This class defines parameters used by all activemq sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to activemq for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main activemq class
#
class activemq::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['activemq'],
  }

  $service_reference = $activemq::audit_only ? {
    true    => undef,
    default => $activemq::restart ? {
      false   => undef,
      default => Service['activemq'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'activemq',
    default       => '',
  }

  $package_ensure = $activemq::absent ? {
    true    => 'absent',
    default => $activemq::version ? {
      ''         => 'present',
      default    => $activemq::version,
    }
  }

  ## Configuration file related parameters
  $config_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/etc/activemq/',
    default => '',
  }

  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/activemq/activemq.xml',
    default => '',
  }

  $config_file_ensure = $activemq::absent ? {
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

  $config_file_content = $activemq::template ? {
    ''        => undef,
    default   => template($activemq::template),
  }

  $config_file_source = $activemq::source ? {
    ''        => undef,
    default   => $activemq::source,
  }

  $config_file_audit = $activemq::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $activemq::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'activemq',
    default       => '',
  }

  $service_enable = $activemq::disboot ? {
    true    => false,
    default => $activemq::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $activemq::disable ? {
    true    => 'stopped',
    default => $activemq::absent ? {
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
