# == Class: puppet_server
#
# This is the main puppet_server class
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
#   Automatically restarts the puppet_server service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, puppet_server main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, puppet_server main config file has: content => content("$template")
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
# [*confinit*]
#   Manage initial config file.
#   If defined, initial config file will have the param: source => $confinit
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
#   Automatically include a custom class with extra resources related to puppet_server.
#   Note: Use a subclass name different than puppet_server to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include puppet_server"
# - Set Class defaults and "include puppet_server"
# - Call puppet_server as a parametrized class
#
# ==== USAGE - Basic management
#
# Install puppet_server with default settings
#
#        class { "puppet_server": }
#
# Install puppet_server with specify version
#
#        class { "puppet_server":
#          version => '1.4.3-1.el6',
#        }
# Disable puppet_server service.
#
#        class { "puppet_server":
#          disable => true,
#        }
#
# Disable puppet_server service at boot time, but don't stop if is running.
#
#        class { "puppet_server":
#          disboot => true,
#        }
#
# Remove puppet_server package
#
#        class { "puppet_server":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "puppet_server":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "puppet_server":
#          source => "puppet:///modules/puppet_server/puppet_server.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "puppet_server":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "puppet_server/puppet_server.conf.erb",
#        }
#
# Use custom sources for initial config file
#
#        class { "puppet_server":
#          confinit => "puppet:///modules/puppet_server/puppet_server.init.conf",
#        }
#
# Use custom template for config dir file
#
#        class { "puppet_server":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/puppet_server/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "puppet_server/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# Add extra resources to modules
#
#        class hack_puppet_server {
#          # extra resources here
#        }
#        class { "puppet_server":
#          my_class => "hack_puppet_server",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class puppet_server (
  $absent              = $puppet_server::defaults::absent,
  $disable             = $puppet_server::defaults::disable,
  $disboot             = $puppet_server::defaults::disboot,
  $audit_only          = $puppet_server::defaults::audit_only,
  $restart             = $puppet_server::defaults::restart,
  $version             = $puppet_server::defaults::version,
  $template            = $puppet_server::defaults::template,
  $source              = $puppet_server::defaults::source,
  $options             = $puppet_server::defaults::options,
  $confdir             = $puppet_server::defaults::confdir,
  $confinit            = $puppet_server::defaults::confinit,
  $datadir             = $puppet_server::defaults::datadir,
  $my_class            = $puppet_server::defaults::my_class,
  ) inherits puppet_server::defaults {
  contain 'puppet_server::params'

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
  $system_date         = $puppet_server::params::system_date
  $install_reference   = $puppet_server::params::install_reference
  $service_reference   = $puppet_server::params::service_reference

  ## Package ralated parameters
  $package             = $puppet_server::params::package
  $package_ensure      = $puppet_server::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir              = $puppet_server::params::config_dir
  $config_file             = $puppet_server::params::config_file
  $config_file_init        = $puppet_server::params::config_file_init
  $config_file_init_source = $puppet_server::params::config_file_init_source
  $config_file_ensure      = $puppet_server::params::config_file_ensure
  $config_file_mode        = $puppet_server::params::config_file_mode
  $config_file_owner       = $puppet_server::params::config_file_owner
  $config_file_group       = $puppet_server::params::config_file_group
  $config_file_content     = $puppet_server::params::config_file_content
  $config_file_source      = $puppet_server::params::config_file_source
  $config_file_audit       = $puppet_server::params::config_file_audit
  $config_file_replace     = $puppet_server::params::config_file_replace

  ## Data ralated parameters
  $data_dir            = $puppet_server::params::data_dir
  $data_file_mode      = $puppet_server::params::data_file_mode
  $data_file_owner     = $puppet_server::params::data_file_owner
  $data_file_group     = $puppet_server::params::data_file_group

  ## Service ralated parameters
  $service             = $puppet_server::params::service
  $service_enable      = $puppet_server::params::service_enable
  $service_ensure      = $puppet_server::params::service_ensure
  $service_hasstatus   = $puppet_server::params::service_hasstatus
  $service_hasrestart  = $puppet_server::params::service_hasrestart
  $service_restart     = $puppet_server::params::service_restart
  $service_start       = $puppet_server::params::service_start
  $service_stop        = $puppet_server::params::service_stop
  $service_status      = $puppet_server::params::service_status

  ## Essential classes
  contain 'puppet_server::install'
  contain 'puppet_server::config'
  contain 'puppet_server::service'
  contain 'puppet_server::data'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['puppet_server::install'] -> Class['puppet_server::config'] -> Class['puppet_server::service'] -> Class['puppet_server::data']
}
