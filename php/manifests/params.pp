# Class: php::params
#
# This class defines parameters used by all php sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to php for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main php class
#
class php::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['php'],
  }

  $service_reference = $php::audit_only ? {
    true    => undef,
    default => $php::restart ? {
      false   => undef,
      default => Service['php'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'php',
    default       => '',
  }

  $package_ensure = $php::absent ? {
    true    => 'absent',
    default => $php::version ? {
      ''         => 'present',
      default    => $php::version,
    }
  }

  ## Configuration file related parameters
  $config_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/etc/php.d',
    default => '',
  }

  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/php.ini',
    default => '',
  }

  $config_file_ensure = $php::absent ? {
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

  $config_file_content = $php::template ? {
    ''        => undef,
    default   => template($php::template),
  }

  $config_file_source = $php::source ? {
    ''        => undef,
    default   => $php::source,
  }

  $config_file_audit = $php::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $php::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    default       => '',
  }

  $service_enable = $php::disboot ? {
    true    => false,
    default => $php::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $php::disable ? {
    true    => 'stopped',
    default => $php::absent ? {
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
