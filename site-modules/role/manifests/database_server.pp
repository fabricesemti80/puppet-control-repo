# This role would be made of all the profiles that need to be included to make a database server work
# All roles should include the base profile
class role::database_server {
  include profile::base
  include profile::sqlserver_install
  class { 'motd':
    content => "This is a Puppet-managed database server!\n",
  }

  # install management studio
  package { 'sql-server-management-studio':
    ensure   => '15.0.18424.0',
    provider => 'chocolatey',
    source   => 'https://chocolatey.org/packages',
  }
}
