# == Class: ntp
#
# This is the main ntp class
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
#   Automatically restarts the ntp service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, ntp main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, ntp main config file has: content => content("$template")
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
#   Automatically include a custom class with extra resources related to ntp.
#   Note: Use a subclass name different than ntp to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include ntp"
# - Set Class defaults and "include ntp"
# - Call ntp as a parametrized class
#
# ==== USAGE - Basic management
#
# Install ntp with default settings
#
#        class { "ntp": }
#
# Install ntp with specify version
#
#        class { "ntp":
#          version => '1.4.3-1.el6',
#        }
# Disable ntp service.
#
#        class { "ntp":
#          disable => true,
#        }
#
# Disable ntp service at boot time, but don't stop if is running.
#
#        class { "ntp":
#          disboot => true,
#        }
#
# Remove ntp package
#
#        class { "ntp":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "ntp":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "ntp":
#          source => "puppet:///modules/ntp/ntp.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "ntp":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "ntp/ntp.conf.erb",
#        }
#
# Use custom template for config dir file
#
#        class { "ntp":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/ntp/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "ntp/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# Add extra resources to modules
#
#        class hack_ntp {
#          # extra resources here
#        }
#        class { "ntp":
#          my_class => "hack_ntp",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class ntp (
  $absent              = $ntp::defaults::absent,
  $disable             = $ntp::defaults::disable,
  $disboot             = $ntp::defaults::disboot,
  $audit_only          = $ntp::defaults::audit_only,
  $restart             = $ntp::defaults::restart,
  $version             = $ntp::defaults::version,
  $template            = $ntp::defaults::template,
  $source              = $ntp::defaults::source,
  $options             = $ntp::defaults::options,
  $confdir             = $ntp::defaults::confdir,
  $my_class            = $ntp::defaults::my_class,
  ) inherits ntp::defaults {
  contain 'ntp::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }
  if $confdir { validate_hash($confdir) }

  ## General parameters
  $system_date         = $ntp::params::system_date
  $install_reference   = $ntp::params::install_reference
  $service_reference   = $ntp::params::service_reference

  ## Package ralated parameters
  $package             = $ntp::params::package
  $package_ensure      = $ntp::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir          = $ntp::params::config_dir
  $config_file         = $ntp::params::config_file
  $config_file_ensure  = $ntp::params::config_file_ensure
  $config_file_mode    = $ntp::params::config_file_mode
  $config_file_owner   = $ntp::params::config_file_owner
  $config_file_group   = $ntp::params::config_file_group
  $config_file_content = $ntp::params::config_file_content
  $config_file_source  = $ntp::params::config_file_source
  $config_file_audit   = $ntp::params::config_file_audit
  $config_file_replace = $ntp::params::config_file_replace

  ## Service ralated parameters
  $service             = $ntp::params::service
  $service_enable      = $ntp::params::service_enable
  $service_ensure      = $ntp::params::service_ensure
  $service_hasstatus   = $ntp::params::service_hasstatus
  $service_hasrestart  = $ntp::params::service_hasrestart
  $service_restart     = $ntp::params::service_restart
  $service_start       = $ntp::params::service_start
  $service_stop        = $ntp::params::service_stop
  $service_status      = $ntp::params::service_status

  ## Essential classes
  contain 'ntp::install'
  contain 'ntp::config'
  contain 'ntp::service'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['ntp::install'] -> Class['ntp::config'] -> Class['ntp::service']
}
