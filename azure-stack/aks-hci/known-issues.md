---
title: Known issues for Azure Kubernetes Service on Azure Stack HCI 
description: Known issues for Azure Kubernetes Service on Azure Stack HCI 
author: abha
ms.topic: troubleshooting
ms.date: 05/05/2021
ms.author: abha
ms.reviewer: 
---

# Known issues for Azure Kubernetes Service on Azure Stack HCI
This article describes known issues with Azure Kubernetes Service on Azure Stack HCI.

## Cloud agent may fail to start successfully when using path names with spaces in them
When using [Set-AksHciConfig](set-akshciconfig.md) to specify `-imageDir`,`-workingDir`,`-cloudConfigLocation` or `-nodeConfigLocation` parameters with a path name that contains a space character, such as `D:\Cloud Share\AKS HCI`, the cloud agent cluster service will fail to start with the following (or similar) error message:

```powershell
Failed to start the cloud agent generic cluster service in failover cluster. The cluster resource group os in the 'failed' state. Resources in 'failed' or 'pending' states: 'MOC Cloud Agent Service'
```
Workaround: Use a path that does not include spaces, for example, `C:\CloudShare\AKS-HCI`.

## The Windows or Linux node count cannot be seen when Get-AksHciCluster is run
If you provision an AKS cluster on Azure Stack HCI with zero Linux or Windows nodes, when you run [Get-AksHciCluster](get-akshcicluster.md), you will get an empty string or null value as your output.

## Uninstall-AksHciAdAuth fails with an error
If [Uninstall-AksHciAdAuth](./uninstall-akshciadauth.md) displays the following error: [Error from server (NotFound): secrets "keytab-akshci-scale-reliability" not found]. You should ignore this error for now as this issue will be fixed.

## Error appears when moving from PowerShell to Windows Admin Center to create an Arc enabled workload cluster
The error **Cannot index into a null array** appears when moving from PowerShell to Windows Admin Center to create an Arc enabled workload cluster. You can safely ignore this error as it is part of the validation step, and the cluster has already been created. 

## Set-AksHciConfig fails with WinRM errors, but shows WinRM is configured correctly
When running [Set-AksHciConfig](./set-akshciconfig.md), you might encounter the following error:

```powershell
WinRM service is already running on this machine.
WinRM is already set up for remote management on this computer.
Powershell remoting to TK5-3WP08R0733 was not successful.
At C:\Program Files\WindowsPowerShell\Modules\Moc\0.2.23\Moc.psm1:2957 char:17
+ ...             throw "Powershell remoting to "+$env:computername+" was n ...
+                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : OperationStopped: (Powershell remo...not successful.:String) [], RuntimeException
    + FullyQualifiedErrorId : Powershell remoting to TK5-3WP08R0733 was not successful.
```

Most of the time, this error occurs as a result of a change in the user's security token (due to a change in group membership), a password change, or an expired password. In most cases, the issue can be remediated by logging off from the computer and logging back in. If this still fails, you can file an issue at [GitHub AKS HCI issues](https://aka.ms/aks-hci/issues).

## When using kubectl to delete a node, the associated VM might not be deleted

You'll see this issue if you follow these steps:

1. Create a Kubernetes cluster.
2. Scale the cluster to more than two nodes.
3. To delete a node, run the following command: 
   ```powershell
   kubectl delete node <node-name>
   ```

4. To return a list of the nodes:
   ```powershell
   kubectl get nodes
   ```
   The removed node isn't listed in the output.
5. Open a PowerShell with administrative privileges, and run the following command:
   ```powershell
   get-vm
   ```
The removed node is still listed.

This failure causes the system not to recognize that the node is missing, and therefore, a new node will not spin up. 

## The workload cluster not found 

The workload cluster may not be found if the IP address pools of two AKS on Azure Stack HCI deployments are the same or overlap. If you deploy two AKS hosts and use the same `AksHciNetworkSetting` configuration for both, PowerShell and Windows Admin Center will potentially fail to find the workload cluster as the API server will be assigned the same IP address in both clusters resulting in a conflict.

The error message you receive will look similar to the example shown below.

```powershell
A workload cluster with the name 'clustergroup-management' was not found.
At C:\Program Files\WindowsPowerShell\Modules\Kva\0.2.23\Common.psm1:3083 char:9
+         throw $("A workload cluster with the name '$Name' was not fou ...
+         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : OperationStopped: (A workload clus... was not found.:String) [], RuntimeException
    + FullyQualifiedErrorId : A workload cluster with the name 'clustergroup-management' was not found.
```

> [!NOTE]
> Your cluster name will be different.

## Time synchronization must be configured across all physical cluster nodes and in Hyper-V
To ensure gMSA and AD authentication works, ensure that the Azure Stack HCI cluster nodes are configured to synchronize their time with a domain controller or other
time source and that Hyper-V is configured to synchronize time to any virtual machines.

