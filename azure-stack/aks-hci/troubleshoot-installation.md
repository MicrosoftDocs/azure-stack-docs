---
title: Troubleshoot known issues and errors when installing Azure Kubernetes Service on Azure Stack HCI 
description: Find solutions to known issues and errors when installing Azure Kubernetes Service on Azure Stack HCI 
author: v-susbo
ms.topic: troubleshooting
ms.date: 09/15/2021
ms.author: v-susbo
ms.reviewer: 
---

# Troubleshoot known issues and errors during an AKS on Azure Stack HCI installation

This article describes known issues and errors you may encounter when running an installation of AKS on Azure Stack HCI.

## Install-Akshci fails on a multi-node installation

When running [Install-AksHci](./reference/ps/install-akshci.md) on a single-node setup, the installation worked, but when setting up the failover cluster, the installation fails with the error message _Nodes have not reached active state_. However, pinging the cloud agent showed the CloudAgent was reachable.

To ensure all nodes can resolve the CloudAgent's DNS, run the following command on each node:

```powershell
Resolve-DnsName <FQDN of cloudagent>
```

When the step above succeeds on the nodes, make sure the nodes can reach the CloudAgent port to verify that a proxy is not trying to block this connection and the port is open. To do this, run the following command on each node:

```powershell
Test-NetConnection  <FQDN of cloudagent> -Port <Cloudagent port - default 65000>
```

## Install-AksHci timed out with an error

After running [Install-AksHci](./reference/ps/install-akshci.md), the installation stopped and displayed the following _waiting for API server_ error message:

```Output
\kubectl.exe --kubeconfig=C:\AksHci\0.9.7.3\kubeconfig-clustergroup-management 
get akshciclusters -o json returned a non zero exit code 1 
[Unable to connect to the server: dial tcp 192.168.0.150:6443: 
connectex: A connection attempt failed because the connected party 
did not properly respond after a period of time, or established connection 
failed because connected host has failed to respond.]
```

There are multiple reasons why an installation might fail with the _waiting for API server_ error. See the following sections for possible causes and solutions for this error.

### Reason 1: Incorrect IP gateway configuration
If you're using static IP and you received the following error message, confirm that the configuration for the IP address and gateway is correct. 
```PowerShell
Install-AksHci 
C:\AksHci\kvactl.exe create –configfile C:\AksHci\yaml\appliance.yaml  --outfile C:\AksHci\kubeconfig-clustergroup-management returned a non zero exit code 1 [ ]
```

To check whether you have the right configuration for your IP address and gateway, run the following: 

```powershell
ipconfig /all
```

In the displayed configuration settings, confirm the configuration. You could also attempt to ping the IP gateway and DNS server. 

If these methods don't work, use [New-AksHciNetworkSetting](./reference/ps/new-akshcinetworksetting.md) to change the configuration.

### Reason 2: Incorrect DNS server
If you’re using static IP, confirm that the DNS server is correctly configured. To check the host's DNS server address, use the following command:

```powershell
Get-NetIPConfiguration.DNSServer | ?{ $_.AddressFamily -ne 23} ).ServerAddresses
```

Confirm that the DNS server address is the same as the address used when running `New-AksHciNetworkSetting` by running the following command:

```powershell
Get-MocConfig
```

If the DNS server has been incorrectly configured, reinstall AKS on Azure Stack HCI with the correct DNS server. For more information, see [Restart, remove, or reinstall Azure Kubernetes Service on Azure Stack HCI ](./restart-cluster.md).

The issue was resolved after deleting the configuration and restarting the VM with a new configuration.

## Install-AksHci fails due to an Azure Arc onboarding failure

After running [Install-AksHci](./reference/ps/install-akshci.md), a _Failed to wait for addon arc-onboarding_ error occurred.

To resolve this issue, use the following steps:

1. Open PowerShell and run [Uninstall-AksHci](./reference/ps/uninstall-akshci.md).
2. Open the Azure portal and navigate to the resource group you used when running `Install-AksHci`.
3. Check for any connected cluster resources that appear in a _Disconnected_ state and include a name shown as a randomly generated GUID. 
4. Delete these cluster resources.
5. Close the PowerShell session and open new session before running `Install-AksHci` again.

## Install-AksHci fails because the nodes did not reach an Active state
After running [Uninstall-AksHci](./reference/ps/uninstall-akshci.md), [Install-AksHci](./reference/ps/install-akshci.md) may fail with a _Nodes have not reached Active state_ error message if it's run in the same PowerShell session that was used when running `Uninstall-AksHci`. You should close the PowerShell session after running `Uninstall-AksHci` and then open a new session before running `Install-AksHci`. This issue can also appear when deploying AKS on Azure Stack HCI using Windows Admin Center. 

This error message is an infrastructure issue that happens if the node agent is unable to connect to CloudAgent. There should be connectivity between the nodes, and each node should be able to resolve the CloudAgent ca-\<guid>\. While the deployment is stuck, manually check each node to see if [Resolve-DnsName](/powershell/module/dnsclient/resolve-dnsname?view=windowsserver2019-ps&preserve-view=true) works.

## After a failed installation, the Install-AksHci PowerShell command cannot be run
If your installation fails using [Install-AksHci](./reference/ps/uninstall-akshci.md), you should run [Uninstall-AksHci](./reference/ps/uninstall-akshci.md) before running `Install-AksHci` again. This issue happens because a failed installation may result in leaked resources that have to be cleaned up before you can install again.

## During deployment, the error _Waiting for pod ‘Cloud Operator’ to be ready_ appears
When attempting to deploy an AKS on Azure Stack HCI cluster on an Azure VM, the installation was stuck at _Waiting for pod 'Cloud Operator' to be ready..._, and then failed and timed out after two hours. Attempts to troubleshoot by checking the gateway and DNS server showed they were working appropriately. Checks to see if there was an IP or MAC address conflict showed none were found. When viewing the logs, it showed that the VIP pool had not reached the logs. There was a restriction on pulling the container image using `sudo docker pull ecpacr.azurecr.io/kube-vip:0.3.4` that returned a Transport Layer Security (TLS) timeout instead of _unauthorized_. 

To resolve this issue, run the following steps:

1. Start to deploy your cluster.
2. When deployed, connect to management cluster VM through SSH as shown below:

   ```
   ssh -i (Get-MocConfig)['sshPrivateKey'] clouduser@<IP Address>
   ```

3. Change the maximum transmission unit (MTU) setting. Don't hesitate to make the change because if you make the change too late, then the deployment fails. Modifying the MTU setting helps unblock the container image pull.

   ```
   sudo ifconfig eth0 mtu 1300
   ```

4. To view the status of your containers, run the following command:
   ```
   sudo docker ps -a
   ```

After performing these steps, the container image pull should be unblocked.