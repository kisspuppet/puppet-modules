# Class: mcollective_server::params
#
# This class defines parameters used by all mcollective_server sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to mcollective_server for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main mcollective_server class
#
class mcollective_server::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['mcollective_server'],
  }

  $service_reference = $mcollective_server::audit_only ? {
    true    => undef,
    default => $mcollective_server::restart ? {
      false   => undef,
      default => Service['mcollective_server'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'mcollective',
    default       => '',
  }

  $package_ensure = $mcollective_server::absent ? {
    true    => 'absent',
    default => $mcollective_server::version ? {
      ''         => 'present',
      default    => $mcollective_server::version,
    }
  }

  ## Configuration file related parameters
  $config_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/etc/mcollective',
    default => '',
  }

  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/mcollective/server.cfg',
    default => '',
  }

  $config_file_ensure = $mcollective_server::absent ? {
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

  $config_file_content = $mcollective_server::template ? {
    ''        => undef,
    default   => template($mcollective_server::template),
  }

  $config_file_source = $mcollective_server::source ? {
    ''        => undef,
    default   => $mcollective_server::source,
  }

  $config_file_audit = $mcollective_server::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $mcollective_server::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'mcollective',
    default       => '',
  }

  $service_enable = $mcollective_server::disboot ? {
    true    => false,
    default => $mcollective_server::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $mcollective_server::disable ? {
    true    => 'stopped',
    default => $mcollective_server::absent ? {
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
