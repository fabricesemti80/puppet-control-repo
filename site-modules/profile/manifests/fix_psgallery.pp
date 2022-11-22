# This role corrects tls 1.2 errors
class profile::fix_psgallery {
  registry_value {
    default:
      ensure => present,
      type   => 'dword',
      ;
    'Enable TLS 1.2 for all 64-bit .NET 4 applications':
      path   => 'HKLM\SOFTWARE\Microsoft\.NetFramework\v4.0.30319\SchUseStrongCrypto',
      data   => 1,
      before => [
        Class['chocolatey'],
        Chocolateysource['chocolatey'],
        Chocolateysource['internal'],
        Pspackageprovider['Nuget'],
        Psrepository['PSGallery']
      ]
      ;
    'Enable TLS 1.2 for all 32-bit .NET 4 applications':
      path   => 'HKLM\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319\SchUseStrongCrypto',
      data   => 1,
      before => [
        Class['chocolatey'],
        Chocolateysource['chocolatey'],
        Chocolateysource['internal'],
        Pspackageprovider['Nuget'],
        Psrepository['PSGallery']
      ],
  }
}
