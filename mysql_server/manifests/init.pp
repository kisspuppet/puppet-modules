# == Class: mysql_server
#
# This is the main mysql_server class
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
#   Automatically restarts the mysql_server service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, mysql_server main config file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, mysql_server main config file has: content => content("$template")
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
#   Automatically include a custom class with extra resources related to mysql_server.
#   Note: Use a subclass name different than mysql_server to avoid order loading issues.
#
# [*root_pwd*]
#   Set mysql server root password.
#
# [*grant*]
#   
#
# === Examples
#
# You can use this class in 3 ways:
# - Set variables (at hiera yaml file) and "include mysql_server"
# - Set Class defaults and "include mysql_server"
# - Call mysql_server as a parametrized class
#
# ==== USAGE - Basic management
#
# Install mysql_server with default settings
#
#        class { "mysql_server": }
#
# Install mysql_server with specify version
#
#        class { "mysql_server":
#          version => '1.4.3-1.el6',
#        }
# Disable mysql_server service.
#
#        class { "mysql_server":
#          disable => true,
#        }
#
# Disable mysql_server service at boot time, but don't stop if is running.
#
#        class { "mysql_server":
#          disboot => true,
#        }
#
# Remove mysql_server package
#
#        class { "mysql_server":
#          absent => true,
#        }
#
# Only audit all configure file
#
#        class { "mysql_server":
#          audit_only => true,
#        }
#
# ==== USAGE - Overrides and Customizations
# Use custom sources for main config file
#
#        class { "mysql_server":
#          source => "puppet:///modules/mysql_server/mysql_server.conf-${hostname}",
#        }
#
# Use custom template for main config file
#
#        class { "mysql_server":
#          options  => {
#            'var1' => "value1",
#            'var2' => "value2",
#          },
#          template => "mysql_server/mysql_server.conf.erb",
#        }
#
# Add extra resources to modules
#
#        class hack_mysql_server {
#          # extra resources here
#        }
#        class { "mysql_server":
#          my_class => "hack_mysql_server",
#        }
#
# === Authors
#
# Hailu Ju <linuxcpp.org@gmail.com>
# KissPuppet <yum.linux@gmail.com>
#
class mysql_server (
  $absent              = $mysql_server::defaults::absent,
  $disable             = $mysql_server::defaults::disable,
  $disboot             = $mysql_server::defaults::disboot,
  $audit_only          = $mysql_server::defaults::audit_only,
  $restart             = $mysql_server::defaults::restart,
  $version             = $mysql_server::defaults::version,
  $template            = $mysql_server::defaults::template,
  $source              = $mysql_server::defaults::source,
  $options             = $mysql_server::defaults::options,
  $my_class            = $mysql_server::defaults::my_class,
  $grant               = $mysql_server::defaults::grant,
  $root_pwd,
  ) inherits mysql_server::defaults {
  contain 'mysql_server::params'

  ## Input parameters validation
  validate_bool($absent)
  validate_bool($disable)
  validate_bool($disboot)
  validate_bool($audit_only)
  validate_bool($restart)
  if $options { validate_hash($options) }
  if $grant   { validate_hash($grant) }

  ## General parameters
  $system_date         = $mysql_server::params::system_date
  $install_reference   = $mysql_server::params::install_reference
  $service_reference   = $mysql_server::params::service_reference

  ## Package ralated parameters
  $package             = $mysql_server::params::package
  $package_ensure      = $mysql_server::params::package_ensure

  ## Configuration file ralated parameters
  $config_file         = $mysql_server::params::config_file
  $config_file_ensure  = $mysql_server::params::config_file_ensure
  $config_file_mode    = $mysql_server::params::config_file_mode
  $config_file_owner   = $mysql_server::params::config_file_owner
  $config_file_group   = $mysql_server::params::config_file_group
  $config_file_content = $mysql_server::params::config_file_content
  $config_file_source  = $mysql_server::params::config_file_source
  $config_file_audit   = $mysql_server::params::config_file_audit
  $config_file_replace = $mysql_server::params::config_file_replace

  ## Service ralated parameters
  $service             = $mysql_server::params::service
  $service_enable      = $mysql_server::params::service_enable
  $service_ensure      = $mysql_server::params::service_ensure
  $service_hasstatus   = $mysql_server::params::service_hasstatus
  $service_hasrestart  = $mysql_server::params::service_hasrestart
  $service_restart     = $mysql_server::params::service_restart
  $service_start       = $mysql_server::params::service_start
  $service_stop        = $mysql_server::params::service_stop
  $service_status      = $mysql_server::params::service_status

  ## Essential classes
  contain 'mysql_server::install'
  contain 'mysql_server::config'
  contain 'mysql_server::service'
  contain 'mysql_server::password'
  contain 'mysql_server::database'
  if $my_class {
    contain "${my_class}"
  }

  ## Relationship of classes
  Class['mysql_server::install'] -> Class['mysql_server::config'] -> Class['mysql_server::service'] -> Class['mysql_server::password'] -> Class['mysql_server::database']
}
