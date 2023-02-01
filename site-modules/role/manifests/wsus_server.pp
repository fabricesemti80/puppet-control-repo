# This role would be made of all the profiles that need to be included to make a webserver work
# All roles should include the base profile
class role::wsus_server {
  include profile::base

  # set login message
  # check: Get-ItemProperty "hklm:\software\microsoft\windows\currentversion\policies\system" -Name legalnotice*
  class { 'motd':
    content => "This is a Puppet-managed WSUS server!\n",
  }

  ## -- wsus code goes here -->
  class { 'wsusserver':
    package_ensure                     => 'present',
    include_management_console         => true,
    service_manage                     => true,
    service_ensure                     => 'running',
    service_enable                     => true,
    wsus_directory                     => 'C:\\WSUS',
    join_improvement_program           => false,
    sync_from_microsoft_update         => true,
    update_languages                   => ['en'],
    products                           => [
      'Windows Server 2012 R2',
      'Windows Server 2016'
    ],
    product_families                   => [
    ],
    update_classifications             => [
      'Update Rollups',
      'Security Updates',
      'Critical Updates',
      'Service Packs',
      'Updates'
    ],
    targeting_mode                     => 'Client',
    host_binaries_on_microsoft_update  => true,
    synchronize_automatically          => true,
    synchronize_time_of_day            => '03:00:00', # 3AM ( UTC ) 24H Clock
    number_of_synchronizations_per_day => 1,
  }

  wsusserver_computer_target_group { 'AutoApproval':
    ensure => 'present',
  }

  wsusserver::approvalrule { 'Automatic Approval for all Updates Rule':
    ensure          => 'present',
    enabled         => true,
    classifications => [
      'Update Rollups',
      'Security Updates',
      'Critical Updates',
      'Updates'
    ],
    products        => [
      'Windows Server 2012 R2',
      'Windows Server 2016'
    ],
    computer_groups => ['AutoApproval'],
  }

  # Set 'restart_private_memory_limit' on the IIS WsusPool to largest value for stability
  iis_application_pool { 'WsusPool':
    ensure                       => 'present',
    state                        => 'started',
    managed_pipeline_mode        => 'Integrated',
    managed_runtime_version      => 'v4.0',
    enable32_bit_app_on_win64    => false,
    restart_private_memory_limit => 4294967,
    restart_schedule             => ['07:00:00', '15:00:00', '23:00:00']
  }

  ## <-- wsus code goes here --

  ## WSUS needs IIS
  # $iis_features = ['Web-Server','Web-WebServer','Web-Asp-Net45','Web-ISAPI-Ext','Web-ISAPI-Filter','NET-Framework-45-ASPNET','WAS-NET-Environment','Web-Http-Redirect','Web-Filtering','Web-Mgmt-Console','Web-Mgmt-Tools']
  $iis_features =['UpdateServices','Web-WebServer','Web-Scripting-Tools','Web-Mgmt-Console']
  windowsfeature { $iis_features:
    ensure => present,
  }

}

## https://github.com/dsccommunity/UpdateServicesDsc/blob/main/examples/dsc_configuration.ps1
#     {
#         # Install the IIS role
#         WindowsFeature UpdateServices
#         {
#             Ensure = 'Present'
#             Name = 'UpdateServices'
#         }

#         WindowsFeature UpdateServicesRSAT
#         {
#             Ensure = 'Present'
#             Name = 'UpdateServices-RSAT'
#             IncludeAllSubFeature =  $True
#         }
#         UpdateServicesServer 'UpdateServices'
#         {
#             DependsOn = @(
#                 '[WindowsFeature]UpdateServices'
#             )
#             Ensure = 'Present'
#             ContentDir = 'C:\WSUS'
#             Languages = @('en','fr')
#             Classifications = @(
#                 'E6CF1350-C01B-414D-A61F-263D14D133B4', #CriticalUpdates
#                 'E0789628-CE08-4437-BE74-2495B842F43B', #DefinitionUpdates
#                 '0FA1201D-4330-4FA8-8AE9-B877473B6441', #SecurityUpdates
#                 '68C5B0A3-D1A6-4553-AE49-01D3A7827828', #ServicePacks
#                 '28BC880E-0592-4CBF-8F95-C79B17911D5F' #UpdateRollUps
#             )
#             SynchronizeAutomatically = $true
#             SynchronizeAutomaticallyTimeOfDay = '15:30:00'
#             ClientTargetingMode = "Client"
#         }
#     }
