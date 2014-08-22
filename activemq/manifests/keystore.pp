class activemq::keystore {
  $keystore_password = $activemq::keystore_password

  # User must put these files in the module, or provide other URLs
  $ca = '/var/lib/puppet/ssl/certs/ca.pem'
  $cert = "/var/lib/puppet/ssl/certs/${::clientcert}.pem"
  $private_key = "/var/lib/puppet/ssl/private_keys/${::clientcert}.pem"

  $activemq_user = 'activemq'

  # ----- Manage Keystore Contents -----

  # Each keystore should have a dependency on the PEM files it relies on.

  # Truststore with copy of CA cert
  java_ks { 'activemq_ca:truststore':
    ensure       => latest,
    certificate  => "$ca",
    target       => "${activemq::config_dir}/truststore.jks",
    password     => $keystore_password,
    trustcacerts => true,
    notify       => $activemq::service_reference,
  }

  # Keystore with ActiveMQ cert and private key
  java_ks { 'activemq_cert:keystore':
    ensure      => latest,
    certificate => "$cert",
    private_key => "$private_key",
    target      => "${activemq::config_dir}/keystore.jks",
    password    => $keystore_password,
    notify      => $activemq::service_reference,
  }


  # ----- Manage Keystore Files -----

  # Permissions only.
  # No ensure, source, or content.

  file {"${activemq::config_dir}/keystore.jks":
    owner   => $activemq_user,
    group   => $activemq_user,
    mode    => 0600,
    require => Java_ks['activemq_cert:keystore'],
  }
  file {"${activemq::config_dir}/truststore.jks":
    owner   => $activemq_user,
    group   => $activemq_user,
    mode    => 0600,
    require => Java_ks['activemq_ca:truststore'],
  }
}
