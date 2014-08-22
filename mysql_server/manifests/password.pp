# Class: mysql_server::password
#
# Set mysql password
#
class mysql_server::password {

  # Load the variables used in this module. Check the params.pp file
  file { '/root/.my.cnf':
    ensure  => 'present',
    path    => '/root/.my.cnf',
    mode    => '0400',
    owner   => 'root',
    group   => 'root',
    content => template('mysql/root.my.cnf.erb'),
  }

  file { '/root/.my.cnf.backup':
    ensure  => 'present',
    path    => '/root/.my.cnf.backup',
    mode    => '0400',
    owner   => 'root',
    group   => 'root',
    content => template('mysql/root.my.cnf.backup.erb'),
    replace => false,
    before  => [ Exec['update_root_password'],
                 Exec['backup_root_password'] ],
  }

  exec { 'backup_root_password':
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    unless      => 'diff /root/.my.cnf /root/.my.cnf.backup',
    command     => 'cp /root/.my.cnf /root/.my.cnf.backup',
    before      => File['/root/.my.cnf'],
  }


  exec { 'update_root_password':
    subscribe   => File['/root/.my.cnf'],
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
    command     => "mysqladmin --defaults-file=/root/.my.cnf.backup -uroot password '${mysql_server::root_pwd}'",
  }

}
