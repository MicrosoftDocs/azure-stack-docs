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
- [Control plane IP](/aks-hci-network-system-requirements#control-plane-ip) of the AKS cluster.


## Run the diagnostic checker script

Once you've collected the above, login or RDP into one of the physical nodes in the Azure Stack HCI cluster and execute the PowerShell script. 
```
.\run_diagnostic.ps1 -lnetName <name of the logical network attached to the AKS cluster> -sshPath <SSH private key> -vmIP <AKS cluster control plane IP>
```

This example runs diagnostic checker tool inside the AKS control plane VM with control plane IP `172.16.0.10` using SSH private key `C:\Users\test\.ssh\test-ssh.pem` and logical network `aks-lnet-1` and outputs the result. Make sure you replace the example below with your AKS cluster specific values.
```powershell
.\run_diagnostic.ps1 -lnetName aks-lnet-1 -sshPath C:\Users\test\.ssh\test-ssh.pem -vmIP "172.16.0.10"
```

## Analyzing diagnostic checker output

Use the table below to analyze the output of the diagnostic checker.

Sure, here is a table summarizing the checks performed by the script:

| **Test Name**                        | **Description**                                                                 | **Causes for Failure**                                                                                      | **Mitigation Recommendations**                                                                                                                                     |
|--------------------------------------|---------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| dns-servers-udp-connectivity-test    | Checks whether DNS servers specified in the LNET are reachable from the target cluster control plane VM.       | - DNS server is down or unreachable<br>- Network configuration issues<br>- Firewall blocking UDP traffic     | - Ensure DNS servers are operational<br>- Verify network configurations<br>- Adjust firewall rules to allow UDP traffic on port 53                               |
| cloud-agent-connectivity-test        | Checks whether the DNS server can resolve the MOC Cloud agent FQDN and is reachable from the target VM.         | - DNS resolution issues<br>- Cloud agent FQDN is incorrect or down<br>- Network issues                        | - Verify DNS server settings<br>- Check and correct Cloud agent FQDN<br>- Resolve network connectivity issues                                                   |
| gateway-icmp-ping-test               | Checks whether the next hop IP address specified in the LNET is reachable from the target cluster control plane VM. | - Gateway is down or unreachable<br>- Network routing issues<br>- Firewall blocking ICMP traffic              | - Ensure gateway is operational<br>- Verify routing configurations<br>- Adjust firewall rules to allow ICMP traffic                                              |
| http-connectivity-required-url-test  | Checks whether required URLs are reachable from the target cluster control plane VM.                            | - URLs are down or incorrect<br>- Network issues<br>- Firewall blocking HTTP traffic                           | - Verify the availability of required URLs<br>- Check and correct URL configurations<br>- Adjust firewall rules to allow HTTP/HTTPS traffic to required URLs     |

This table provides a concise summary of each test performed by the script, including possible causes for failure and recommendations for mitigation.

## Next steps

If the problem persists, collect [AKS cluster logs](get-on-demand-logs.md) before [creating a support request](aks-troubleshoot.md#open-a-support-request). 
