# == Class: php
#
# This is the main php class
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
#   Automatically restarts the php service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, php main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, php main config file has: content => content("$template")
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
#   Automatically include a custom class with extra resources related to php.
#   Note: Use a subclass name different than php to avoid order loading issues.
#
# [*enable_module*]
#   Manage php modules, accept array to enable multi-modules.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include php"
# - Set Class defaults and "include php"
# - Call php as a parametrized class
#
# ==== USAGE - Basic management
#
# Install php with default settings
#
#        class { "php": }
#
# Install php with specify version
#
#        class { "php":
#          version => '1.4.3-1.el6',
#        }
# Disable php service.
#
#        class { "php":
#          disable => true,
#        }
#
# Disable php service at boot time, but don't stop if is running.
#
#        class { "php":
#          disboot => true,
#        }
#
# Remove php package
#
#        class { "php":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "php":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "php":
#          source => "puppet:///modules/php/php.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "php":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "php/php.conf.erb",
#        }
#
# Use custom template for config dir file
#
#        class { "php":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/php/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "php/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# Add extra resources to modules
#
#        class hack_php {
#          # extra resources here
#        }
#        class { "php":
#          my_class => "hack_php",
#        }
#
# Install extra php modules
#
#        class { "php":
#          enable_module => ['gd', 'xml'],
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class php (
  $absent              = $php::defaults::absent,
  $disable             = $php::defaults::disable,
  $disboot             = $php::defaults::disboot,
  $audit_only          = $php::defaults::audit_only,
  $restart             = $php::defaults::restart,
  $version             = $php::defaults::version,
  $template            = $php::defaults::template,
  $source              = $php::defaults::source,
  $options             = $php::defaults::options,
  $confdir             = $php::defaults::confdir,
  $my_class            = $php::defaults::my_class,
  $enable_module       = $php::defaults::enable_module,
  ) inherits php::defaults {
  contain 'php::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }
  if $confdir { validate_hash($confdir) }

  ## General parameters
  $system_date         = $php::params::system_date
  $install_reference   = $php::params::install_reference
  $service_reference   = $php::params::service_reference

  ## Package ralated parameters
  $package             = $php::params::package
  $package_ensure      = $php::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir          = $php::params::config_dir
  $config_file         = $php::params::config_file
  $config_file_ensure  = $php::params::config_file_ensure
  $config_file_mode    = $php::params::config_file_mode
  $config_file_owner   = $php::params::config_file_owner
  $config_file_group   = $php::params::config_file_group
  $config_file_content = $php::params::config_file_content
  $config_file_source  = $php::params::config_file_source
  $config_file_audit   = $php::params::config_file_audit
  $config_file_replace = $php::params::config_file_replace

  ## Service ralated parameters
  $service             = $php::params::service
  $service_enable      = $php::params::service_enable
  $service_ensure      = $php::params::service_ensure
  $service_hasstatus   = $php::params::service_hasstatus
  $service_hasrestart  = $php::params::service_hasrestart
  $service_restart     = $php::params::service_restart
  $service_start       = $php::params::service_start
  $service_stop        = $php::params::service_stop
  $service_status      = $php::params::service_status

  ## Essential classes
  contain 'php::install'
  contain 'php::config'
  contain 'php::service'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['php::install'] -> Class['php::config'] -> Class['php::service']
}
