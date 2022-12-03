# The Windows profile should be applied to all Windows nodes
class profile::windows {
  ## test file - to demonstrate that Puppet is working
  file { 'c:/puppet-was-here.txt':
    ensure => 'file',
    group  => 'Administrators',
  }

  ## ensure time service is running - demonstration purposed mainly
  service { 'w32time':
    ensure => 'running',
  }

  # ## fix PS gallery
  # include profile::fix_psgallery

  ## patch managemenet
  include profile::patch_mgmt_win

  ## support for long file paths
  # check: get-itemproperty "HKLM:\System\CurrentControlSet\Control\FileSystem" -name longpathsenabled
  registry_value { 'HKLM\System\CurrentControlSet\Control\FileSystem\LongPathsEnabled':
    ensure   => 'present',
    data     => [1],
    provider => 'registry',
    type     => 'dword',
  }

  ## ensure PSGallery is present - relies on mod 'dsc-powershellget', '2.2.5-0-3'
  dsc_psrepository { 'Trust public gallery':
    dsc_name               => 'PSGallery',
    dsc_ensure             => 'Present',
    dsc_installationpolicy => trusted,
  }
}
