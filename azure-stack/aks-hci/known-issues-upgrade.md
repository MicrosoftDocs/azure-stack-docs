---
title: Known issues when upgrading Azure Kubernetes Service on Azure Stack HCI 
description: Known issues when upgrading  Azure Kubernetes Service on Azure Stack HCI 
author: EkeleAsonye
ms.topic: troubleshooting
ms.date: 09/22/2021
ms.author: v-susbo
ms.reviewer: 
---

# Known issues when upgrading AKS on Azure Stack HCI

This article describes known issues and errors you may encounter when upgrading AKS on Azure Stack HCI to the newest release. You can also review known issues with [Windows Admin Center](known-issues-windows-admin-center.md) and when [installing AKS on Azure Stack HCI](known-issues-installation.md).

## When upgrading a Kubernetes cluster with an Open Policy Agent, the upgrade process hangs

When upgrading Kubernetes clusters with an Open Policy Agent (OPA), such as OPA GateKeeper, the process may hang and unable to complete. This issue can occur because the policy agent is configured to prevent pulling container images from private registries.

To resolve this issue, if you upgrade clusters deployed with an OPA, make sure that your policies allow for pulling images from Azure Container Registry. For an AKS on Azure Stack HCI upgrade, you should add the following endpoint in your policy's list: _ecpacr.azurecr.io_.

## AKS on Azure Stack HCI goes out-of-policy if a workload cluster hasn't been created in 60 days

If you created a management cluster but haven't deployed a workload cluster in the first 60 days, you'll be blocked from creating one after that because it's out-of-policy. In this situation, when you run [Update-AksHci](./reference/ps/update-akshci.md), the update process is blocked with the error _Waiting for deployment 'AksHci Billing Operator' to be ready_. If you run [Sync-AksHciBilling](./reference/ps/sync-akshcibilling.md), it returns successful output, however, if you run [Get-AksHciBillingStatus](./reference/ps/get-akshcibillingstatus.md), the connection status is _OutofPolicy_.

If you haven't deployed a workload cluster in 60 days, the billing goes out of policy. The only way to fix this issue is to redeploy with a clean installation.

## After upgrading to PowerShell module 1.1.9, this error appears: _Applying platform configurations failed. Error: No adapter is connected to the switch:'swtch1’ on node: ‘node1’_ 

This error was resolved in PowerShell module version 1.1.11. Update the PowerShell module to version 1.1.11 on all nodes to resolve this issue.

## During an upgrade, custom node taints, roles, and labels are lost

When upgrading, you may lose all custom taints, roles, and labels that you added to your worker nodes. Since AKS on Azure Stack HCI is a managed service, adding custom taints, labels, and roles when performed outside the provided PowerShell cmdlets or Windows Admin Center is not supported.

To work around this issue, run the [New-AksHciNodePool](./reference/ps/new-akshcinodepool.md) cmdlet to correctly [create a node pool with taints](./reference/ps/new-akshcinodepool.md#create-a-node-pool-with-taints) for your worker nodes.

## After a successful upgrade, older versions of PowerShell are not removed

To work around this issue, you need to [run a script to uninstall older PowerShell versions](https://github.com/Azure/aks-hci/issues/130).

## Running an upgrade results in the error: _Error occurred while fetching platform upgrade information..._

When running an upgrade in Windows Admin Center, the following error occurred:

_Error occurred while fetching platform upgrade information. RemoteException: No match was found for the specified search criteria and module name 'AksHci'. Try Get-PSRepository to see all available registered module repositories._

This error message typically occurs when AKS on Azure Stack HCI is deployed in an environment that has a proxy configured. Currently, Windows Admin Center does not have support to install modules in a proxy environment. To resolve this error, set up AKS on Azure Stack HCI [using the proxy PowerShell command](set-proxy-settings.md).

## When running Update-AksHci, the update process was stuck at _Waiting for deployment 'AksHci Billing Operator' to be ready_

When running the [Update-AksHci](./reference/ps/update-akshci.md) PowerShell cmdlet, the update was stuck with a status message: _Waiting for deployment 'AksHci Billing Operator' to be ready_.

This issue could have the following root causes:

* **Reason one**:
   During the update of the _AksHci Billing Operator_, it's that the _Operator_ incorrectly marked itself as out of policy. To resolve this issue, open up a new PowerShell window and run [Sync-AksHciBilling](./reference/ps/sync-akshcibilling.md). You should see the billing operation continue within the next 20-30 minutes. 

* **Reason two**:
   The management cluster VM may be out of memory, which causes the API server to be unreachable, and consequently, makes all commands from Get-AksHciCluster, billing, and update run into a timeout. As a workaround, set the management cluster VM to 32 GB in Hyper-V and reboot it. 

* **Reason three**:
   The AKS on Azure Stack HCI Billing Operator may be out of storage space, which is due to a bug in the Microsoft SQL configuration settings. The lack of storage space may be causing the upgrade to stop responding. To work around this issue, manually resize the billing pod `pvc` using the following steps. 

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

## Attempt to upgrade from the GA release to version 1.0.1.10628 is stuck at _Update-KvaInternal_

When attempting to upgrade AKS on Azure Stack HCI from the GA release to version 1.0.1.10628, if the `ClusterStatus` shows `OutOfPolicy`, you could be stuck at the _Update-KvaInternal_ stage of the upgrade installation. If you use the [repair-akshcicerts](./reference/ps/repair-akshcicerts.md) PowerShell cmdlet as a workaround, it also may not work. The AKS on Azure Stack HCI billing status must show as connected before upgrading. An AKS on Azure Stack HCI upgrade is forward only and does not support version rollback, so if you get stuck, you cannot upgrade.

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
- [Known issues](./known-issues.md)
- [Installation issues and errors](known-issues-installation.md)
- [Windows Admin Center known issues](known-issues-windows-admin-center.md)
- [Troubleshooting Kubernetes clusters](https://kubernetes.io/docs/tasks/debug-application-cluster/troubleshooting/)

If you continue to run into problems when you're using Azure Kubernetes Service on Azure Stack HCI, you can file bugs through [GitHub](https://aka.ms/aks-hci-issues).
