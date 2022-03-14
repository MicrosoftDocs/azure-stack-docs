---
title: Known issues when upgrading Azure Kubernetes Service on Azure Stack HCI 
description: Known issues when upgrading  Azure Kubernetes Service on Azure Stack HCI 
author: mattbriggs
ms.topic: troubleshooting
ms.date: 2/16/2022
ms.author: mabrigg 
ms.lastreviewed: 1/21/2022
ms.reviewer: abha

---

# Resolve issues when upgrading AKS on Azure Stack HCI

This article describes known issues and errors you may encounter when upgrading AKS on Azure Stack HCI to the newest release. You can also review known issues with [Windows Admin Center](known-issues-windows-admin-center.md) and when [installing AKS on Azure Stack HCI](known-issues-installation.md).

## Nodeagent leaking ports when unable to join cloudagent due to expired token when cluster not upgraded for more than 60 days

When cluster not upgraded for more than 60 days. The node agent would fail to start due to token expiry on restart of node agent. This would cause the agents to be in starting phase. The continuous try to join the cloudagent may exhaust the ports in the host. The status for the below command would be **Starting**.

```powershell
Get-Service wssdagent | Select-Object -Property Name, Status
```

Expected behavior: the node agent would be in the starting phase, which will constantly try joining the cloud agent and exhausting the ports.

To resolve the issue, you'll need to first stop the wssdagent from running. Since the service is in starting phase, it may prevent you from stopping the service. You'll need to kill the process before attempting to stop the service.

1. Confirm the wssdagent is in starting phase.
    ```powershell
    Get-Service wssdagent | Select-Object -Property Name, Status
    ```

1. Kill the process.
    ```powershell
    kill -Name wssdagent -Force
    ```

1. Stop the service.
    ```powershell
    Stop-Service wssdagent -Force
    ```
   
   > [!NOTE]  
   > Even after stopping the service the wssdagent process appears to start in few seconds for a couple of times before stopping. Before proceeding to the next step, make sure the below command returns back with an error on all the nodes.
   
   ```powershell
   Get-Process -Name wssdagent
   ```
   
   ```output  
   PS C:\WINDOWs\system32 Get-process -Name wssdagent 
   Get-process : Cannot find a process with the name "wssdaqent". Verify the process name and call the cmdlet again.
   At line: 1 char: 1 
   + Get-process -Name wssdagent
   + ~~~~~~~~~~~~~~~~~~~~~~~~~~~
      + Categorylnfo          : ObjectNotFound: (wssdagent:String) [Get-Process], ProcessCommandException 
      + FullyQua1ifiedErrorId : NoProcess FoundForGivenName , Microsoft.PowerShell.Commands.Getprocesscommand
   ```

1. Step 1, 2, and 3 should be repeated at each node of the HCI cluster hitting this issue.

1. After confirming the wssdagent is not running. You need to start the cloudagent if it isn't running.
   ```powershell
   Start-ClusterGroup -Name (Get-MocConfig).clusterRoleName
   ```

1. Once you confirm the cloudagent is up and running.
    ```powershell
    Get-ClusterGroup -Name (Get-MocConfig).clusterRoleName
    ```

1. Run the below command to fix the wssdagent.
    ```powershell
    Repair-Moc
    ```

1. Once this command completes, the wssdagent should be in running state.
    ```powershell
    Get-Service wssdagent | Select-Object -Property Name, Status
    ```
## Update of host OS HCI to HCIv2 breaks AKS on Azure Stack HCI installation: OutOfCapacity 

Running an OS update on a host with an AKS on Azure Stack HCI deployment can cause the deployment to enter a bad state and fail day two operations. The MOC NodeAgent Services may fail to start on updated hosts. All MOC calls to the nodes will fail.

> [!NOTE]
> This issue only happens occasionally.

To Reproduce: When you update a cluster with an existing AKS HCI deployment from HCI to HCIv2, an AKS HCI operation such as `New-AksHciCluster` may fail. The error message will state the MOC nodes are OutOfCapacity. For example:

```PowerShell
System.Collections.Hashtable.generic_non_zero1 [Error: failed to create nic test-load-balancer-whceb-nic for machinetest-load-balancer-whceb: unable to create VM network interface: failed to create network interface test-load-balancer-whceb-nic in resource group clustergroup-test: rpc error: code = Unknown desc = Location 'MocLocation' doesn't expose any nodes to create VNIC 'test-load-balancer-whceb-nic' on: OutOfCapacity]
```

To resolve this issue, start the wssdagent Moc NodeAgent Service on the affected nodes. This will solve the issue, and bring the deployment back to a good state. Run the following command:

