# == Class: mcollective_client
#
# This is the main mcollective_client class
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
#   Automatically restarts the mcollective_client service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, mcollective_client main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, mcollective_client main config file has: content => content("$template")
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
#   Automatically include a custom class with extra resources related to mcollective_client.
#   Note: Use a subclass name different than mcollective_client to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include mcollective_client"
# - Set Class defaults and "include mcollective_client"
# - Call mcollective_client as a parametrized class
#
# ==== USAGE - Basic management
#
# Install mcollective_client with default settings
#
#        class { "mcollective_client": }
#
# Install mcollective_client with specify version
#
#        class { "mcollective_client":
#          version => '1.4.3-1.el6',
#        }
# Disable mcollective_client service.
#
#        class { "mcollective_client":
#          disable => true,
#        }
#
# Disable mcollective_client service at boot time, but don't stop if is running.
#
#        class { "mcollective_client":
#          disboot => true,
#        }
#
# Remove mcollective_client package
#
#        class { "mcollective_client":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "mcollective_client":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "mcollective_client":
#          source => "puppet:///modules/mcollective_client/mcollective_client.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "mcollective_client":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "mcollective_client/mcollective_client.conf.erb",
#        }
#
# Use custom template for config dir file
#
#        class { "mcollective_client":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/mcollective_client/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "mcollective_client/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# Add extra resources to modules
#
#        class hack_mcollective_client {
#          # extra resources here
#        }
#        class { "mcollective_client":
#          my_class => "hack_mcollective_client",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class mcollective_client (
  $absent              = $mcollective_client::defaults::absent,
  $disable             = $mcollective_client::defaults::disable,
  $disboot             = $mcollective_client::defaults::disboot,
  $audit_only          = $mcollective_client::defaults::audit_only,
  $restart             = $mcollective_client::defaults::restart,
  $version             = $mcollective_client::defaults::version,
  $template            = $mcollective_client::defaults::template,
  $source              = $mcollective_client::defaults::source,
  $options             = $mcollective_client::defaults::options,
  $confdir             = $mcollective_client::defaults::confdir,
  $my_class            = $mcollective_client::defaults::my_class,
  $enable_module       = $mcollective_client::defaults::enable_module,
  ) inherits mcollective_client::defaults {
  contain 'mcollective_client::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }
  if $confdir { validate_hash($confdir) }

  ## General parameters
  $system_date         = $mcollective_client::params::system_date
  $install_reference   = $mcollective_client::params::install_reference
  $service_reference   = $mcollective_client::params::service_reference

  ## Package ralated parameters
  $package             = $mcollective_client::params::package
  $package_ensure      = $mcollective_client::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir          = $mcollective_client::params::config_dir
  $config_file         = $mcollective_client::params::config_file
  $config_file_ensure  = $mcollective_client::params::config_file_ensure
  $config_file_mode    = $mcollective_client::params::config_file_mode
  $config_file_owner   = $mcollective_client::params::config_file_owner
  $config_file_group   = $mcollective_client::params::config_file_group
  $config_file_content = $mcollective_client::params::config_file_content
  $config_file_source  = $mcollective_client::params::config_file_source
  $config_file_audit   = $mcollective_client::params::config_file_audit
  $config_file_replace = $mcollective_client::params::config_file_replace

  ## Service ralated parameters
  $service             = $mcollective_client::params::service
  $service_enable      = $mcollective_client::params::service_enable
  $service_ensure      = $mcollective_client::params::service_ensure
  $service_hasstatus   = $mcollective_client::params::service_hasstatus
  $service_hasrestart  = $mcollective_client::params::service_hasrestart
  $service_restart     = $mcollective_client::params::service_restart
  $service_start       = $mcollective_client::params::service_start
  $service_stop        = $mcollective_client::params::service_stop
  $service_status      = $mcollective_client::params::service_status

  ## Essential classes
  contain 'mcollective_client::install'
  contain 'mcollective_client::config'
  contain 'mcollective_client::service'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['mcollective_client::install'] -> Class['mcollective_client::config'] -> Class['mcollective_client::service']
}
