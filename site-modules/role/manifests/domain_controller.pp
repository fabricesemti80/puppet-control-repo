# This role would be made of all the profiles that need to be included to make a webserver work
# All roles should include the base profile
class role::domain_controller {
  include profile::base

  # set login message
  # check: Get-ItemProperty "hklm:\software\microsoft\windows\currentversion\policies\system" -Name legalnotice*
  class { 'motd':
    content => "This is a Puppet-managed domain controller!\n",
  }

  # -- dc code goes here --
}