```PowerShell
Get-ClusterNode -ErrorAction Stop | ForEach-Object { Invoke-Command -ComputerName $_ -ScriptBlock { Start-Service wssdagent -WarningAction:SilentlyContinue } }
```
## Update of host OS HCI to HCIv2 breaks AKS on Azure Stack HCI installation: Cannot reach management cluster

Running an OS update on a host with an AKS on Azure Stack HCI deployment can cause the deployment to enter a bad state, rendering the management cluster's API server unreachable and fail day two operations. The kube-vip pod will not be able to apply VIP configuration to the interface, and as a result the VIP will be unreachable.

To Reproduce: Update a cluster with an existing AKS HCI deployment from HCI to HCIv2 then try running commands that attempt to reach the management cluster such as `Get-AksHciCluster`. Any operations that attempt to reach the management cluster will fail with errors such as:

```powershell
PS C:\Users\wolfpack> Get-AksHciCluster
C:\Program Files\AksHci\kvactl.exe cluster list --kubeconfig="C:\ClusterStorage\Volume1\Msk8s\WorkingDir\1.0.8.10223\kubeconfig-mgmt" System.Collections.Hashtable.generic_non_zero 1 [Error: failed to connect to the cluster: action failed after 9
attempts: Get "https://10.193.237.5:6443/api?timeout=10s": net/http: request canceled while waiting for connection
(Client.Timeout exceeded while awaiting headers)]
At C:\Program Files\WindowsPowerShell\Modules\Kva\1.0.22\Common.psm1:2164 char:9
+         throw $errMessage
+         ~~~~~~~~~~~~~~~~~
    + CategoryInfo          : OperationStopped: (C:\Program File...iting headers)]:String) [], RuntimeException
    + FullyQualifiedErrorId : C:\Program Files\AksHci\kvactl.exe cluster list --kubeconfig="C:\ClusterStorage\Volume1\Msk8s\WorkingDir\1.0.8.10223\kubeconfig-mgmt" System.Collections.Hashtable.generic_non_zero 1 [Error: failed to connect to the cluster: action failed after 9 attempts: Get "https://10.193.237.5:6443/api?timeout=10s": net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)]
``` 

To resolve this issue: restart the `kube-vip` container to bring the deployment back to a good state.

1. Get the `kube-vip` container ID:

   ```powershell  
   ssh -i (Get-AksHciConfig).Moc.sshPrivateKey clouduser@<ip> "sudo crictl ls | grep 'kube-vip'"
   ```

   The output should look something like this, with the container ID being the first value `4a49a5158a5f8`.
   ```powershell  
   4a49a5158a5f8       7751a28bb5ce1       28 minutes ago      Running             kube-vip                         1                   cf9681f921a55
   ```

1. Restart the Restart the container:

   ```powershell  
   ssh -i (Get-AksHciConfig).Moc.sshPrivateKey clouduser@<ip> "sudo crictl stop <Container ID>"
   ```

## Certificate renewal pod is in a crash loop state

After upgrading or up-scaling the target cluster the certificate renewal pod is now in a crash loop state. It's expecting a cert tattoo `yaml` file from the path `/etc/Kubernetes/pki`. The configuration file is present in control plane node VMs but not on worker node VMs. 

To resolve this issue, you manually copy the cert tattoo file from the control plane node to each of the worker nodes.

1. Copy the file from control plane VM to your host machine current directory.

    ```bash
    ssh clouduser@<comtrol-plane-vm-ip> -i (get-mocconfig).sshprivatekey
    sudo cp /etc/kubernetes/pki/cert-tattoo-kubelet.yaml ~/
    sudo chown clouduser cert-tattoo-kubelet.yaml
    sudo chgrp clouduser cert-tattoo-kubelet.yaml
    (change file permissions here so that scp will work)
    scp -i (get-mocconfig).sshprivatekey clouduser@<comtrol-plane-vm-ip>:~/cert*.yaml .\
    ```

2. Copy the file from host machine to the worker node VM.

    ```bash
    scp -i (get-mocconfig).sshprivatekey .\cert-tattoo-kubelet.yaml clouduser@<workernode-vm-ip>:~/cert-tattoo-kubelet.yaml
    ```

3. Set the owner and group information on this file back to root if it not already set to root.

    ```bash
    ssh clouduser@<workernode-vm-ip> -i (get-mocconfig).sshprivatekey
    sudo cp ~/cert-tattoo-kubelet.yaml /etc/kubernetes/pki/cert-tattoo-kubelet.yaml (copies the cert file to correct location)
    sudo chown root cert-tattoo-kubelet.yaml
    sudo chgrp root cert-tattoo-kubelet.yaml
    ```

