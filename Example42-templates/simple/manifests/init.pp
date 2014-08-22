# == Class: simple
#
# This is the main simple class
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
#   Automatically restarts the simple service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, simple main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, simple main config file has: content => content("$template")
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
#   Automatically include a custom class with extra resources related to simple.
#   Note: Use a subclass name different than simple to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include simple"
# - Set Class defaults and "include simple"
# - Call simple as a parametrized class
#
# ==== USAGE - Basic management
#
# Install simple with default settings
#
#        class { "simple": }
#
# Install simple with specify version
#
#        class { "simple":
#          version => '1.4.3-1.el6',
#        }
# Disable simple service.
#
#        class { "simple":
#          disable => true,
#        }
#
# Disable simple service at boot time, but don't stop if is running.
#
#        class { "simple":
#          disboot => true,
#        }
#
# Remove simple package
#
#        class { "simple":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "simple":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "simple":
#          source => "puppet:///modules/simple/simple.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "simple":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "simple/simple.conf.erb",
#        }
#
# Use custom template for config dir file
#
#        class { "simple":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/simple/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "simple/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# Add extra resources to modules
#
#        class hack_simple {
#          # extra resources here
#        }
#        class { "simple":
#          my_class => "hack_simple",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class simple (
  $absent              = $simple::defaults::absent,
  $disable             = $simple::defaults::disable,
  $disboot             = $simple::defaults::disboot,
  $audit_only          = $simple::defaults::audit_only,
  $restart             = $simple::defaults::restart,
  $version             = $simple::defaults::version,
  $template            = $simple::defaults::template,
  $source              = $simple::defaults::source,
  $options             = $simple::defaults::options,
  $confdir             = $simple::defaults::confdir,
  $my_class            = $simple::defaults::my_class,
  ) inherits simple::defaults {
  contain 'simple::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }
  if $confdir { validate_hash($confdir) }

  ## General parameters
  $system_date         = $simple::params::system_date
  $install_reference   = $simple::params::install_reference
  $service_reference   = $simple::params::service_reference

  ## Package ralated parameters
  $package             = $simple::params::package
  $package_ensure      = $simple::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir          = $simple::params::config_dir
  $config_file         = $simple::params::config_file
  $config_file_ensure  = $simple::params::config_file_ensure
  $config_file_mode    = $simple::params::config_file_mode
  $config_file_owner   = $simple::params::config_file_owner
  $config_file_group   = $simple::params::config_file_group
  $config_file_content = $simple::params::config_file_content
  $config_file_source  = $simple::params::config_file_source
  $config_file_audit   = $simple::params::config_file_audit
  $config_file_replace = $simple::params::config_file_replace

  ## Service ralated parameters
  $service             = $simple::params::service
  $service_enable      = $simple::params::service_enable
  $service_ensure      = $simple::params::service_ensure
  $service_hasstatus   = $simple::params::service_hasstatus
  $service_hasrestart  = $simple::params::service_hasrestart
  $service_restart     = $simple::params::service_restart
  $service_start       = $simple::params::service_start
  $service_stop        = $simple::params::service_stop
  $service_status      = $simple::params::service_status

  ## Essential classes
  contain 'simple::install'
  contain 'simple::config'
  contain 'simple::service'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['simple::install'] -> Class['simple::config'] -> Class['simple::service']
}
