class roles::mq {
  include profiles::base
  include profiles::agent
  include profiles::rmq

  Class['profiles::base'] -> Class['profiles::rmq'] -> Class['profiles::agent']
}
