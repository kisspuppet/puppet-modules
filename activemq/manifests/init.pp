# == Class: activemq
#
# This is the main activemq class
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
#   Automatically restarts the activemq service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, activemq main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, activemq main config file has: content => content("$template")
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
#   Automatically include a custom class with extra resources related to activemq.
#   Note: Use a subclass name different than activemq to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include activemq"
# - Set Class defaults and "include activemq"
# - Call activemq as a parametrized class
#
# ==== USAGE - Basic management
#
# Install activemq with default settings
#
#        class { "activemq": }
#
# Install activemq with specify version
#
#        class { "activemq":
#          version => '1.4.3-1.el6',
#        }
# Disable activemq service.
#
#        class { "activemq":
#          disable => true,
#        }
#
# Disable activemq service at boot time, but don't stop if is running.
#
#        class { "activemq":
#          disboot => true,
#        }
#
# Remove activemq package
#
#        class { "activemq":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "activemq":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "activemq":
#          source => "puppet:///modules/activemq/activemq.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "activemq":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "activemq/activemq.conf.erb",
#        }
#
# Use custom template for config dir file
#
#        class { "activemq":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/activemq/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "activemq/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# Add extra resources to modules
#
#        class hack_activemq {
#          # extra resources here
#        }
#        class { "activemq":
#          my_class => "hack_activemq",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class activemq (
  $absent              = $activemq::defaults::absent,
  $disable             = $activemq::defaults::disable,
  $disboot             = $activemq::defaults::disboot,
  $audit_only          = $activemq::defaults::audit_only,
  $restart             = $activemq::defaults::restart,
  $version             = $activemq::defaults::version,
  $template            = $activemq::defaults::template,
  $source              = $activemq::defaults::source,
  $options             = $activemq::defaults::options,
  $confdir             = $activemq::defaults::confdir,
  $my_class            = $activemq::defaults::my_class,
  $keystore_password,
  ) inherits activemq::defaults {
  contain 'activemq::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }
  if $confdir { validate_hash($confdir) }

  ## General parameters
  $system_date         = $activemq::params::system_date
  $install_reference   = $activemq::params::install_reference
  $service_reference   = $activemq::params::service_reference

  ## Package ralated parameters
  $package             = $activemq::params::package
  $package_ensure      = $activemq::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir          = $activemq::params::config_dir
  $config_file         = $activemq::params::config_file
  $config_file_ensure  = $activemq::params::config_file_ensure
  $config_file_mode    = $activemq::params::config_file_mode
  $config_file_owner   = $activemq::params::config_file_owner
  $config_file_group   = $activemq::params::config_file_group
  $config_file_content = $activemq::params::config_file_content
  $config_file_source  = $activemq::params::config_file_source
  $config_file_audit   = $activemq::params::config_file_audit
  $config_file_replace = $activemq::params::config_file_replace

  ## Service ralated parameters
  $service             = $activemq::params::service
  $service_enable      = $activemq::params::service_enable
  $service_ensure      = $activemq::params::service_ensure
  $service_hasstatus   = $activemq::params::service_hasstatus
  $service_hasrestart  = $activemq::params::service_hasrestart
  $service_restart     = $activemq::params::service_restart
  $service_start       = $activemq::params::service_start
  $service_stop        = $activemq::params::service_stop
  $service_status      = $activemq::params::service_status

  ## Essential classes
  contain 'activemq::install'
  contain 'activemq::config'
  contain 'activemq::service'
  contain 'activemq::keystore'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['activemq::install'] -> Class['activemq::keystore'] -> Class['activemq::config'] -> Class['activemq::service']
}
