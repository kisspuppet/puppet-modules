class mysql_server::install {
  ## Managed package
  if $mysql_server::package {
    package { 'mysql_server':
      name   => $mysql_server::package,
      ensure => $mysql_server::package_ensure,
    }
  }
}
