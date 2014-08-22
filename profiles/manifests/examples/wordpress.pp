class profiles::wordpress (
  $wordpress_db_user="sohl",
  $wordpress_db_pwd="slssl",
  $wordpress_db_name="slslf",
) {
  class {'mysql':
    rootpwd => "how021398",
    grant   => {
      "${wordpress_db_name}" => {
        user     => $wordpress_db_user,
        password => $wordpress_db_pwd,
      },
    },
  }

  class {'php':
    enmod => ['gd','xml','mysql'],
  }

  class {'apache':
    confdir => {
      'wordpress.conf' => {
        source => "puppet:///modules/apache/wordpress.conf",
      },
    },
    options => {
      db_user => $wordpress_db_user,
      db_pwd  => $wordpress_db_pwd,
      db_name => $wordpress_db_name,
    },
    datadir => {
      'wordpress' => {
        ensure => directory,
        source => "puppet:///modules/apache/wordpress",
      },
      'wordpress/wp-config.php' => {
        template => "apache/wp-config.php.erb",
      },
    },
  }

  contain 'mysql'
  contain 'php'
  contain 'apache'

  Class['mysql'] -> Class['php'] -> Class['apache']
}
