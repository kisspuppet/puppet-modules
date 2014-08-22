# Class: puppet_server::params
#
# This class defines parameters used by all puppet_server sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to puppet_server for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main puppet_server class
#
class puppet_server::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['puppet_server'],
  }

  $service_reference = $puppet_server::audit_only ? {
    true    => undef,
    default => $puppet_server::restart ? {
      false   => undef,
      default => Service['puppet_server'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'puppet-server',
    default       => '',
  }

  $package_ensure = $puppet_server::absent ? {
    true    => 'absent',
    default => $puppet_server::version ? {
      ''         => 'present',
      default    => $puppet_server::version,
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

  $config_file_init = $::osfamily ? {
    /(?i:redhat)/ => '/etc/sysconfig/puppetmaster',
    default       => '',
  }

  $config_file_init_source = $puppet_server::confinit ? {
    ''      => undef,
    default => $puppet_server::confinit
  }

  $config_file_ensure = $puppet_server::absent ? {
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

  $config_file_content = $puppet_server::template ? {
    ''        => undef,
    default   => template($puppet_server::template),
  }

  $config_file_source = $puppet_server::source ? {
    ''        => undef,
    default   => $puppet_server::source,
  }

  $config_file_audit = $puppet_server::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $puppet_server::audit_only ? {
    true  => false,
    false => true,
  }

  ## Data file related parameters
  $data_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/var/lib/puppet',
    default => '',
  }

  $data_file_mode = $::osfamily ? {
    default       => '0644',
  }

  $data_file_owner = $::osfamily ? {
    default       => 'puppet',
  }

  $data_file_group = $::osfamily ? {
    default       => 'puppet',
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'puppetmaster',
    default       => '',
  }

  $service_enable = $puppet_server::disboot ? {
    true    => false,
    default => $puppet_server::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $puppet_server::disable ? {
    true    => 'stopped',
    default => $puppet_server::absent ? {
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
