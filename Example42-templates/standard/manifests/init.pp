# == Class: standard
#
# This is the main standard class
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
#   Automatically restarts the standard service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, standard main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, standard main config file has: content => content("$template")
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
# [*datadir*]
#   Manage data file which locate in data directory.
#   Available options:
#     * ensure
#     * source
#     * template
#     * owner
#     * group
#     * mode
#
# [*my_class*]
#   Automatically include a custom class with extra resources related to standard.
#   Note: Use a subclass name different than standard to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include standard"
# - Set Class defaults and "include standard"
# - Call standard as a parametrized class
#
# ==== USAGE - Basic management
#
# Install standard with default settings
#
#        class { "standard": }
#
# Install standard with specify version
#
#        class { "standard":
#          version => '1.4.3-1.el6',
#        }
# Disable standard service.
#
#        class { "standard":
#          disable => true,
#        }
#
# Disable standard service at boot time, but don't stop if is running.
#
#        class { "standard":
#          disboot => true,
#        }
#
# Remove standard package
#
#        class { "standard":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "standard":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "standard":
#          source => "puppet:///modules/standard/standard.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "standard":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "standard/standard.conf.erb",
#        }
#
# Use custom template for config dir file
#
#        class { "standard":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/standard/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "standard/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# Add extra resources to modules
#
#        class hack_standard {
#          # extra resources here
#        }
#        class { "standard":
#          my_class => "hack_standard",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class standard (
  $absent              = $standard::defaults::absent,
  $disable             = $standard::defaults::disable,
  $disboot             = $standard::defaults::disboot,
  $audit_only          = $standard::defaults::audit_only,
  $restart             = $standard::defaults::restart,
  $version             = $standard::defaults::version,
  $template            = $standard::defaults::template,
  $source              = $standard::defaults::source,
  $options             = $standard::defaults::options,
  $confdir             = $standard::defaults::confdir,
  $datadir             = $standard::defaults::datadir,
  $my_class            = $standard::defaults::my_class,
  ) inherits standard::defaults {
  contain 'standard::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }
  if $confdir { validate_hash($confdir) }
  if $datadir { validate_hash($datadir) }

  ## General parameters
  $system_date         = $standard::params::system_date
  $install_reference   = $standard::params::install_reference
  $service_reference   = $standard::params::service_reference

  ## Package ralated parameters
  $package             = $standard::params::package
  $package_ensure      = $standard::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir          = $standard::params::config_dir
  $config_file         = $standard::params::config_file
  $config_file_ensure  = $standard::params::config_file_ensure
  $config_file_mode    = $standard::params::config_file_mode
  $config_file_owner   = $standard::params::config_file_owner
  $config_file_group   = $standard::params::config_file_group
  $config_file_content = $standard::params::config_file_content
  $config_file_source  = $standard::params::config_file_source
  $config_file_audit   = $standard::params::config_file_audit
  $config_file_replace = $standard::params::config_file_replace

  ## Data ralated parameters
  $data_dir            = $standard::params::data_dir
  $data_file_mode      = $standard::params::data_file_mode
  $data_file_owner     = $standard::params::data_file_owner
  $data_file_group     = $standard::params::data_file_group

  ## Service ralated parameters
  $service             = $standard::params::service
  $service_enable      = $standard::params::service_enable
  $service_ensure      = $standard::params::service_ensure
  $service_hasstatus   = $standard::params::service_hasstatus
  $service_hasrestart  = $standard::params::service_hasrestart
  $service_restart     = $standard::params::service_restart
  $service_start       = $standard::params::service_start
  $service_stop        = $standard::params::service_stop
  $service_status      = $standard::params::service_status

  ## Essential classes
  contain 'standard::install'
  contain 'standard::config'
  contain 'standard::service'
  contain 'standard::data'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['standard::install'] -> Class['standard::config'] -> Class['standard::service'] -> Class['standard::data']
}
