# Class: standard::params
#
# This class defines parameters used by all standard sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to standard for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main standard class
#
class standard::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['standard'],
  }

  $service_reference = $standard::audit_only ? {
    true    => undef,
    default => $standard::restart ? {
      false   => undef,
      default => Service['standard'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'standard',
    default       => '',
  }

  $package_ensure = $standard::absent ? {
    true    => 'absent',
    default => $standard::version ? {
      ''         => 'present',
      default    => $standard::version,
    }
  }

  ## Configuration file related parameters
  $config_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/etc/standard/conf.d',
    default => '',
  }

  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/standard/standard.conf',
    default => '',
  }

  $config_file_ensure = $standard::absent ? {
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

  $config_file_content = $standard::template ? {
    ''        => undef,
    default   => template($standard::template),
  }

  $config_file_source = $standard::source ? {
    ''        => undef,
    default   => $standard::source,
  }

  $config_file_audit = $standard::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $standard::audit_only ? {
    true  => false,
    false => true,
  }

  ## Data file related parameters
  $data_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/var/standard',
    default => '',
  }

  $data_file_mode = $::osfamily ? {
    default       => '0644',
  }

  $data_file_owner = $::osfamily ? {
    default       => 'standard',
  }

  $data_file_group = $::osfamily ? {
    default       => 'standard',
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'standardd',
    default       => '',
  }

  $service_enable = $standard::disboot ? {
    true    => false,
    default => $standard::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $standard::disable ? {
    true    => 'stopped',
    default => $standard::absent ? {
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
