class profiles::base {
  # Data lookups
  $hosts        = hiera('profiles::base::hosts')
  $repos        = hiera('profiles::base::repos')
  $ntp_server   = hiera('profiles::base::ntp_server')

  class hosts {
    create_resources(host,$profiles::base::hosts)
  }

  class repos {
    Yumrepo {
      enabled => 1,
      gpgcheck => 0,
      mirrorlist => absent,
    }
    create_resources(yumrepo,$profiles::base::repos)
  }

  class { 'ntp':
    options => {
      servers => $ntp_server,
    },
    template => "profiles/base/ntp/ntp.conf.erb",
  }

  contain 'public'
  contain 'profiles::base::hosts'
  contain 'profiles::base::repos'
  contain 'ntp'

  Class['public'] -> Class['profiles::base::hosts'] -> Class['profiles::base::repos'] -> Class['ntp']
}
