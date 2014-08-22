class public::config{
  file { '/etc/facter' :
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  file { '/etc/facter/facts.d' :
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/facter']
  }
  file{ "/etc/facter/facts.d/${::clientcert}.txt":
    owner   => "root",
    group   => "root",
    mode    => 0400,
    content => template('public/hostgroup.erb'),
    require => File['/etc/facter/facts.d'],
  }
}
