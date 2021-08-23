---
title: Resolve known issues on Azure Kubernetes Service on Azure Stack HCI
description: Learn how to resolve known issues in an Azure Kubernetes Service (AKS) on Azure Stack HCI deployment.
author: EkeleAsonye
ms.topic: how-to
ms.date: 08/20/2021
ms.author: v-susbo
---

# Workarounds for known issues in AKS on Azure Stack HCI

This article includes workaround steps for resolving known issues that occur when using Azure Kubernetes Service on Azure Stack HCI.

## Attempt to upgrade from the GA release to version 1.0.1.10628 is stuck at _Update-KvaInternal_

When attempting to upgrade AKS on Azure Stack HCI from the GA release to version 1.0.1.10628, if the `ClusterStatus` shows `OutOfPolicy`, you could be stuck at the _Update-KvaInternal_ stage of the upgrade installation. If you use the [repair-akshcicerts](repair-akshcicerts.md) PowerShell cmdlet as a workaround, it also may not work. You should ensure that the AKS on Azure Stack HCI billing status shows as connected before upgrading. An AKS on Azure Stack HCI upgrade is forward only and does not support version rollback, so if you get stuck, you cannot upgrade.

## _Install-AksHci_ timed out with an error

After running [Install-AksHci](install-akshci.md), the installation stopped and displayed the following **waiting for API server** error message:

```Output
\kubectl.exe --kubeconfig=C:\AksHci\0.9.7.3\kubeconfig-clustergroup-management 
get akshciclusters -o json returned a non zero exit code 1 
[Unable to connect to the server: dial tcp 192.168.0.150:6443: 
connectex: A connection attempt failed because the connected party 
did not properly respond after a period of time, or established connection 
failed because connected host has failed to respond.]
```

There are multiple reasons why an installation might fail with the **waiting for API server** error. See the following sections for possible causes and solutions for this error.

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

If these methods don't work, use [New-AksHciNetworkSetting](./new-akshcinetworksetting.md) to change the configuration.

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

