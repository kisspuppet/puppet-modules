# Define mysql_server::grant
#
# This define adds a grant to the MySQL server. It creates a file with the
# grant statement and then applies it.
#
# Supported arguments:
# $db_name                   - The database to apply the grant to.
#                             If not set, defaults to == $title
#                             It supports SQL wildcards (%), ie: 'somedatab%'.
#                             The special value '*' means 'ALL DATABASES'
# $user                     - User to grant the permissions to.
# $password                 - Plaintext password for the user.
# $privs                    - Privileges to grant to the user.
#                             Defaults to 'ALL'
# $host                     - Host where the user can connect from. Accepts SQL wildcards.
#                             Default: 'localhost'
define mysql_server::grant (
  $user,
  $password          = undef,
  $db_name           = $title,
  $option            = '',
  $privs             = 'ALL',
  $host              = 'localhost',
  ) {
  $grant_db_user     = $user
  $grant_db_password = $password
  $grant_db_option   = $option
  $grant_db_privs    = $privs
  $grant_db_host     = $host

  $grant_db_name     = $db_name ? {
    /^(\*|%)$/ => '*',
    default    => $db_name,
  }

  # If dbname has a wildcard, we don't want to create anything
  $grant_db_create = $grant_db_realname ? {
    /(\*|%)/ => false,
    default  => true,
  }

  $grant_file_path = '/root/puppet-mysql'

  $grant_file = $grant_db_realname ? {
    /^(\*|%)$/ => "mysqlgrant-${grant_db_user}-${grant_db_host}-all.sql",
    default    => "mysqlgrant-${grant_db_user}-${grant_db_host}-${grant_db_name}.sql",
  }

  if (!defined(File["${grant_file_path}"])) {
    file { "${grant_file_path}":
      ensure => directory,
      path   => "${grant_file_path}",
      owner  => root,
      group  => root,
      mode   => '0700',
    }
  }

  file { $grant_file:
    ensure   => present,
    mode     => '0600',
    owner    => root,
    group    => root,
    path     => "${grant_file_path}/${grant_file}",
    content  => template('mysql/grant.erb'),
  }

  $grant_exec_command = "mysql --defaults-file=/root/.my.cnf -uroot < ${grant_file_path}/${grant_file}"

  exec { "mysqlgrant-${grant_db_user}-${grant_db_host}-${grant_db_name}":
    command     => $exec_command,
    subscribe   => File[$grant_file],
    path        => [ '/usr/bin' , '/usr/sbin' ],
    refreshonly => true,
  }
}
