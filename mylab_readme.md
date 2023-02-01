# Lab setup

## Servers

The servers are on the first few IP-s of the `10.0.2.0/24` subnet
The netmask is `255.255.0.0` (`/16`)
The gateway is `10.0.0.1`
The DNS servers currently are `10.0.2.1` (testlab dc) and `10.0.0.3` (pihole)

Servers should join to the `fabricesemti.net` domain.

## Install Puppet agent

Run the agent installer

> this can take a while, so check the log file if in doubt...

```powershell
Add-Content -Path C:\windows\System32\drivers\etc\hosts "10.0.2.10 puppet-master-ubuntu.fabrice.lan"

$puppet_master_host="puppet-master-ubuntu" # replace me with primary server's hostname (must be DNS-reachable)
$puppet_master_ip="10.0.2.10"       # replace me with the primary server's IP
$hostname = $env:computerName

# fix /etc/hosts if required
$puppet_master_resolved = $false
try {
  $puppet_master_resolved = ([system.net.dns]::gethostbyName($puppet_master_host) )
} catch {}
if ($puppet_master_resolved -and $puppet_master_resolved.AddressList[0].IPAddressToString -eq $puppet_master_ip ) {
  "puppet host already resolves OK"
} else {
  # add a hosts entry for puppetmaster
  ac -Path "C:\WINDOWS\system32\drivers\etc\hosts" -Value ("`r`n" + $puppet_master_ip + "   " + $puppet_master_host + "`r`n")
}

"Proceeding to install puppet..."
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFile('https://' + $puppet_master_ip + ':8140/packages/current/install.ps1', 'install.ps1'); .\install.ps1 custom_attributes:challengePassword=$shared_secret extension_requests:pp_role=$puppet_role -WarningAction SilentlyContinue
```

## Activate Puppet

Visit the Puppet console and accept the cert request from a new node.

Then run the agent on the new node using:

```powershell
puppet agent -t
```