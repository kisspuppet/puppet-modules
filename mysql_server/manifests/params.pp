# Class: mysql_server::params
#
# This class defines parameters used by all mysql_server sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to mysql_server for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main mysql_server class
#
class mysql_server::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['mysql_server'],
  }

  $service_reference = $mysql_server::audit_only ? {
    true    => undef,
    default => $mysql_server::restart ? {
      false   => undef,
      default => Service['mysql_server'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'mysql-server',
    default       => '',
  }

  $package_ensure = $mysql_server::absent ? {
    true    => 'absent',
    default => $mysql_server::version ? {
      ''         => 'present',
      default    => $mysql_server::version,
    }
  }

  ## Configuration file related parameters
  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/my.cnf',
    default => '',
  }

  $config_file_ensure = $mysql_server::absent ? {
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

  $config_file_content = $mysql_server::template ? {
    ''        => undef,
    default   => template($mysql_server::template),
  }

  $config_file_source = $mysql_server::source ? {
    ''        => undef,
    default   => $mysql_server::source,
  }

  $config_file_audit = $mysql_server::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $mysql_server::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'mysqld',
    default       => '',
  }

  $service_enable = $mysql_server::disboot ? {
    true    => false,
    default => $mysql_server::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $mysql_server::disable ? {
    true    => 'stopped',
    default => $mysql_server::absent ? {
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