4. Repeat steps two and three for each of your worker nodes.

## When upgrading a Kubernetes cluster with an Open Policy Agent, the upgrade process hangs

When upgrading Kubernetes clusters with an Open Policy Agent (OPA), such as OPA GateKeeper, the process may hang and unable to complete. This issue can occur because the policy agent is configured to prevent pulling container images from private registries.

To resolve this issue, if you upgrade clusters deployed with an OPA, make sure that your policies allow for pulling images from Azure Container Registry. For an AKS on Azure Stack HCI upgrade, you should add the following endpoint in your policy's list: _ecpacr.azurecr.io_.

## AKS on Azure Stack HCI goes out-of-policy if a workload cluster hasn't been created in 60 days

If you created a management cluster but haven't deployed a workload cluster in the first 60 days, you'll be blocked from creating one after that because it's out-of-policy. In this situation, when you run [Update-AksHci](./reference/ps/update-akshci.md), the update process is blocked with the error _Waiting for deployment 'AksHci Billing Operator' to be ready_. If you run [Sync-AksHciBilling](./reference/ps/sync-akshcibilling.md), it returns successful output, however, if you run [Get-AksHciBillingStatus](./reference/ps/get-akshcibillingstatus.md), the connection status is _OutofPolicy_.

If you haven't deployed a workload cluster in 60 days, the billing goes out of policy. The only way to fix this issue is to redeploy with a clean installation.

## After upgrading to PowerShell module 1.1.9, this error appears: `Applying platform configurations failed. Error: No adapter is connected to the switch:'swtch1' on node: 'node1'`

This error was resolved in PowerShell module version 1.1.11. Update the PowerShell module to version 1.1.11 on all nodes to resolve this issue.

## During an upgrade, custom node taints, roles, and labels are lost

When upgrading, you may lose all custom taints, roles, and labels that you added to your worker nodes. Since AKS on Azure Stack HCI is a managed service, adding custom taints, labels, and roles when performed outside the provided PowerShell cmdlets or Windows Admin Center is not supported.

