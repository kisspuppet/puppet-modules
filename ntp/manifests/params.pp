# Class: ntp::params
#
# This class defines parameters used by all ntp sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to ntp for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main ntp class
#
class ntp::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['ntp'],
  }

  $service_reference = $ntp::audit_only ? {
    true    => undef,
    default => $ntp::restart ? {
      false   => undef,
      default => Service['ntp'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'ntp',
    default       => '',
  }

  $package_ensure = $ntp::absent ? {
    true    => 'absent',
    default => $ntp::version ? {
      ''         => 'present',
      default    => $ntp::version,
    }
  }

  ## Configuration file related parameters
  $config_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/etc/ntp',
    default => '',
  }

  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/ntp.conf',
    default => '',
  }

  $config_file_ensure = $ntp::absent ? {
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

  $config_file_content = $ntp::template ? {
    ''        => undef,
    default   => template($ntp::template),
  }

  $config_file_source = $ntp::source ? {
    ''        => undef,
    default   => $ntp::source,
  }

  $config_file_audit = $ntp::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $ntp::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'ntpd',
    default       => '',
  }

  $service_enable = $ntp::disboot ? {
    true    => false,
    default => $ntp::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $ntp::disable ? {
    true    => 'stopped',
    default => $ntp::absent ? {
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
