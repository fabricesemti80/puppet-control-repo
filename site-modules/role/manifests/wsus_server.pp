# This role would be made of all the profiles that need to be included to make a webserver work
# All roles should include the base profile
class role::wsus_server {
  include profile::base

  # set login message
  class { 'motd':
    content => "This is a Puppet-managed WSUS server!\n",
  }

  # -- wsus code goes here --
}