## Hyper-V manager shows high CPU and/or memory demands for the management cluster
When you check Hyper-V manager, high CPU and memory demands for the management cluster can be safely ignored. They are usually related to spikes in compute resource usage when provisioning workload clusters. Increasing the memory or CPU size for the management cluster has not shown a significant improvement and can be safely ignored.

## Special Active Directory permissions are needed for domain joined Azure Stack HCI nodes 
Users deploying and configuring Azure Kubernetes Service on Azure Stack HCI need to have "Full Control" permission to create AD objects in the Active Directory container the server and service objects are created in. 

## PowerShell deployment doesn't check for available memory before creating a new target cluster
The **Aks-Hci** PowerShell commands do not validate the available memory on the host server before creating Kubernetes nodes. This can lead to memory exhaustion and virtual machines that do not start. This failure is currently not handled gracefully, and the deployment will stop responding with no clear error message.
If you have a deployment that stops responding, open `Eventviewer` and check for a Hyper-V-related error message indicating there's not enough memory to start the VM.

## Moving virtual machines between Azure Stack HCI cluster nodes quickly leads to VM startup failures
When using the cluster administration tool to move a VM from one node (Node A) to another node (Node B) in the Azure Stack HCI cluster, the VM may fail to start on the new node. After moving the VM back to the original node, it will fail to start there as well.
This issue happens because the logic to clean up the first migration runs asynchronously. As a result, Azure Kubernetes Service's "update VM location" logic finds the VM on the original Hyper-V on node A, and deletes it, instead of unregistering it.
Workaround: Ensure the VM has started successfully on the new node before moving it back to the original node.
This issue will be fixed in a future release.

## When downloading the AKS on Azure Stack HCI package, the download fails
If you get an error that says `msft.sme.aks couldn't load`, and the error says that loading chunks failed, use the latest version of Microsoft Edge or Google Chrome and try again.

## The Setup or Cluster Create wizard displays an error about a wrong configuration
If you receive an error in either wizard about a wrong configuration, perform cluster cleanup operations. These operations might involve removing the C:\Program Files\AksHci\mocctl.exe file.

## New-AksHciCluster times out when creating an AKS cluster with 200 nodes 
The deployment of a large cluster may time out after two hours, however, this is a static time-out. You can ignore this time out occurrence as the operation is running in the background. Use the `kubectl get nodes` command to access your cluster and monitor the progress. 

## Uninstall-AksHCI is not cleaning up cluster resources (ownergroup ca-<GUID>)
Due to insufficient permissions in Active Directory, `Uninstall-AksHci` could not remove cluster resource objects in AD, which can lead to failures in subsequent deployments. To fix this issue, ensure that the user performing the installation has Full Control permissions to create/modify/remove AD objects in the Active Directory container the server and service objects are created in.

## Deployment fails on an Azure Stack HCI configured with SDN
While deploying Azure Kubernetes Service on an Azure Stack HCI cluster that has a Software Defined Network (SDN), the deployment fails at cluster creation. 

## Load balancer in Azure Kubernetes Service requires DHCP reservation
The load balancing solution in Azure Kubernetes Service on Azure Stack HCI uses DHCP to assign IP addresses to service endpoints. If the IP address changes for the service endpoint due to a service restart, DHCP lease expires due to a short expiration time. Therefore, the service becomes inaccessible because the IP address in the Kubernetes configuration is different from what is on the endpoint. This can lead to the Kubernetes cluster becoming unavailable. To get around this issue, use a MAC address pool for the load balanced service endpoints and reserve specific IP addresses for each MAC address in the pool. 

## Get-AksHciLogs command may fail
With large clusters, the `Get-AksHciLogs` command may throw an exception, fail to enumerate nodes, or will not generate the c:\wssd\wssdlogs.zip output file. This is because the PowerShell command to zip a file Compress-Archive has an output file size limit of 2GB. 

## Creating virtual networks with a similar configuration cause overlap issues
When creating overlapping network objects using the `new-akshcinetworksetting` and `new-akshciclusternetwork` PowerShell cmdlets, issues can occur. For example, this can happen in the scenarios where two virtual network configurations are almost the same.

## Error occurs when running Uninstall-AksHci and AKS on Azure Stack HCI is not installed
If you run [Uninstall-AksHci](./uninstall-akshci.md) when AKS on Azure Stack HCI is not installed, you'll receive the error message: _Cannot bind argument to parameter 'Path' because it is null_. You can safely ignore the error message as there is no functional impact.

## Next steps
- [Troubleshoot Windows Admin Center](./troubleshoot-windows-admin-center.md)
- [Resolve known issues](./troubleshoot-known-issues.md)
- [Connect with SSH to Windows or Linux worker nodes](./ssh-connection.md)
