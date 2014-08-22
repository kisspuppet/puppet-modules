# Class: mcollective_client::params
#
# This class defines parameters used by all mcollective_client sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to mcollective_client for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main mcollective_client class
#
class mcollective_client::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['mcollective_client'],
  }

  $service_reference = $mcollective_client::audit_only ? {
    true    => undef,
    default => $mcollective_client::restart ? {
      false   => undef,
      default => Service['mcollective_client'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'mcollective-client',
    default       => '',
  }

  $package_ensure = $mcollective_client::absent ? {
    true    => 'absent',
    default => $mcollective_client::version ? {
      ''         => 'present',
      default    => $mcollective_client::version,
    }
  }

  ## Configuration file related parameters
  $config_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/etc/mcollective',
    default => '',
  }

  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/mcollective/client.cfg',
    default => '',
  }

  $config_file_ensure = $mcollective_client::absent ? {
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

  $config_file_content = $mcollective_client::template ? {
    ''        => undef,
    default   => template($mcollective_client::template),
  }

  $config_file_source = $mcollective_client::source ? {
    ''        => undef,
    default   => $mcollective_client::source,
  }

  $config_file_audit = $mcollective_client::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $mcollective_client::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    default       => '',
  }

  $service_enable = $mcollective_client::disboot ? {
    true    => false,
    default => $mcollective_client::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $mcollective_client::disable ? {
    true    => 'stopped',
    default => $mcollective_client::absent ? {
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
