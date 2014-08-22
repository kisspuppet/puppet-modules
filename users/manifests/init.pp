# == Class: users
#
# This is the main users class
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
#   Automatically restarts the users service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, users main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, users main config file has: content => content("$template")
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
#     * owner
#     * group
#     * source
#     * template
#     * purge
#     * mode
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include users"
# - Set Class defaults and "include users"
# - Call users as a parametrized class
#
# ==== USAGE - Basic management
#
# Install users with default settings
#
#        class { "users": }
#
# Install users with specify version
#
#        class { "users":
#          version => '1.4.3-1.el6',
#        }
# Disable users service.
#
#        class { "users":
#          disable => true,
#        }
#
# Disable users service at boot time, but don't stop if is running.
#
#        class { "users":
#          disboot => true
#        }
#
# Remove users package
#
#        class { "users":
#          absent => true
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "users":
#          source => "puppet:///modules/users/users.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "users":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "users/users.conf.erb",
#        }
#
# Use custom template for config dir file
#
#        class { "users":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/users/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "users/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# An example hiera yaml file for puppet 3.x data binding
#
# ---
# users::absent: true
# users::source: puppet:///modules/users/users.conf
# users::options:
#   var1: value1
#   var2: value2
# users::confdir:
#   confdir1:
#     ensure: directory
#     mode: 0600
#   confdir2:
#     mode: 0644
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class users (
  $absent              = $users::defaults::absent,
  $disable             = $users::defaults::disable,
  $disboot             = $users::defaults::disboot,
  $audit_only          = $users::defaults::audit_only,
  $restart             = $users::defaults::restart,
  $version             = $users::defaults::version,
  $template            = $users::defaults::template,
  $source              = $users::defaults::source,
  $options             = $users::defaults::options,
  $confdir           = $users::defaults::confdir,
  ) inherits users::defaults {
  include users::params

  ## General parameters
  $system_date         = $users::params::system_date
  $install_reference   = $users::params::install_reference
  $service_reference   = $users::params::service_reference

  ## Package ralated parameters
  $package             = $users::params::package
  $package_ensure      = $users::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir          = $users::params::config_dir
  $config_file         = $users::params::config_file
  $config_file_ensure  = $users::params::config_file_ensure
  $config_file_mode    = $users::params::config_file_mode
  $config_file_owner   = $users::params::config_file_owner
  $config_file_group   = $users::params::config_file_group
  $config_file_content = $users::params::config_file_content
  $config_file_source  = $users::params::config_file_source
  $config_file_init    = $users::params::config_file_init
  $config_file_audit   = $users::params::config_file_audit
  $config_file_replace = $users::params::config_file_replace


  ## Service ralated parameters
  $service             = $users::params::service
  $service_enable      = $users::params::service_enable
  $service_ensure      = $users::params::service_ensure
  $service_status      = $users::params::service_status

  ## essential classes
  include users::install
  include users::config
  include users::service
}
