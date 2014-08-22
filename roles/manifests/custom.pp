class roles::custom {
  include profiles::base
  include profiles::agent

  Class['profiles::base'] -> Class['profiles::agent']
}
