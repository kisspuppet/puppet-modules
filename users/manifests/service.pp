class users::service {
  ## Managed service
  if $users::service {
    service { 'users':
      name      => $users::service,
      ensure    => $users::service_ensure,
      enable    => $users::service_enable,
      hasstatus => $users::service_status,
    }
  }
}
