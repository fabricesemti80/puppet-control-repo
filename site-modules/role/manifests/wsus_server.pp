# This role would be made of all the profiles that need to be included to make a webserver work
# All roles should include the base profile
class role::wsus_server {
  include profile::base

  # set login message
  # check: Get-ItemProperty "hklm:\software\microsoft\windows\currentversion\policies\system" -Name legalnotice*
  class { 'motd':
    content => "This is a Puppet-managed WSUS server!\n",
  }

  # -- wsus code goes here --
  #? https://github.com/TraGicCode/tragiccode-wsusserver/tree/bbd5e58ed61d40625bf5f50ef7701bc0f4b53338
  class { 'wsusserver':
    package_ensure         => 'present',
    update_languages       => ['en'],
    products               => [
      'Active Directory Rights Management Services Client 2.0',
      'ASP.NET Web Frameworks',
      'Microsoft SQL Server 2012',
      'SQL Server Feature Pack',
      'SQL Server 2012 Product Updates for Setup',
      'Windows Server 2016',
    ],
    update_classifications => [
      'Critical Updates',
      'Security Updates',
      'Updates',
    ],
  }
}
