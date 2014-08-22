# == Class: rabbitmq
#
# This is the main rabbitmq class
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
#   Automatically restarts the rabbitmq service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, rabbitmq main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, rabbitmq main config file has: content => content("$template")
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
#   Automatically include a custom class with extra resources related to rabbitmq.
#   Note: Use a subclass name different than rabbitmq to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include rabbitmq"
# - Set Class defaults and "include rabbitmq"
# - Call rabbitmq as a parametrized class
#
# ==== USAGE - Basic management
#
# Install rabbitmq with default settings
#
#        class { "rabbitmq": }
#
# Install rabbitmq with specify version
#
#        class { "rabbitmq":
#          version => '1.4.3-1.el6',
#        }
# Disable rabbitmq service.
#
#        class { "rabbitmq":
#          disable => true,
#        }
#
# Disable rabbitmq service at boot time, but don't stop if is running.
#
#        class { "rabbitmq":
#          disboot => true,
#        }
#
# Remove rabbitmq package
#
#        class { "rabbitmq":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "rabbitmq":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "rabbitmq":
#          source => "puppet:///modules/rabbitmq/rabbitmq.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "rabbitmq":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "rabbitmq/rabbitmq.conf.erb",
#        }
#
# Use custom template for config dir file
#
#        class { "rabbitmq":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/rabbitmq/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "rabbitmq/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# Add extra resources to modules
#
#        class hack_rabbitmq {
#          # extra resources here
#        }
#        class { "rabbitmq":
#          my_class => "hack_rabbitmq",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class rabbitmq (
  $absent              = $rabbitmq::defaults::absent,
  $disable             = $rabbitmq::defaults::disable,
  $disboot             = $rabbitmq::defaults::disboot,
  $audit_only          = $rabbitmq::defaults::audit_only,
  $restart             = $rabbitmq::defaults::restart,
  $version             = $rabbitmq::defaults::version,
  $template            = $rabbitmq::defaults::template,
  $source              = $rabbitmq::defaults::source,
  $options             = $rabbitmq::defaults::options,
  $confdir             = $rabbitmq::defaults::confdir,
  $my_class            = $rabbitmq::defaults::my_class,
  $enable_plugin       = $rabbitmq::defaults::enable_plugin,
  $instance            = $rabbitmq::defaults::instance,
  $exchange            = $rabbitmq::defaults::exchange,
  ) inherits rabbitmq::defaults {
  contain 'rabbitmq::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }
  if $confdir { validate_hash($confdir) }
  if $instance { validate_hash($instance) }
  if $exchange { validate_hash($exchange) }

  ## General parameters
  $system_date         = $rabbitmq::params::system_date
  $install_reference   = $rabbitmq::params::install_reference
  $service_reference   = $rabbitmq::params::service_reference

  ## Package ralated parameters
  $package             = $rabbitmq::params::package
  $package_ensure      = $rabbitmq::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir          = $rabbitmq::params::config_dir
  $config_file         = $rabbitmq::params::config_file
  $config_file_ensure  = $rabbitmq::params::config_file_ensure
  $config_file_mode    = $rabbitmq::params::config_file_mode
  $config_file_owner   = $rabbitmq::params::config_file_owner
  $config_file_group   = $rabbitmq::params::config_file_group
  $config_file_content = $rabbitmq::params::config_file_content
  $config_file_source  = $rabbitmq::params::config_file_source
  $config_file_audit   = $rabbitmq::params::config_file_audit
  $config_file_replace = $rabbitmq::params::config_file_replace

  ## Service ralated parameters
  $service             = $rabbitmq::params::service
  $service_enable      = $rabbitmq::params::service_enable
  $service_ensure      = $rabbitmq::params::service_ensure
  $service_hasstatus   = $rabbitmq::params::service_hasstatus
  $service_hasrestart  = $rabbitmq::params::service_hasrestart
  $service_restart     = $rabbitmq::params::service_restart
  $service_start       = $rabbitmq::params::service_start
  $service_stop        = $rabbitmq::params::service_stop
  $service_status      = $rabbitmq::params::service_status

  ## Essential classes
  contain 'rabbitmq::install'
  contain 'rabbitmq::config'
  contain 'rabbitmq::plugin'
  contain 'rabbitmq::service'
  contain 'rabbitmq::data'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['rabbitmq::install'] -> Class['rabbitmq::config'] -> Class['rabbitmq::plugin'] -> Class['rabbitmq::service'] -> Class['rabbitmq::data']
}
