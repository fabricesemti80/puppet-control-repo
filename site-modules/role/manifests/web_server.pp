# This role would be made of all the profiles that need to be included to make a webserver work
# All roles should include the base profile
class role::web_server {
  include profile::base

  # set login message
  # check: Get-ItemProperty "hklm:\software\microsoft\windows\currentversion\policies\system" -Name legalnotice*
  class { 'motd':
    content => "This is a Puppet-managed webserver!\n",
  }

  # install IIS
  $iis_features = ['Web-WebServer','Web-Scripting-Tools','Web-Mgmt-Console']

  iis_feature { $iis_features:
    ensure => 'present',
  }

  # Delete the default website to prevent a port binding conflict.
  iis_site { 'Default Web Site':
    ensure  => absent,
    require => Iis_feature['Web-WebServer'],
  }

  # create website
  iis_site { 'minimal':
    ensure          => 'started',
    physicalpath    => 'c:\\inetpub\\minimal',
    applicationpool => 'DefaultAppPool',
    require         => [
      File['minimal'],
      Iis_site['Default Web Site']
    ],
  }

  # create website folder
  file { 'minimal':
    ensure => 'directory',
    path   => 'c:\\inetpub\\minimal',
  }
}
