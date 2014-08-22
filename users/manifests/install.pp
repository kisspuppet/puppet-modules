class users::install {
  ## Managed package
  if $users::package {
    package { 'users':
      name   => $users::package,
      ensure => $users::package_ensure,
    }
  }
}
