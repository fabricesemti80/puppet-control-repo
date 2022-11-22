# This role would be made of all the profiles that need to be included to make a database server work
# All roles should include the base profile
class role::database_server {
  include profile::base
  class { 'motd':
    content => "This is a Puppet-managed database server!\n",
  }

  $sourceloc = 'F:/'

# Install a SQL Server default instance
  sqlserver_instance { 'MSSQLSERVER':
    source                => $sourceloc,
    features              => ['SQLEngine'],
    sql_sysadmin_accounts => [$facts['identity']['user']],
    install_switches      => {
      'TCPENABLED'          => 1,
      'SQLBACKUPDIR'        => 'C:\\MSSQLSERVER\\backupdir',
      'SQLTEMPDBDIR'        => 'C:\\MSSQLSERVER\\tempdbdir',
      'INSTALLSQLDATADIR'   => 'C:\\MSSQLSERVER\\datadir',
      'INSTANCEDIR'         => 'C:\\Program Files\\Microsoft SQL Server',
      'INSTALLSHAREDDIR'    => 'C:\\Program Files\\Microsoft SQL Server',
      'INSTALLSHAREDWOWDIR' => 'C:\\Program Files (x86)\\Microsoft SQL Server',
    },
  }

# Resource to connect to the DB instance
  sqlserver::config { 'MSSQLSERVER':
    admin_login_type => 'WINDOWS_LOGIN',
  }

# Enforce SQL Server Administrators
  $local_dba_group_name = 'DB Administrators'
  $local_dba_group_netbios_name = "${facts['networking']['hostname']}\\DB Administrators"

  group { $local_dba_group_name:
    ensure => present,
  }

  -> sqlserver::login { $local_dba_group_netbios_name :
    login_type  => 'WINDOWS_LOGIN',
  }

  -> sqlserver::role { 'sysadmin':
    ensure   => 'present',
    instance => 'MSSQLSERVER',
    type     => 'SERVER',
    members  => [$local_dba_group_netbios_name, $facts['identity']['user']],
  }

# Enforce memory consumption
  sqlserver_tsql { 'check advanced sp_configure':
    command  => 'EXEC sp_configure \'show advanced option\', \'1\'; RECONFIGURE;',
    onlyif   => 'sp_configure @configname=\'max server memory (MB)\'',
    instance => 'MSSQLSERVER',
  }

  -> sqlserver::sp_configure { 'MSSQLSERVER-max memory':
    config_name => 'max server memory (MB)',
    instance    => 'MSSQLSERVER',
    reconfigure => true,
    restart     => true,
    value       => 2048,
  }

  # # install management studio
  # package { 'sql-server-management-studio':
  #   ensure   => '15.0.18424.0',
  #   provider => 'chocolatey',
  #   source   => 'https://community.chocolatey.org/api/v2/',
  # }
}
