# Class: apache::params
#
# This class defines parameters used by all apache sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to apache for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main apache class
#
class apache::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['apache'],
  }

  $service_reference = $apache::audit_only ? {
    true    => undef,
    default => $apache::restart ? {
      false   => undef,
      default => Service['apache'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'httpd',
    default       => '',
  }

  $package_ensure = $apache::absent ? {
    true    => 'absent',
    default => $apache::version ? {
      ''         => 'present',
      default    => $apache::version,
    }
  }

  ## Configuration file related parameters
  $config_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/etc/httpd/conf.d',
    default => '',
  }

  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/httpd/conf/httpd.conf',
    default => '',
  }

  $config_file_init = $::osfamily ? {
    /(?i:redhat)/ => '/etc/sysconfig/httpd',
    default       => '',
  }

  $config_file_init_source = $apache::confinit ? {
    ''      => undef,
    default => $apache::confinit
  }

  $config_file_ensure = $apache::absent ? {
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

  $config_file_content = $apache::template ? {
    ''        => undef,
    default   => template($apache::template),
  }

  $config_file_source = $apache::source ? {
    ''        => undef,
    default   => $apache::source,
  }

  $config_file_audit = $apache::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $apache::audit_only ? {
    true  => false,
    false => true,
  }

  ## Data file related parameters
  $data_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/var/www',
    default => '',
  }

  $data_file_mode = $::osfamily ? {
    default       => '0644',
  }

  $data_file_owner = $::osfamily ? {
    default       => 'apache',
  }

  $data_file_group = $::osfamily ? {
    default       => 'apache',
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'httpd',
    default       => '',
  }

  $service_enable = $apache::disboot ? {
    true    => false,
    default => $apache::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $apache::disable ? {
    true    => 'stopped',
    default => $apache::absent ? {
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
