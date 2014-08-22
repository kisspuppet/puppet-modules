class roles::webui {
  include profiles::base
  include profiles::webui

  Class['profiles::base'] -> Class['profiles::webui']
}
