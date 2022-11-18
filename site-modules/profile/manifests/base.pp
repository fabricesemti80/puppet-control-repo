# The base profile should include component modules that will be on all nodes
class profile::base {
  class { 'motd':
    content => "Hello! You are in ${trusted['extensions']['pp_datacenter']}.\nWe are all puppets here!\n",
  }
}
