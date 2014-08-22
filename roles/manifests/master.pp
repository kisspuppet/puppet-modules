class roles::master {
  include profiles::base
  include profiles::master

  Class['profiles::base'] -> Class['profiles::master']
}
