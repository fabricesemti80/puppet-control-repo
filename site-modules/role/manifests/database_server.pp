# This role would be made of all the profiles that need to be included to make a database server work
# All roles should include the base profile
class role::database_server {
  include profile::base
  class { 'motd':
    content => "This is a Puppet-managed database server!\n",
  }

  sqlserver_instance { 'MSSQLSERVER':
    features              => ['SQL'],
    source                => 'F:/',
    sql_sysadmin_accounts => ['myuser'],
  }

  # # install management studio
  # package { 'sql-server-management-studio':
  #   ensure   => '15.0.18424.0',
  #   provider => 'chocolatey',
  #   source   => 'https://community.chocolatey.org/api/v2/',
  # }
}