To work around this issue, run the [New-AksHciNodePool](./reference/ps/new-akshcinodepool.md) cmdlet to correctly [create a node pool with taints](./reference/ps/new-akshcinodepool.md#create-a-node-pool-with-taints) for your worker nodes.

## After a successful upgrade, older versions of PowerShell are not removed

To work around this issue, you need to [run a script to uninstall older PowerShell versions](https://github.com/Azure/aks-hci/issues/130).

## Running an upgrade results in the error: `Error occurred while fetching platform upgrade information`

When running an upgrade in Windows Admin Center, the following error occurred:

`Error occurred while fetching platform upgrade information. RemoteException: No match was found for the specified search criteria and module name 'AksHci'. Try Get-PSRepository to see all available registered module repositories.`

This error message typically occurs when AKS on Azure Stack HCI is deployed in an environment that has a proxy configured. Currently, Windows Admin Center doesn't have support to install modules in a proxy environment. To resolve this error, set up AKS on Azure Stack HCI [using the proxy PowerShell command](set-proxy-settings.md).

## When running Update-AksHci, the update process was stuck at `Waiting for deployment 'AksHci Billing Operator' to be ready`

This status message appears when running the [Update-AksHci](./reference/ps/update-akshci.md) PowerShell cmdlet. Review the following root causes to resolve the issue:

* **Reason one**:
   During the update of the _AksHci Billing Operator_, the _Operator_ incorrectly marked itself as out of policy. To resolve this issue, open up a new PowerShell window and run [Sync-AksHciBilling](./reference/ps/sync-akshcibilling.md). You should see the billing operation continue within the next 20-30 minutes. 

* **Reason two**:
   The management cluster VM may be out of memory, which causes the API server to be unreachable, and consequently, makes all commands from [Get-AksHciCluster](./reference/ps/get-akshcicluster.md), billing, and update run into a timeout. As a workaround, set the management cluster VM to 32 GB in Hyper-V and reboot it. 

* **Reason three**:
   The _AksHci Billing Operator_ may be out of storage space, which is due to a bug in the Microsoft SQL configuration settings. The lack of storage space may be causing the upgrade to stop responding. To work around this issue, manually resize the billing pod `pvc` using the following steps. 

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

## Attempt to upgrade from the GA release to version 1.0.1.10628 is stuck at `Update-KvaInternal`

When attempting to upgrade AKS on Azure Stack HCI from the GA release to version 1.0.1.10628, if the `ClusterStatus` shows `OutOfPolicy`, you could be stuck at the _Update-KvaInternal_ stage of the upgrade installation. If you use the [repair-akshcicerts](./reference/ps/repair-akshcicerts.md) PowerShell cmdlet as a workaround, it also may not work. The AKS on Azure Stack HCI billing status must show as connected before upgrading. An AKS on Azure Stack HCI upgrade is forward only and doesn't support version rollback, so if you get stuck, you can’t upgrade.

## When using PowerShell to upgrade, an excess number of Kubernetes configuration secrets is created on a cluster
The June 1.0.1.10628 build of AKS on Azure Stack HCI creates an excess number of Kubernetes configuration secrets in the cluster. The upgrade path from the June 1.0.1.10628 release to the July 1.0.2.10723 release was improved to clean up the extra Kubernetes secrets. However, in some cases during upgrading, the secrets were still not cleaned up, and therefore, the upgrade process fails.

If you experience this issue, run the following steps:

1. Save the script below as a file named _fix_leaked_secrets.ps1_:

   ```
   upgparam (
   [Parameter(Mandatory=$true)]
   [string] $ClusterName,
   [Parameter(Mandatory=$true)]
   [string] $ManagementKubeConfigPath
   )

   $ControlPlaneHostName = kubectl get nodes --kubeconfig $ManagementKubeConfigPath -o=jsonpath='{.items[0].metadata.name}'
   "Hostname is: $ControlPlaneHostName"

   $leakedSecretPath1 = "$ClusterName-template-secret-akshci-cc"
   $leakedSecretPath2 = "$ClusterName-moc-kms-plugin"
   $leakedSecretPath3 = "$ClusterName-kube-vip"
   $leakedSecretPath4 = "$ClusterName-template-secret-akshc"
   $leakedSecretPath5 = "$ClusterName-linux-template-secret-akshci-cc"
   $leakedSecretPath6 = "$ClusterName-windows-template-secret-akshci-cc"

   $leakedSecretNameList = New-Object -TypeName 'System.Collections.ArrayList';
   $leakedSecretNameList.Add($leakedSecretPath1) | Out-Null
   $leakedSecretNameList.Add($leakedSecretPath2) | Out-Null
   $leakedSecretNameList.Add($leakedSecretPath3) | Out-Null
   $leakedSecretNameList.Add($leakedSecretPath4) | Out-Null
   $leakedSecretNameList.Add($leakedSecretPath5) | Out-Null
   $leakedSecretNameList.Add($leakedSecretPath6) | Out-Null

   foreach ($leakedSecretName in $leakedSecretNameList)
   {
   "Deleting secrets with the prefix $leakedSecretName"
   $output = kubectl --kubeconfig $ManagementKubeConfigPath exec etcd-$ControlPlaneHostName -n kube-system -- sh -c "ETCDCTL_API=3 etcdctl --cacert /etc/kubernetes/pki/etcd/ca.crt --key /etc/kubernetes/pki/etcd/server.key --cert /etc/kubernetes/pki/etcd/server.crt del /registry/secrets/default/$leakedSecretName --prefix=true"
   "Deleted: $output"
   }
   ```
2. Next, run the following command using the _fix_secret_leak.ps1_ file you saved:
   
   ```powershell
      .\fix_secret_leak.ps1 -ClusterName (Get-AksHciConfig).Kva.KvaName -ManagementKubeConfigPath (Get-AksHciConfig).Kva.Kubeconfig
   ```

3. Finally, use the following PowerShell command to repeat the upgrade process:

   ```powershell
      Update-AksHci
   ```

## Incorrect upgrade notification in Windows Admin Center

If you receive an incorrect upgrade notification message `Successfully installed AksHci PowerShell module version null`, the upgrade operation is successful even if the notification is misleading.

![WAC update dashboard doesn't refresh after successful updates.](media/known-issues-windows-admin-center/wac-known-issue-incorrect-notification.png)

## Windows Admin Center update dashboard doesn't refresh after successful updates

After a success upgrade, the Windows Admin Center update dashboard still shows the previous version. Refresh the browser to fix this issue.

![Networking field names inconsistent in WAC portal.](media/known-issues-windows-admin-center/wac-update-shows-previous-version.png)

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

## Next steps
- [Troubleshooting overview](troubleshoot-overview.md)
- [Installation issues and errors](known-issues-installation.md)
- [Windows Admin Center known issues](known-issues-windows-admin-center.md)

If you continue to run into problems when you're using Azure Kubernetes Service on Azure Stack HCI, you can file bugs through [GitHub](https://aka.ms/aks-hci-issues).
