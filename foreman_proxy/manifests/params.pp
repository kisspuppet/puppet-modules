# Class: foreman_proxy::params
#
# This class defines parameters used by all foreman_proxy sub class,
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to foreman_proxy for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It should be include by main foreman_proxy class
#
class foreman_proxy::params {

  ## General parameters
  $system_date = strftime("%Y%m%d%H%M")

  $install_reference = $package ? {
    ''      => undef,
    default => Package['foreman_proxy'],
  }

  $service_reference = $foreman_proxy::audit_only ? {
    true    => undef,
    default => $foreman_proxy::restart ? {
      false   => undef,
      default => Service['foreman_proxy'],
    },
  }

  case $::osfamily {
    'RedHat': { }
    default:  { fail("${::operatingsystem} not supported. Review params.pp for extending support.") }
  }

  ## Package related parameters
  $package = $::osfamily ? {
    /(?i:redhat)/ => 'foreman-installer',
    default       => '',
  }

  $package_ensure = $foreman_proxy::absent ? {
    true    => 'absent',
    default => $foreman_proxy::version ? {
      ''         => 'present',
      default    => $foreman_proxy::version,
    }
  }

  ## Configuration file related parameters
  $config_file = $::osfamily ? {
    /(?i:redhat)/ => '/etc/foreman-proxy/settings.yml',
    default => '',
  }

  $config_file_ensure = $foreman_proxy::absent ? {
    true    => undef,
    default => 'present',
  }

  $config_file_mode = $::osfamily ? {
    default       => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default       => 'foreman-proxy',
  }

  $config_file_group = $::osfamily ? {
    default       => 'foreman-proxy',
  }

  $config_file_content = $foreman_proxy::template ? {
    ''        => undef,
    default   => template($foreman_proxy::template),
  }

  $config_file_source = $foreman_proxy::source ? {
    ''        => undef,
    default   => $foreman_proxy::source,
  }

  $config_file_audit = $foreman_proxy::audit_only ? {
    true  => 'all',
    false => undef,
  }

  $config_file_replace = $foreman_proxy::audit_only ? {
    true  => false,
    false => true,
  }

  ## Service related parameters
  $service = $::osfamily ? {
    /(?i:redhat)/ => 'foreman-proxy',
    default       => '',
  }

  $service_enable = $foreman_proxy::disboot ? {
    true    => false,
    default => $foreman_proxy::absent ? {
      true    => undef,
      default => true,
    },
  }

  $service_ensure = $foreman_proxy::disable ? {
    true    => 'stopped',
    default => $foreman_proxy::absent ? {
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
