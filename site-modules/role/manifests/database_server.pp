# This role would be made of all the profiles that need to be included to make a database server work
# All roles should include the base profile
class role::database_server {
  (
    $instance_name = 'MSSQLSERVER',
    $windows_user = $facts['cmp_database_user'],
    $sapwd = $facts['cmp_db_password'],
    $windows_pwd = $facts['cmp_db_password'],
    $source_letter = 'Z:/',
  )
  include profile::base
  include profile::sqlserver_installation
  class { 'motd':
    content => "This is a Puppet-managed database server!\n",
  }

  # # install management studio
  # package { 'sql-server-management-studio':
  #   ensure   => '15.0.18424.0',
  #   provider => 'chocolatey',
  #   source   => 'https://chocolatey.org/packages',
  # }
}
