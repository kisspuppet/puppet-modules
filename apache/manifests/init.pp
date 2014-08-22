# == Class: apache
#
# This is the main apache class
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
#   Automatically restarts the apache service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, apache main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, apache main config file has: content => content("$template")
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
#   Automatically include a custom class with extra resources related to apache.
#   Note: Use a subclass name different than apache to avoid order loading issues.
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include apache"
# - Set Class defaults and "include apache"
# - Call apache as a parametrized class
#
# ==== USAGE - Basic management
#
# Install apache with default settings
#
#        class { "apache": }
#
# Install apache with specify version
#
#        class { "apache":
#          version => '1.4.3-1.el6',
#        }
# Disable apache service.
#
#        class { "apache":
#          disable => true,
#        }
#
# Disable apache service at boot time, but don't stop if is running.
#
#        class { "apache":
#          disboot => true,
#        }
#
# Remove apache package
#
#        class { "apache":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "apache":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "apache":
#          source => "puppet:///modules/apache/apache.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "apache":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "apache/apache.conf.erb",
#        }
#
# Use custom sources for initial config file
#
#        class { "apache":
#          confinit => "puppet:///modules/apache/apache.init.conf",
#        }
#
# Use custom template for config dir file
#
#        class { "apache":
#          confdir => {
#            'config1.conf': {
#              source => "puppet:///modules/apache/confdir/config1.conf",
#              ensure => directory,
#              purge  => true,
#            },
#            'config2.conf': {
#              template => "apache/config2.conf.erb",
#              mode     => 0600,
#            },
#          },
#        }
#
# Add extra resources to modules
#
#        class hack_apache {
#          # extra resources here
#        }
#        class { "apache":
#          my_class => "hack_apache",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class apache (
  $absent              = $apache::defaults::absent,
  $disable             = $apache::defaults::disable,
  $disboot             = $apache::defaults::disboot,
  $audit_only          = $apache::defaults::audit_only,
  $restart             = $apache::defaults::restart,
  $version             = $apache::defaults::version,
  $template            = $apache::defaults::template,
  $source              = $apache::defaults::source,
  $options             = $apache::defaults::options,
  $confdir             = $apache::defaults::confdir,
  $confinit            = $apache::defaults::confinit,
  $datadir             = $apache::defaults::datadir,
  $my_class            = $apache::defaults::my_class,
  $enable_module       = $apache::defaults::enable_module,
  ) inherits apache::defaults {
  contain 'apache::params'

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
  $system_date         = $apache::params::system_date
  $install_reference   = $apache::params::install_reference
  $service_reference   = $apache::params::service_reference

  ## Package ralated parameters
  $package             = $apache::params::package
  $package_ensure      = $apache::params::package_ensure

  ## Configuration file ralated parameters
  $config_dir              = $apache::params::config_dir
  $config_file             = $apache::params::config_file
  $config_file_init        = $apache::params::config_file_init
  $config_file_init_source = $apache::params::config_file_init_source
  $config_file_ensure      = $apache::params::config_file_ensure
  $config_file_mode        = $apache::params::config_file_mode
  $config_file_owner       = $apache::params::config_file_owner
  $config_file_group       = $apache::params::config_file_group
  $config_file_content     = $apache::params::config_file_content
  $config_file_source      = $apache::params::config_file_source
  $config_file_audit       = $apache::params::config_file_audit
  $config_file_replace     = $apache::params::config_file_replace

  ## Data ralated parameters
  $data_dir            = $apache::params::data_dir
  $data_file_mode      = $apache::params::data_file_mode
  $data_file_owner     = $apache::params::data_file_owner
  $data_file_group     = $apache::params::data_file_group

  ## Service ralated parameters
  $service             = $apache::params::service
  $service_enable      = $apache::params::service_enable
  $service_ensure      = $apache::params::service_ensure
  $service_hasstatus   = $apache::params::service_hasstatus
  $service_hasrestart  = $apache::params::service_hasrestart
  $service_restart     = $apache::params::service_restart
  $service_start       = $apache::params::service_start
  $service_stop        = $apache::params::service_stop
  $service_status      = $apache::params::service_status

  ## Essential classes
  contain 'apache::install'
  contain 'apache::config'
  contain 'apache::service'
  contain 'apache::data'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['apache::install'] -> Class['apache::config'] -> Class['apache::service'] -> Class['apache::data']
}
