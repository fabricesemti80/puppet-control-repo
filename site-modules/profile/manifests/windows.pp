# The Windows profile should be applied to all Windows nodes
class profile::windows {
  file { 'c:/puppet-was-here.txt':
    ensure => 'file',
    group  => 'Administrators',
  }
  service { 'w32time':
    ensure => 'running',
  }
  # include profile::fix_psgallery
}
