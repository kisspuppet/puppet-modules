class rabbitmq::data {
  if $rabbitmq::instance {
    create_resources(rabbitmq::instance,$rabbitmq::instance)
  }

  if $rabbitmq::exchange {
    create_resources(rabbitmq::exchange,$rabbitmq::exchange)
  }
}
