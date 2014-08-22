# Class: rabbitmq::params
#
# This class defines parameters used by all rabbitmq sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to rabbitmq for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main rabbitmq class
#
class rabbitmq::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['rabbitmq'],
  }

  $service_reference = $rabbitmq::audit_only ? {
    true    => undef,
    default => $rabbitmq::restart ? {
      false   => undef,
      default => Service['rabbitmq'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'rabbitmq-server',
    default       => '',
  }

  $package_ensure = $rabbitmq::absent ? {
    true    => 'absent',
    default => $rabbitmq::version ? {
      ''         => 'present',
      default    => $rabbitmq::version,
    }
  }

  ## Configuration file related parameters
  $config_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/etc/rabbitmq',
    default => '',
  }

  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/rabbitmq/rabbitmq.config',
    default => '',
  }

  $config_file_ensure = $rabbitmq::absent ? {
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

  $config_file_content = $rabbitmq::template ? {
    ''        => undef,
    default   => template($rabbitmq::template),
  }

  $config_file_source = $rabbitmq::source ? {
    ''        => undef,
    default   => $rabbitmq::source,
  }

  $config_file_audit = $rabbitmq::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $rabbitmq::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'rabbitmq-server',
    default       => '',
  }

  $service_enable = $rabbitmq::disboot ? {
    true    => false,
    default => $rabbitmq::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $rabbitmq::disable ? {
    true    => 'stopped',
    default => $rabbitmq::absent ? {
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
