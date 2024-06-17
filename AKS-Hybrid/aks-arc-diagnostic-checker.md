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

Run the following command from any one physical node in your Azure Stack HCI cluster:
```powershell
> $cluster_name="<name of the cluster>"
> Get-VM | Where-Object {$_.Name -like "$cluster_name*control-plane-*"} | Select-Object -ExpandProperty NetworkAdapters | Select-Object VMName, IPAddresses | Format-Table -AutoSize
```

Expected output:
```ouput
VMName                                                 IPAddresses
------                                                 -----------
<cluster-name>-XXXXXX-control-plane-XXXXXX {172.16.0.10, 172.16.0.4, fe80::ec:d3ff:fea0:1}
```

If your AKS control plane node VM has 2 IPv4 addresses, use any one of the IPs as an input for `vmIP` parameter in the diagnostic checker.

## Run the diagnostic checker script

Once you've collected the above, login or RDP into one of the physical nodes in the Azure Stack HCI cluster and execute the PowerShell script. 
```
.\run_diagnostic.ps1 -lnetName <name of the logical network attached to the AKS cluster> -sshPath <SSH private key> -vmIP <AKS cluster control plane IP>
```

This example runs diagnostic checker tool inside the AKS control plane VM with control plane IP `172.16.0.10` using SSH private key `C:\Users\test\.ssh\test-ssh.pem` and logical network `aks-lnet-1` and outputs the result. Make sure you replace the example below with your AKS cluster specific values.
```powershell
.\run_diagnostic.ps1 -lnetName aks-lnet-1 -sshPath C:\Users\test\.ssh\test-ssh.pem -vmIP "172.16.0.10"
```

### Error: 



## Analyzing diagnostic checker output

The table below provides a concise summary of each test performed by the script, including possible causes for failure and recommendations for mitigation. In later releases, we will keep building and refining the following tests.

| **Test Name**                        | **Description**                                                                 | **Causes for failure**                                                                                      | **Mitigation Recommendations**                                                                                                                                     |
|--------------------------------------|---------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| cloud-agent-connectivity-test        | Checks whether the DNS server can resolve the Moc cloud agent FQDN and that the cloud agent is reachable from the logical network used for the AKS cluster creation. Cloud agent is created using one of the IP addresses from the [management IP pool](/hci/plan/cloud-deployment-network-considerations#management-ip-pool), on port 55000. This check performs a connectivity test from inside control plane VM (thats given an IP address from the Arc VM logical network) to the cloud agent FQDN. | Logical network IP addresses cannot connect to management IP pool addresses due to: <br> - Incorrect DNS server resolution. <br> - Firewall rules <br> - The logical network is in a different vlan than the manageement IP pool and there is no cross-vlan connectivity. | Make sure that the logical network IP addresses can connect to all the management IP pool addresses on the required ports. Check [AKS network port and cross vlan requirements](/aks-hci-network-system-requirements#network-port-and-cross-vlan-requirements) for detailed list of ports that need to be opened. |    
| gateway-icmp-ping-test   | Checks whether the gateway specified in the logical network attached to the AKS cluster is reachable from the AKS cluster control plane node VM. | - Gateway is down or unreachable <br>- Network routing issues between AKS cluster control plane node VM and the gateway <br>- Firewall blocking ICMP traffic | - Ensure gateway is operational<br>- Verify routing configurations<br>- Adjust firewall rules to allow ICMP traffic                                              |
| http-connectivity-required-url-test  | Checks whether the required URLs are reachable from the AKS cluster control plane node VM.                         | - Control plane node VM has no outbound internet access <br> -Required URLs have not been allowed through firewall.                           | Ensure that the logical network IP addresses have outbound internet access. If there is a firewall, ensure that [AKS required URLs](/aks-hci-network-system-requirements#firewall-url-exceptions) are accessible from Arc VM logical network.  |

## Next steps

If the problem persists, collect [AKS cluster logs](get-on-demand-logs.md) before [creating a support request](aks-troubleshoot.md#open-a-support-request). 
