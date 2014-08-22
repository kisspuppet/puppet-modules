# == Class: minimal
#
# This is the main minimal class
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
#   Automatically restarts the minimal service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, minimal main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, minimal main config file has: content => content("$template")
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
# [*my_class*]
#   Automatically include a custom class with extra resources related to minimal.
#   Note: Use a subclass name different than minimal to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include minimal"
# - Set Class defaults and "include minimal"
# - Call minimal as a parametrized class
#
# ==== USAGE - Basic management
#
# Install minimal with default settings
#
#        class { "minimal": }
#
# Install minimal with specify version
#
#        class { "minimal":
#          version => '1.4.3-1.el6',
#        }
# Disable minimal service.
#
#        class { "minimal":
#          disable => true,
#        }
#
# Disable minimal service at boot time, but don't stop if is running.
#
#        class { "minimal":
#          disboot => true,
#        }
#
# Remove minimal package
#
#        class { "minimal":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "minimal":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "minimal":
#          source => "puppet:///modules/minimal/minimal.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "minimal":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "minimal/minimal.conf.erb",
#        }
#
# Add extra resources to modules
#
#        class hack_minimal {
#          # extra resources here
#        }
#        class { "minimal":
#          my_class => "hack_minimal",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class minimal (
  $absent              = $minimal::defaults::absent,
  $disable             = $minimal::defaults::disable,
  $disboot             = $minimal::defaults::disboot,
  $audit_only          = $minimal::defaults::audit_only,
  $restart             = $minimal::defaults::restart,
  $version             = $minimal::defaults::version,
  $template            = $minimal::defaults::template,
  $source              = $minimal::defaults::source,
  $options             = $minimal::defaults::options,
  $my_class            = $minimal::defaults::my_class,
  ) inherits minimal::defaults {
  contain 'minimal::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }

  ## General parameters
  $system_date         = $minimal::params::system_date
  $install_reference   = $minimal::params::install_reference
  $service_reference   = $minimal::params::service_reference

  ## Package ralated parameters
  $package             = $minimal::params::package
  $package_ensure      = $minimal::params::package_ensure

  ## Configuration file ralated parameters
  $config_file         = $minimal::params::config_file
  $config_file_ensure  = $minimal::params::config_file_ensure
  $config_file_mode    = $minimal::params::config_file_mode
  $config_file_owner   = $minimal::params::config_file_owner
  $config_file_group   = $minimal::params::config_file_group
  $config_file_content = $minimal::params::config_file_content
  $config_file_source  = $minimal::params::config_file_source
  $config_file_audit   = $minimal::params::config_file_audit
  $config_file_replace = $minimal::params::config_file_replace

  ## Service ralated parameters
  $service             = $minimal::params::service
  $service_enable      = $minimal::params::service_enable
  $service_ensure      = $minimal::params::service_ensure
  $service_hasstatus   = $minimal::params::service_hasstatus
  $service_hasrestart  = $minimal::params::service_hasrestart
  $service_restart     = $minimal::params::service_restart
  $service_start       = $minimal::params::service_start
  $service_stop        = $minimal::params::service_stop
  $service_status      = $minimal::params::service_status

  ## Essential classes
  contain 'minimal::install'
  contain 'minimal::config'
  contain 'minimal::service'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['minimal::install'] -> Class['minimal::config'] -> Class['minimal::service']
}
