node 'growell-katello-master.dev.cnwr.com' {
  include ::roles::common
  class { '::activemq': }
  class { '::mcollective':
    middleware_hosts => [ 'growell-katello-lab.dev.cnwr.com' ],
    core_libdir      => '/usr/libexec/mcollective',
    client           => true,
  }

  class { 'puppetdb::globals':
    version => '2.3.8-1.el7',
  }

  class { 'puppetdb::master::config':
    puppetdb_server             => 'growell-puppetdb.dev.cnwr.com',
    puppetdb_soft_write_failure => true,
  }

}

node 'growell-openstack-allinone.dev.cnwr.com' {
  include ::roles::common
  include ::openstack::role::allinone
}

node 'growell-puppetdb.dev.cnwr.com' {
  include ::roles::common
  class { '::mcollective':
    middleware_hosts => [ 'growell-katello-lab.dev.cnwr.com' ],
    core_libdir      => '/usr/libexec/mcollective',
    client           => true,
  }

  class { 'puppetdb::globals':
    version => '2.3.8-1.el7',
  }
  class { 'puppetdb::database::postgresql':
    listen_addresses => 'growell-puppetdb.dev.cnwr.com',
  }

  class { 'puppetdb::server':
    database_host  => 'growell-puppetdb.dev.cnwr.com',
    listen_address => '0.0.0.0',
  }
}
