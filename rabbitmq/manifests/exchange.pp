define rabbitmq::exchange (
  $user,
  $password,
  $type,
) {
  rabbitmq_exchange { $title:
    user     => $user,
    password => $password,
    type     => $type,
    ensure   => present,
  }
}
