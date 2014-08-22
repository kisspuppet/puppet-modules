# Class: users::params
#
# This class defines parameters used by all users sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to users for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main users class
#
class users::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $users::package ? {
    ''      => undef,
    default => Class['users::install'],
  }

  $service_reference = $users::audit_only ? {
    true    => undef,
    default => $users::restart ? {
      false   => undef,
      default => Class['users::service'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  {
      fail("${::operatingsystem} not supported. Review params.pp for extending support.")
    }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'users-server',
    default       => '',
  }

  $package_ensure = $users::absent ? {
    true    => 'absent',
    default => $users::version ? {
      ''         => 'present',
      default    => $users::version,
    }
  }

  ## Configuration file related parameters
  $config_dir  = $::osfamily ? {
    /(?i:redhat)/ => '/etc/ssh',
    default => '',
  }
  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/ssh/sshd_config',
    default => '',
  }

  $config_file_ensure = $users::absent ? {
    true    => undef,
    default => 'present',
  }

  $config_file_mode = $::osfamily ? {
    default       => '0600',
  }

  $config_file_owner = $::osfamily ? {
    default       => 'root',
  }

  $config_file_group = $::osfamily ? {
    default       => 'root',
  }

  $config_file_content = $users::template ? {
    ''        => undef,
    default   => template($users::template),
  }

  $config_file_source = $users::source ? {
    ''        => undef,
    default   => $users::source,
  }

  $config_file_init = $::osfamily ? {
    /(?i:redhat)/ => '/etc/sysconfig/sshd',
    default       => '',
  }

  $config_file_audit = $users::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $users::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'sshd',
    default       => '',
  }

  $service_enable = $users::disboot ? {
    true    => false,
    default => $users::disable ? {
      true  => false,
      default => $users::absent ? {
        true    => undef,
        default => true,
      },
    },
  }

  $service_ensure = $users::disable ? {
    true    => 'stopped',
    default => $users::absent ? {
      true    => undef,
      default => 'running',
    },
  }

  $service_status = $::osfamily ? {
    default => true,
  }

}
