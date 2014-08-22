# == Class: normal
#
# This is the main normal class
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
#   Automatically restarts the normal service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, normal main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, normal main config file has: content => content("$template")
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
#   Automatically include a custom class with extra resources related to normal.
#   Note: Use a subclass name different than normal to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include normal"
# - Set Class defaults and "include normal"
# - Call normal as a parametrized class
#
# ==== USAGE - Basic management
#
# Install normal with default settings
#
#        class { "normal": }
#
# Install normal with specify version
#
#        class { "normal":
#          version => '1.4.3-1.el6',
#        }
# Disable normal service.
#
#        class { "normal":
#          disable => true,
#        }
#
# Disable normal service at boot time, but don't stop if is running.
#
#        class { "normal":
#          disboot => true,
#        }
#
# Remove normal package
#
#        class { "normal":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "normal":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "normal":
#          source => "puppet:///modules/normal/normal.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "normal":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "normal/normal.conf.erb",
#        }
#
# Use custom sources for initial config file
#
#        class { "normal":
#          confinit => "puppet:///modules/normal/normal.init.conf",
#        }
#
# Use custom template for config dir file
#
#        class { "normal":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/normal/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "normal/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# Add extra resources to modules
#
#        class hack_normal {
#          # extra resources here
#        }
#        class { "normal":
#          my_class => "hack_normal",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class normal (
  $absent              = $normal::defaults::absent,
  $disable             = $normal::defaults::disable,
  $disboot             = $normal::defaults::disboot,
  $audit_only          = $normal::defaults::audit_only,
  $restart             = $normal::defaults::restart,
  $version             = $normal::defaults::version,
  $template            = $normal::defaults::template,
  $source              = $normal::defaults::source,
  $options             = $normal::defaults::options,
  $confdir             = $normal::defaults::confdir,
  $confinit            = $normal::defaults::confinit,
  $datadir             = $normal::defaults::datadir,
  $my_class            = $normal::defaults::my_class,
  ) inherits normal::defaults {
  contain 'normal::params'

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
  $system_date         = $normal::params::system_date
  $install_reference   = $normal::params::install_reference
  $service_reference   = $normal::params::service_reference

  ## Package ralated parameters
  $package             = $normal::params::package
  $package_ensure      = $normal::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir              = $normal::params::config_dir
  $config_file             = $normal::params::config_file
  $config_file_init        = $normal::params::config_file_init
  $config_file_init_source = $normal::params::config_file_init_source
  $config_file_ensure      = $normal::params::config_file_ensure
  $config_file_mode        = $normal::params::config_file_mode
  $config_file_owner       = $normal::params::config_file_owner
  $config_file_group       = $normal::params::config_file_group
  $config_file_content     = $normal::params::config_file_content
  $config_file_source      = $normal::params::config_file_source
  $config_file_audit       = $normal::params::config_file_audit
  $config_file_replace     = $normal::params::config_file_replace

  ## Data ralated parameters
  $data_dir            = $normal::params::data_dir
  $data_file_mode      = $normal::params::data_file_mode
  $data_file_owner     = $normal::params::data_file_owner
  $data_file_group     = $normal::params::data_file_group

  ## Service ralated parameters
  $service             = $normal::params::service
  $service_enable      = $normal::params::service_enable
  $service_ensure      = $normal::params::service_ensure
  $service_hasstatus   = $normal::params::service_hasstatus
  $service_hasrestart  = $normal::params::service_hasrestart
  $service_restart     = $normal::params::service_restart
  $service_start       = $normal::params::service_start
  $service_stop        = $normal::params::service_stop
  $service_status      = $normal::params::service_status

  ## Essential classes
  contain 'normal::install'
  contain 'normal::config'
  contain 'normal::service'
  contain 'normal::data'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['normal::install'] -> Class['normal::config'] -> Class['normal::service'] -> Class['normal::data']
}
