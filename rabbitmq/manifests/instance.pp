define rabbitmq::instance (
  $user,
  $password,
  $vhost,
  $admin = false,
) {
  rabbitmq_user { $user:
    admin    => $admin,
    password => $password,
    provider => 'rabbitmqctl',
  }

  if (!defined(Rabbitmq_vhost["${vhost}"])) {
    rabbitmq_vhost { $vhost:
      ensure => present,
    }
  }

  rabbitmq_user_permissions { "${user}@${vhost}":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }
}
