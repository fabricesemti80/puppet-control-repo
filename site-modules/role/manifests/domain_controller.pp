# This role would be made of all the profiles that need to be included to make a webserver work
# All roles should include the base profile
class role::domain_controller {
  class { 'motd':
    content => "This is a Puppet-managed domain controller!\n",
  }
}
