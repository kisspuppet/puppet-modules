# == Class: foreman
#
# This is the main foreman class
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
#   Automatically restarts the foreman service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, foreman main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, foreman main config file has: content => content("$template")
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
# [*my_class*]
#   Automatically include a custom class with extra resources related to foreman.
#   Note: Use a subclass name different than foreman to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include foreman"
# - Set Class defaults and "include foreman"
# - Call foreman as a parametrized class
#
# ==== USAGE - Basic management
#
# Install foreman with default settings
#
#        class { "foreman": }
#
# Install foreman with specify version
#
#        class { "foreman":
#          version => '1.4.3-1.el6',
#        }
# Disable foreman service.
#
#        class { "foreman":
#          disable => true,
#        }
#
# Disable foreman service at boot time, but don't stop if is running.
#
#        class { "foreman":
#          disboot => true,
#        }
#
# Remove foreman package
#
#        class { "foreman":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "foreman":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "foreman":
#          source => "puppet:///modules/foreman/foreman.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "foreman":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "foreman/foreman.conf.erb",
#        }
#
# Add extra resources to modules
#
#        class hack_foreman {
#          # extra resources here
#        }
#        class { "foreman":
#          my_class => "hack_foreman",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class foreman (
  $absent              = $foreman::defaults::absent,
  $disable             = $foreman::defaults::disable,
  $disboot             = $foreman::defaults::disboot,
  $audit_only          = $foreman::defaults::audit_only,
  $restart             = $foreman::defaults::restart,
  $version             = $foreman::defaults::version,
  $template            = $foreman::defaults::template,
  $source              = $foreman::defaults::source,
  $options             = $foreman::defaults::options,
  $my_class            = $foreman::defaults::my_class,
  $install_options     = $foreman::defaults::install_options,
  ) inherits foreman::defaults {
  contain 'foreman::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }

  ## General parameters
  $system_date         = $foreman::params::system_date
  $install_reference   = $foreman::params::install_reference
  $service_reference   = $foreman::params::service_reference

  ## Package ralated parameters
  $package             = $foreman::params::package
  $package_ensure      = $foreman::params::package_ensure

  ## Configuration file ralated parameters
  $config_file         = $foreman::params::config_file
  $config_file_ensure  = $foreman::params::config_file_ensure
  $config_file_mode    = $foreman::params::config_file_mode
  $config_file_owner   = $foreman::params::config_file_owner
  $config_file_group   = $foreman::params::config_file_group
  $config_file_content = $foreman::params::config_file_content
  $config_file_source  = $foreman::params::config_file_source
  $config_file_audit   = $foreman::params::config_file_audit
  $config_file_replace = $foreman::params::config_file_replace

  ## Service ralated parameters
  $service             = $foreman::params::service
  $service_enable      = $foreman::params::service_enable
  $service_ensure      = $foreman::params::service_ensure
  $service_hasstatus   = $foreman::params::service_hasstatus
  $service_hasrestart  = $foreman::params::service_hasrestart
  $service_restart     = $foreman::params::service_restart
  $service_start       = $foreman::params::service_start
  $service_stop        = $foreman::params::service_stop
  $service_status      = $foreman::params::service_status

  ## Essential classes
  contain 'foreman::install'
  contain 'foreman::config'
  contain 'foreman::service'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['foreman::install'] -> Class['foreman::config'] -> Class['foreman::service']
}
