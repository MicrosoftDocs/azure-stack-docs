---
title: Use diagnostic checker to identify common causes for failures (preview)
description: Learn how to diagnose common causes for failures 
author: sethmanheim
ms.author: sethm
ms.date: 06/17/2024
ms.reviewer: abha

#Customer intent: As an AKS user, I want to use the diagnostic checker to run diagnostic checks on my AKS cluster to find out common causes for AKS cluster create failure. 

---

# Use diagnostic checker to diagnose and fix environment issues for AKS cluster create failure (preview)

It can be hard to identify environment related issues like networking configurations that can result in an AKS cluster create failure. Diagnostic checker is a PowerShell based tool that can help identify potential causes in the environment due to which your AKS cluster create failed. 

## Before you begin

Before you begin, make sure you have the following. If you do not meet the requirements for running the diagnostic checker tool, proceed directly to [filing a support request](/aks-troubleshoot#open-a-support-request).

- Direct access to the Azure Stack HCI cluster where you created the AKS cluster. This can be through remote desktop (RDP), or you can also login to one of the Azure Stack HCI physical nodes.
- Review [networking concepts for creating an AKS cluster](/aks-hci-network-system-requirements) and [AKS cluster architecture](/cluster-architecture).
- The name of the logical network attached to the AKS cluster. 
- SSH private key for the AKS cluster, used to login to the AKS cluster [control plane node](/cluster-architecture#control-plane-nodes) VM.

## Obtain control plane node VM IP of the AKS cluster

Run the following command from any one physical node in your Azure Stack HCI cluster. Ensure that you're passing the name, and not ARM ID of the AKS cluster in the below commands.
```powershell
$cluster_name="<name of the AKS cluster>"
Get-VM | Where-Object {$_.Name -like "$cluster_name*control-plane-*"} | Select-Object -ExpandProperty NetworkAdapters | Select-Object VMName, IPAddresses | Format-Table -AutoSize
```

Expected output:
```ouput
VMName                                                 IPAddresses
------                                                 -----------
<cluster-name>-XXXXXX-control-plane-XXXXXX {172.16.0.10, 172.16.0.4, fe80::ec:d3ff:fea0:1}
```

If your AKS cluster has
- 0 IPv4 addreeses: File a [support request](/aks-troubleshoot#open-a-support-request).
- 1 IP address: Use the IPv4 address as the input for `vmIP` parameter.
- 2 IP addresses: Use any one of the IPv4 address as an input for `vmIP` parameter in the diagnostic checker.

## Run the diagnostic checker script

Copy the following PowerShell script `run_diagnostic.ps1` into any 1 node of your Azure Stack HCI cluster.
```powershell
<#
.SYNOPSIS
    Runs diagnostic checker tool in target cluster control plane VM and returns the result.

    This script will run the following tests from target cluster control plane VM:
    1. cloud-agent-connectivity-test: Checks whether the DNS server can resolve the Moc cloud agent FQDN and that the cloud agent is reachable from the control plane node VM. Cloud agent is created using one of the IP addresses from the management IP pool, on port 55000. The control plane node VM is given an IP address from the Arc VM logical network.
    2. gateway-icmp-ping-test: Checks whether the gateway specified in the logical network attached to the AKS cluster is reachable from the AKS cluster control plane node VM.
    3. http-connectivity-required-url-test: Checks whether the required URLs are reachable from the AKS cluster control plane node VM.

.DESCRIPTION
    This script transfers a file from the local machine to a remote server using the SCP (Secure Copy Protocol) command.

.PARAMETER lnetName
    The name of the LNET used for the cluster.

.PARAMETER sshPath
    The path to the private SSH key for the target cluster.

.PARAMETER vmIP
    IP of the target cluster control plane VM.


.EXAMPLE
    .\run_diagnostic.ps1 -lnetName lnet1 -sshPath C:\Users\test\.ssh\test-ssh.pem -vmIP "172.16.0.10"
    This example runs diagnostic checker tool in the VM with IP 172.16.0.10 using ssh key C:\Users\test\.ssh\test-ssh.pem and outputs the result.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$lnetName,

    [Parameter(Mandatory=$true)]
    [string]$sshPath,

    [Parameter(Mandatory=$true)]
    [string]$vmIP
)

$urlList="https://management.azure.com,https://eastus.dp.kubernetesconfiguration.azure.com,https://login.microsoftonline.com,https://eastus.login.microsoft.com,https://login.windows.net,https://mcr.microsoft.com,https://gbl.his.arc.azure.com,https://k8connecthelm.azureedge.net,https://guestnotificationservice.azure.com,https://sts.windows.net,https://k8sconnectcsp.azureedge.net,https://graph.microsoft.com/"

# retreiving LNET 
$lnet=get-mocvirtualnetwork -group Default_Group -name $lnetName
# getting gateway address from LNET
$gateway=$lnet.properties.subnets[0].properties.routeTable.properties.routes[0].properties.nextHopIpAddress
# getting DNS servers from LNET
#$dnsPort=":53"
#$dnsServers=$lnet.properties.dhcpOptions.dnsServers | ForEach-Object {$_.Trim() + $dnsPort}
#$dnsServer=$dnsServers -join ","

# getting cloudfqdn from archciconfig
$arcHCIConfig=get-archciconfig
$cloudFqdn="http://"+$arcHCIConfig.Item('cloudFQDN')+":55000" 

$configContent = @"
checks:
- metadata:
    creationTimestamp: null
    name: cloud-agent-connectivity-test
  parameters:
    hostnames: <CLOUD_FQDN>
    skipeof: "true"
  type: HTTPConnectivity
- metadata:
    annotations:
      skip-error-on-failure: "true"
    creationTimestamp: null
    name: gateway-icmp-ping-test
  parameters:
    ips: <GATEWAY>
    packetLossThreshold: "20"
  type: ICMPPing
- metadata:
    creationTimestamp: null
    name: http-connectivity-test-arc
  parameters:
    hostnames: <URL_LIST>
  type: HTTPConnectivity
exports:
- metadata:
    creationTimestamp: null
  parameters:
    filelocation: /home/clouduser/results.yaml
  type: FileSystem
metadata:
  creationTimestamp: null
"@

# update config file with the values of cloud fqdn, gateway and dns servers
$configContent = $configContent.replace("<CLOUD_FQDN>", $cloudFqdn)
$configContent = $configContent.replace("<GATEWAY>", $gateway)
#$configContent = $configContent.replace("<DNS_SERVER>", $dnsServer)
$configContent = $configContent.replace("<URL_LIST>", $urlList)

$filePath = "config.yaml"
# Write to config.yaml
Set-Content -Path $filePath -Value $configContent

$dest = 'clouduser@' + $vmIP + ":config.yaml"
# Copy the config file to target cluster VM
Write-Host "Copying test config file to target cluster VM...."
$command = "scp -i $sshPath config.yaml $dest"
$output=Invoke-Expression $command 2>&1
if ($LASTEXITCODE -eq 1) {
    Write-Error "Couldn't connect to target cluster control plane VM $vmIP. Please check the ssh key and make sure target cluster control plane VM is reachable from the host"
    exit
}
Write-Output "Copied config.yaml successfully."
#sudo su - root -c "rm /home/clouduser/results.yaml"
$runScriptContent = @"
sudo su - root -c "/usr/bin/diagnostics-checker -c /home/clouduser/config.yaml"
"@

$filePath = "run_diag.sh"

Set-Content -Path $filePath -Value $runScriptContent
$dest = 'clouduser@' + $vmIP + ":run_diag.sh"
scp -i $sshPath run_diag.sh $dest

$dest = 'clouduser@' + $vmIP
ssh -i $sshPath $dest 'chmod +x run_diag.sh'

$sedCommand="sed -i -e 's/\r$//' run_diag.sh"
ssh -i $sshPath $dest $sedCommand

if (Test-Path -Path "results.yaml") {
  Remove-Item results.yaml
}

ssh -i $sshPath $dest './run_diag.sh'
ssh -i $sshPath $dest "sudo su - root -c 'chmod a+r /home/clouduser/results.yaml'"

$src= 'clouduser@' + $vmIP + ":results.yaml"
scp -i $sshPath $src results.yaml

$resultContent = Get-Content -path results.yaml
Write-Output $resultContent
```

Next, run the copied PowerShell script with the following input parameters from the same physical node:  
```
.\run_diagnostic.ps1 -lnetName <name of the logical network attached to the AKS cluster> -sshPath <SSH private key> -vmIP <AKS cluster control plane IP>
```

This example runs diagnostic checker tool inside the AKS control plane VM with control plane IP `172.16.0.10` using SSH private key `C:\Users\test\.ssh\test-ssh.pem` and logical network `aks-lnet-1` and outputs the result. Make sure you replace the example below with your AKS cluster specific values.
```powershell
.\run_diagnostic.ps1 -lnetName aks-lnet-1 -sshPath C:\Users\test\.ssh\test-ssh.pem -vmIP "172.16.0.10"
```

### Error: 

## Analyzing diagnostic checker output

The table below provides a summary of each test performed by the script, including possible causes for failure and recommendations for mitigation. We will keep building and refining the following tests in upcoming releases.

| **Test Name**                        | **Description**                                                                 | **Causes for failure**                                                                                      | **Mitigation Recommendations**                                                                                                                                     |
|--------------------------------------|---------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| cloud-agent-connectivity-test        | Checks whether the DNS server can resolve the Moc cloud agent FQDN and that the cloud agent is reachable from the control plane node VM. Cloud agent is created using one of the IP addresses from the [management IP pool](/hci/plan/cloud-deployment-network-considerations#management-ip-pool), on port 55000. The control plane node VM is given IP address(es) from the Arc VM logical network. | Logical network IP addresses cannot connect to management IP pool addresses due to: <br> - Incorrect DNS server resolution. <br> - Firewall rules <br> - The logical network is in a different vlan than the manageement IP pool and there is no cross-vlan connectivity. | Make sure that the logical network IP addresses can connect to all the management IP pool addresses on the required ports. Check [AKS network port and cross vlan requirements](/aks-hci-network-system-requirements#network-port-and-cross-vlan-requirements) for detailed list of ports that need to be opened. |    
| gateway-icmp-ping-test   | Checks whether the gateway specified in the logical network attached to the AKS cluster is reachable from the AKS cluster control plane node VM. | - Gateway is down or unreachable <br>- Network routing issues between AKS cluster control plane node VM and the gateway <br>- Firewall blocking ICMP traffic | - Ensure gateway is operational<br>- Verify routing configurations<br>- Adjust firewall rules to allow ICMP traffic                                              |
| http-connectivity-required-url-test  | Checks whether the required URLs are reachable from the AKS cluster control plane node VM.                         | - Control plane node VM has no outbound internet access <br> -Required URLs have not been allowed through firewall.                           | Ensure that the logical network IP addresses have outbound internet access. If there is a firewall, ensure that [AKS required URLs](/aks-hci-network-system-requirements#firewall-url-exceptions) are accessible from Arc VM logical network.  |

## Next steps

If the problem persists, collect [AKS cluster logs](get-on-demand-logs.md) before [creating a support request](aks-troubleshoot.md#open-a-support-request). 
