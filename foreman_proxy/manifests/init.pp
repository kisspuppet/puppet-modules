# == Class: foreman_proxy
#
# This is the main foreman_proxy class
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
#   Automatically restarts the foreman_proxy service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, foreman_proxy main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, foreman_proxy main config file has: content => content("$template")
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
#   Automatically include a custom class with extra resources related to foreman_proxy.
#   Note: Use a subclass name different than foreman_proxy to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include foreman_proxy"
# - Set Class defaults and "include foreman_proxy"
# - Call foreman_proxy as a parametrized class
#
# ==== USAGE - Basic management
#
# Install foreman_proxy with default settings
#
#        class { "foreman_proxy": }
#
# Install foreman_proxy with specify version
#
#        class { "foreman_proxy":
#          version => '1.4.3-1.el6',
#        }
# Disable foreman_proxy service.
#
#        class { "foreman_proxy":
#          disable => true,
#        }
#
# Disable foreman_proxy service at boot time, but don't stop if is running.
#
#        class { "foreman_proxy":
#          disboot => true,
#        }
#
# Remove foreman_proxy package
#
#        class { "foreman_proxy":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "foreman_proxy":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "foreman_proxy":
#          source => "puppet:///modules/foreman_proxy/foreman_proxy.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "foreman_proxy":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "foreman_proxy/foreman_proxy.conf.erb",
#        }
#
# Add extra resources to modules
#
#        class hack_foreman_proxy {
#          # extra resources here
#        }
#        class { "foreman_proxy":
#          my_class => "hack_foreman_proxy",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class foreman_proxy (
  $absent              = $foreman_proxy::defaults::absent,
  $disable             = $foreman_proxy::defaults::disable,
  $disboot             = $foreman_proxy::defaults::disboot,
  $audit_only          = $foreman_proxy::defaults::audit_only,
  $restart             = $foreman_proxy::defaults::restart,
  $version             = $foreman_proxy::defaults::version,
  $template            = $foreman_proxy::defaults::template,
  $source              = $foreman_proxy::defaults::source,
  $options             = $foreman_proxy::defaults::options,
  $my_class            = $foreman_proxy::defaults::my_class,
  $install_options     = $foreman_proxy::defaults::install_options,
  ) inherits foreman_proxy::defaults {
  contain 'foreman_proxy::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }

  ## General parameters
  $system_date         = $foreman_proxy::params::system_date
  $install_reference   = $foreman_proxy::params::install_reference
  $service_reference   = $foreman_proxy::params::service_reference

  ## Package ralated parameters
  $package             = $foreman_proxy::params::package
  $package_ensure      = $foreman_proxy::params::package_ensure

  ## Configuration file ralated parameters
  $config_file         = $foreman_proxy::params::config_file
  $config_file_ensure  = $foreman_proxy::params::config_file_ensure
  $config_file_mode    = $foreman_proxy::params::config_file_mode
  $config_file_owner   = $foreman_proxy::params::config_file_owner
  $config_file_group   = $foreman_proxy::params::config_file_group
  $config_file_content = $foreman_proxy::params::config_file_content
  $config_file_source  = $foreman_proxy::params::config_file_source
  $config_file_audit   = $foreman_proxy::params::config_file_audit
  $config_file_replace = $foreman_proxy::params::config_file_replace

  ## Service ralated parameters
  $service             = $foreman_proxy::params::service
  $service_enable      = $foreman_proxy::params::service_enable
  $service_ensure      = $foreman_proxy::params::service_ensure
  $service_hasstatus   = $foreman_proxy::params::service_hasstatus
  $service_hasrestart  = $foreman_proxy::params::service_hasrestart
  $service_restart     = $foreman_proxy::params::service_restart
  $service_start       = $foreman_proxy::params::service_start
  $service_stop        = $foreman_proxy::params::service_stop
  $service_status      = $foreman_proxy::params::service_status

  ## Essential classes
  contain 'foreman_proxy::install'
  contain 'foreman_proxy::config'
  contain 'foreman_proxy::service'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['foreman_proxy::install'] -> Class['foreman_proxy::config'] -> Class['foreman_proxy::service']
}