## When multiple versions of the PowerShell modules are installed, Windows Admin Center does not pick the latest version
If you have multiple versions of the PowerShell modules installed (for example, 0.2.26, 0.2.27, and 0.2.28), Windows Admin Center may not use the latest version (or the one it requires). Make sure you have only one PowerShell module installed. You should uninstall all unused PowerShell versions of the PowerShell modules and leave just one installed. More information on which Windows Admin Center version is compatible with which PowerShell version can be found in the [release notes.](https://github.com/Azure/aks-hci/releases).

## After a failed installation, the Install-AksHci PowerShell command cannot be run
If your installation fails using [Install-AksHci](./uninstall-akshci.md), you should run [Uninstall-AksHci](./uninstall-akshci.md) before running `Install-AksHci` again. This issue happens because a failed installation may result in leaked resources that have to be cleaned up before you can install again.

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

## When running Update-AksHci, the update process was stuck at _Waiting for deployment 'AksHci Billing Operator' to be ready_

When running the [Update-AksHci](update-akshci.md) PowerShell cmdlet, the update was stuck with a status message: _Waiting for deployment 'AksHci Billing Operator' to be ready_.

This issue could have the following root causes:

* **Reason one**:
   During the update of the _AksHci Billing Operator_, it's possible that the _Operator_ incorrectly marked itself as out of policy. To resolve this, open up a new PowerShell window and run `Sync-AksHciBilling`. You should see the billing operation continue within the next 20-30 minutes. 

* **Reason two**:
   The management cluster VM may be out of memory which causes the API server to be unreachable, and consequently, makes all commands from Get-AksHciCluster, billing, and update run into a timeout. As a workaround, set the management cluster VM to 32GB in Hyper-V and reboot it. 

* **Reason three**:
   The AKS on Azure Stack HCI Billing Operator may be out of storage space, which is due to a bug in the Microsoft SQL configuration settings. The lack of storage space may be causing the upgrade to hang. To workaround this issue, manually resize the billing pod `pvc` using the following steps. 

   1. Run the following command to edit the pod settings:

      ```
      kubectl edit pvc mssql-data-claim --kubeconfig (Get-AksHciConfig).Kva.kubeconfig -n azure-arc
      ```

   2. When Notepad or another editor opens with a YAML file, edit the line for storage from 100Mi to 5Gi:

      ```
      spec:
        resources:
          requests:
            **storage: 5Gi**
       ```

   3. Check the status of the billing deployment using the following command:

      ```
      kubectl get deployments/billing-manager-deployment --kubeconfig (Get-AksHciConfig).Kva.kubeconfig -n azure-arc
      ```

## Using Remote Desktop to connect to the management cluster produces a connection error

When using Remote Desktop (RDP) to connect to one of the nodes in an Azure Stack HCI cluster and then running the [Get-AksHciCluster](get-akshcicluster.md) command, an error appears and says the connection failed because the host failed to respond.

The reason for the connection failure is because some PowerShell commands that use `kubeconfig-mgmt` fail with an error similar to the following one:

```
Unable to connect to the server: d ial tcp 172.168.10.0:6443, where 172.168.10.0 is the IP of the control plane.
```

The _kube-vip_ pod can go down for two reasons:

* The memory pressure in the system can slow down `etcd`, which ends up affecting _kube-vip_.
* The _kube-apiserver_ is not available.

To help resolve this issue, try rebooting the machine. However, the issue of the memory pressure slowing down may return.

## When running **kubect get pods**, pods were stuck in a _Terminating_ state

When deploying AKS on Azure Stack HCI, and then running `kubect get pods`, pods in the same node are stuck in the _Terminating_ state. The machine rejects SSH connections because the node was likely experiencing a lot of memory demand.

This issue occurs because the Windows nodes are over-provisioned, and there's no reserve for core components. To avoid this situation, add the resource limits and resource request for CPU and memory to the pod specification to ensure that the nodes aren't over-provisioned. Windows nodes don't support eviction based on resource limits, so you should estimate how much the containers will use and then set the CPU and memory amounts.

## Running the Remove-ClusterNode command evicts the node from the failover cluster, but the node still exists

When running the [Remove-ClusterNode](/powershell/module/failoverclusters/remove-clusternode?view=windowsserver2019-ps) command, the node is evicted from the failover cluster, but if [Remove-AksHciNode](remove-akshcinode.md) is not run afterwards, the node will still exist in CloudAgent.

Since the node was removed from the cluster, but not from CloudAgent, if you use the VHD to create a new node, a _File not found_ error appears. This issue occurs because the VHD is in shared storage, and the evicted node does not have access to it.

To resolve this issue, remove a physical node from the cluster and then follow the steps below:

1. Run `Remove-AksHciNode` to de-register the node from CloudAgent.
2. Perform routine maintenance, such as re-imaging the machine.
3. Add the node back to the cluster.
4. Run `Add-AksHciNode` to register the node with CloudAgent.

## An Arc connection on an AKS cluster cannot be enabled after disabling it.
To enable an Arc connection, after disabling it, run the following [Get-AksHciCredential](./get-akshcicredential.md) PowerShell command as an administrator, where `-Name` is the name of your workload cluster.

```powershell
Get-AksHciCredential -Name myworkloadcluster
kubectl --kubeconfig=kubeconfig delete secrets sh.helm.release.v1.azure-arc.v1
```

## Container storage interface pod stuck in a _ContainerCreating_ state
A new Kubernetes workload cluster was created with Kubernetes version 1.16.10, and then updated to 1.16.15. After the update, the `csi-msk8scsi-node-9x47m` pod was stuck in the _ContainerCreating_ state, and the `kube-proxy-qqnkr` pod was stuck in the _Terminating_ state as shown in the output below:

```output
Error: kubectl.exe get nodes  
NAME              STATUS     ROLES    AGE     VERSION 
moc-lf22jcmu045   Ready      <none>   5h40m   v1.16.15 
moc-lqjzhhsuo42   Ready      <none>   5h38m   v1.16.15 
moc-lwan4ro72he   NotReady   master   5h44m   v1.16.15

\kubectl.exe get pods -A 

NAMESPACE     NAME                        READY   STATUS              RESTARTS   AGE 
    5h38m 
kube-system   csi-msk8scsi-node-9x47m     0/3     ContainerCreating   0          5h44m 
kube-system   kube-proxy-qqnkr            1/1     Terminating         0          5h44m  
```

Since _kubelet_ ended up in a bad state and can no longer talk to the API server, the only solution is to restart the _kubelet_ service. After restarting, the cluster goes into a _running_ state.

## All pods in a Windows node are stuck in a _ContainerCreating_ state
In a workload cluster with the Calico network plug-in enabled, all of the pods in a Windows node are stuck in the _ContainerCreating_ state except for the `calico-node-windows daemonset` pod.

To resolve this issue, find the name of the _kube-proxy_ pod on that node and then run the following command: 

```powershell
kubectl delete pod <KUBE-PROXY-NAME> -n kube-system
```

All the pods should start on the node.

## In a workload cluster with static IP, all pods in a node are stuck in a _ContainerCreating_ state
In a workload cluster with static IP and Windows nodes, all of the pods in a node (including the `daemonset` pods) are stuck in a _ContainerCreating_ state. When attempting to connect to that node using SSH, it fails with a _Connection timed out_ error.

To resolve this issue, use Hyper-V Manager or the Failover Cluster Manager to turn off the VM of that node. After five to ten minutes, the node should have been recreated and with all the pods running.

## Attempt to increase the number of worker nodes fails
When using PowerShell to create a cluster with static IP and then attempt to increase the number of worker nodes in the workload cluster, the installation got stuck at _control plane count at 2, still waiting for desired state: 3_. After a period of time, another error message appears: _Error: timed out waiting for the condition_.

When [Get-AksHciCluster](./get-akshcicluster.md) was run, it showed that the control plane nodes were created and provisioned and were in a _Ready_ state. However, when `kubectl get nodes` was run, it showed that the control plane nodes had been created but not provisioned and were not in a _Ready_ state.

If you get this error, verify that the IP addresses have been assigned to the created nodes using either Hyper-V Manager or PowerShell:

```powershell
(Get-VM |Get-VMNetworkAdapter).IPAddresses |fl
```
  
Then, verify the network settings to ensure there are enough IP addresses left in the pool to create more VMs.   

## When deploying AKS on Azure Stack HCI with a misconfigured network, deployment timed out at various points
When deploying AKS on Azure Stack HCI, the deployment may time out at different points of the process depending on where the misconfiguration occurred. You should review the error message to determine the cause and where it occurred.

For example, in the following error, the point at which the misconfiguration occurred is in `Get-DownloadSdkRelease -Name "mocstack-stable"`: 

```
$vnet = New-AksHciNetworkSettingSet-AksHciConfig -vnet $vnetInstall-AksHciVERBOSE: 
Initializing environmentVERBOSE: [AksHci] Importing ConfigurationVERBOSE: 
[AksHci] Importing Configuration Completedpowershell : 
GetRelease - error returned by API call: 
Post "https://msk8s.api.cdp.microsoft.com/api/v1.1/contents/default/namespaces/default/names/mocstack-stable/versions/0.9.7.0/files?action=generateDownloadInfo&ForegroundPriority=True": 
dial tcp 52.184.220.11:443: connectex: 
A connection attempt failed because the connected party did not properly
respond after a period of time, or established connection failed because
connected host has failed to respond.At line:1 char:1+ powershell -command
{ Get-DownloadSdkRelease -Name "mocstack-stable"}
```

This indicates that the physical Azure Stack HCI node can resolve the name of the download URL, `msk8s.api.cdp.microsoft.com`, but the node can't connect to the target server.

To resolve this issue, you need to determine where the breakdown occurred in the connection flow. Here are some steps to try to resolve the issue from the physical cluster node:

1. Ping the destination DNS name: ping `msk8s.api.cdp.microsoft.com`. 
2. If you get a response back and no time-out, then the basic network path is working. 
3. If the connection times out, then there could be a break in the data path. For more information, see [check proxy settings](./set-proxy-settings.md). Or, there could be a break in the return path, so you should check the firewall rules. 

## An **Unable to acquire token** error appears when running Set-AksHciRegistration
An **Unable to acquire token** error can occur when you have multiple tenants on your Azure account. Use `$tenantId = (Get-AzContext).Tenant.Id` to set the right tenant. Then, include this tenant as a parameter while running [Set-AksHciRegistration](./set-akshciregistration.md). 

## When upgrading a deployment, some pods might be stuck at _waiting for static pods to have a ready condition_

To release the pods and resolve this issue, you should restart _kubelet_. To view the NotReady node with the static pods, run the following command: 

```Console
kubectl get nodes -o wide
```

To get more information on the faulty node, run the following command:

```Console
kubectl describe node <IP of the node>
```

Use SSH to log into the NotReady node by running the following command:
```
ssh -i <path of the private key file> administrator@<IP of the node>
```

Then, to restart _kubelet_, run the following command: 

```powershell
/etc/.../kubelet restart
```

## When creating a persistent volume, an attempt to mount the volume fails

After deleting a persistent volume or a persistent volume claim in an AKS on Azure Stack HCI environment, a new persistent volume is created to map to the same share. However, when attempting to mount the volume, the mount fails, and the pod times out with the error, _NewSmbGlobalMapping failed_.

To work around the failure to mount the new volume, you can SSH into the Windows node and run `Remove-SMBGlobalMapping` and provide the share that corresponds to the volume. After running this command, attempts to mount the volume should succeed.


## Next steps
- [Known issues](./known-issues.md)
- [Troubleshoot Windows Admin Center](./troubleshoot-windows-admin-center.md)
- [Troubleshooting Kubernetes clusters](https://kubernetes.io/docs/tasks/debug-application-cluster/troubleshooting/)
- [Connect with SSH to Windows or Linux worker nodes](./ssh-connection.md)

If you continue to run into problems when you're using Azure Kubernetes Service on Azure Stack HCI, you can file bugs through [GitHub](https://aka.ms/aks-hci-issues).
