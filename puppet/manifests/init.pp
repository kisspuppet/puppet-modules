# == Class: puppet
#
# This is the main puppet class
#
# === Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#
# [*disboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#
# [*restart*]
#   Automatically restarts the puppet service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, puppet main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, puppet main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#
# [*version*]
#   Specify the package's version, allowed value: latest, 2.10.3-1.el6, 3.4.2-1.el5
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#
# [*confdir*]
#   Manage config file which locate in  config directory.
#   Available options:
#     * ensure
#     * source
#     * template
#     * owner
#     * group
#     * mode
#
# [*my_class*]
#   Automatically include a custom class with extra resources related to puppet.
#   Note: Use a subclass name different than puppet to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include puppet"
# - Set Class defaults and "include puppet"
# - Call puppet as a parametrized class
#
# ==== USAGE - Basic management
#
# Install puppet with default settings
#
#        class { "puppet": }
#
# Install puppet with specify version
#
#        class { "puppet":
#          version => '1.4.3-1.el6',
#        }
# Disable puppet service.
#
#        class { "puppet":
#          disable => true,
#        }
#
# Disable puppet service at boot time, but don't stop if is running.
#
#        class { "puppet":
#          disboot => true,
#        }
#
# Remove puppet package
#
#        class { "puppet":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "puppet":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "puppet":
#          source => "puppet:///modules/puppet/puppet.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "puppet":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "puppet/puppet.conf.erb",
#        }
#
# Use custom template for config dir file
#
#        class { "puppet":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/puppet/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "puppet/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# Add extra resources to modules
#
#        class hack_puppet {
#          # extra resources here
#        }
#        class { "puppet":
#          my_class => "hack_puppet",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class puppet (
  $absent              = $puppet::defaults::absent,
  $disable             = $puppet::defaults::disable,
  $disboot             = $puppet::defaults::disboot,
  $audit_only          = $puppet::defaults::audit_only,
  $restart             = $puppet::defaults::restart,
  $version             = $puppet::defaults::version,
  $template            = $puppet::defaults::template,
  $source              = $puppet::defaults::source,
  $options             = $puppet::defaults::options,
  $confdir             = $puppet::defaults::confdir,
  $my_class            = $puppet::defaults::my_class,
  ) inherits puppet::defaults {
  contain 'puppet::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }
  if $confdir { validate_hash($confdir) }

  ## General parameters
  $system_date         = $puppet::params::system_date
  $install_reference   = $puppet::params::install_reference
  $service_reference   = $puppet::params::service_reference

  ## Package ralated parameters
  $package             = $puppet::params::package
  $package_ensure      = $puppet::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir          = $puppet::params::config_dir
  $config_file         = $puppet::params::config_file
  $config_file_ensure  = $puppet::params::config_file_ensure
  $config_file_mode    = $puppet::params::config_file_mode
  $config_file_owner   = $puppet::params::config_file_owner
  $config_file_group   = $puppet::params::config_file_group
  $config_file_content = $puppet::params::config_file_content
  $config_file_source  = $puppet::params::config_file_source
  $config_file_audit   = $puppet::params::config_file_audit
  $config_file_replace = $puppet::params::config_file_replace

  ## Service ralated parameters
  $service             = $puppet::params::service
  $service_enable      = $puppet::params::service_enable
  $service_ensure      = $puppet::params::service_ensure
  $service_hasstatus   = $puppet::params::service_hasstatus
  $service_hasrestart  = $puppet::params::service_hasrestart
  $service_restart     = $puppet::params::service_restart
  $service_start       = $puppet::params::service_start
  $service_stop        = $puppet::params::service_stop
  $service_status      = $puppet::params::service_status

  ## Essential classes
  contain 'puppet::install'
  contain 'puppet::config'
  contain 'puppet::service'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['puppet::install'] -> Class['puppet::config'] -> Class['puppet::service']
}
