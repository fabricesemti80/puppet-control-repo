# The base profile should include component modules that will be on all nodes
class profile::base {
  class { 'motd':
    content => "We are all puppets here!\n",
  }
}
