# This role would be made of all the profiles that need to be included to make a database server work
class profile::sqlserver_install (
  $instance_name = 'MSSQLSERVER',
  $windows_user = 'dbuser',
  $sapwd = 'sapassword123$',
  $windows_pwd = 'winpassword123$',
  $source_letter = 'F:/',
) {
  user { 'windows_user':
    ensure     => present,
    name       => $windows_user,
    groups     => ['Users','Administrators'],
    password   => $windows_pwd,
    managehome => true,
  }
  sqlserver_instance { $instance_name:
    source                 => $source_letter,
    security_mode          => 'SQL',
    sa_pwd                 => $sapwd,
    features               => ['SQL'],
    sql_sysadmin_accounts  => [$windows_user],
    windows_feature_source => 'C:\Windows\WinSxS',
    install_switches       => {
      'TCPENABLED'          => 1,
      'SQLBACKUPDIR'        => 'C:\\MSSQLSERVER\\backupdir',
      'SQLTEMPDBDIR'        => 'C:\\MSSQLSERVER\\tempdbdir',
      'INSTALLSQLDATADIR'   => 'C:\\MSSQLSERVER\\datadir',
      'INSTANCEDIR'         => 'C:\\Program Files\\Microsoft SQL Server',
      'INSTALLSHAREDDIR'    => 'C:\\Program Files\\Microsoft SQL Server',
      'INSTALLSHAREDWOWDIR' => 'C:\\Program Files (x86)\\Microsoft SQL Server',
    },
  }
  sqlserver_features { 'Generic Features':
    source   => $source_letter,
    features => ['SSMS'],
  }
}
