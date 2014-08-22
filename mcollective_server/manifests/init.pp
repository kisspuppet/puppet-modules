# == Class: mcollective_server
#
# This is the main mcollective_server class
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
#   Automatically restarts the mcollective_server service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, mcollective_server main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, mcollective_server main config file has: content => content("$template")
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
#   Automatically include a custom class with extra resources related to mcollective_server.
#   Note: Use a subclass name different than mcollective_server to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include mcollective_server"
# - Set Class defaults and "include mcollective_server"
# - Call mcollective_server as a parametrized class
#
# ==== USAGE - Basic management
#
# Install mcollective_server with default settings
#
#        class { "mcollective_server": }
#
# Install mcollective_server with specify version
#
#        class { "mcollective_server":
#          version => '1.4.3-1.el6',
#        }
# Disable mcollective_server service.
#
#        class { "mcollective_server":
#          disable => true,
#        }
#
# Disable mcollective_server service at boot time, but don't stop if is running.
#
#        class { "mcollective_server":
#          disboot => true,
#        }
#
# Remove mcollective_server package
#
#        class { "mcollective_server":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "mcollective_server":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "mcollective_server":
#          source => "puppet:///modules/mcollective_server/mcollective_server.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "mcollective_server":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "mcollective_server/mcollective_server.conf.erb",
#        }
#
# Use custom template for config dir file
#
#        class { "mcollective_server":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/mcollective_server/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "mcollective_server/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# Add extra resources to modules
#
#        class hack_mcollective_server {
#          # extra resources here
#        }
#        class { "mcollective_server":
#          my_class => "hack_mcollective_server",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class mcollective_server (
  $absent              = $mcollective_server::defaults::absent,
  $disable             = $mcollective_server::defaults::disable,
  $disboot             = $mcollective_server::defaults::disboot,
  $audit_only          = $mcollective_server::defaults::audit_only,
  $restart             = $mcollective_server::defaults::restart,
  $version             = $mcollective_server::defaults::version,
  $template            = $mcollective_server::defaults::template,
  $source              = $mcollective_server::defaults::source,
  $options             = $mcollective_server::defaults::options,
  $confdir             = $mcollective_server::defaults::confdir,
  $my_class            = $mcollective_server::defaults::my_class,
  $enable_module       = $mcollective_server::defaults::enable_module,
  ) inherits mcollective_server::defaults {
  contain 'mcollective_server::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }
  if $confdir { validate_hash($confdir) }

  ## General parameters
  $system_date         = $mcollective_server::params::system_date
  $install_reference   = $mcollective_server::params::install_reference
  $service_reference   = $mcollective_server::params::service_reference

  ## Package ralated parameters
  $package             = $mcollective_server::params::package
  $package_ensure      = $mcollective_server::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir          = $mcollective_server::params::config_dir
  $config_file         = $mcollective_server::params::config_file
  $config_file_ensure  = $mcollective_server::params::config_file_ensure
  $config_file_mode    = $mcollective_server::params::config_file_mode
  $config_file_owner   = $mcollective_server::params::config_file_owner
  $config_file_group   = $mcollective_server::params::config_file_group
  $config_file_content = $mcollective_server::params::config_file_content
  $config_file_source  = $mcollective_server::params::config_file_source
  $config_file_audit   = $mcollective_server::params::config_file_audit
  $config_file_replace = $mcollective_server::params::config_file_replace

  ## Service ralated parameters
  $service             = $mcollective_server::params::service
  $service_enable      = $mcollective_server::params::service_enable
  $service_ensure      = $mcollective_server::params::service_ensure
  $service_hasstatus   = $mcollective_server::params::service_hasstatus
  $service_hasrestart  = $mcollective_server::params::service_hasrestart
  $service_restart     = $mcollective_server::params::service_restart
  $service_start       = $mcollective_server::params::service_start
  $service_stop        = $mcollective_server::params::service_stop
  $service_status      = $mcollective_server::params::service_status

  ## Essential classes
  contain 'mcollective_server::install'
  contain 'mcollective_server::config'
  contain 'mcollective_server::service'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['mcollective_server::install'] -> Class['mcollective_server::config'] -> Class['mcollective_server::service']
}
