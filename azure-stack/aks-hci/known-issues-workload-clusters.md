---
title: Troubleshoot Kubernetes workload cluster issues and errors in Azure Kubernetes Service on Azure Stack HCI 
description: Get help to troubleshoot Kubernetes workload cluster issues and errors in Azure Kubernetes Service on Azure Stack HCI.
author: v-susbo
ms.topic: troubleshooting
ms.date: 11/05/2021
ms.author: v-susbo
ms.reviewer: 
---

# Fix Kubernetes workload cluster known issues and errors

Use this topic to help you troubleshoot and resolve Kubernetes workload cluster-related issues in AKS on Azure Stack HCI.

## If a cluster is shut down for more than four days, the cluster will be unreachable

When you shut down a management or workload cluster for more than four days, the certificates expire and the cluster is unreachable. The certificates expire because they're rotated every 3-4 days for security reasons.

To restart the cluster, you need to manually repair the certificates before you can perform any cluster operations. To repair the certificates, run the following [Repair-AksHciClusterCerts](./reference/ps/repair-akshciclustercerts.md) command:

```powershell
Repair-AksHciClusterCerts -Name <cluster-name> -fixKubeletCredentials
```

## If a management or workload cluster is not used for more than 60 days, the certificates will expire

If you don't use a management or workload cluster for longer than 60 days, the certificates expire, and you must renew them before you can upgrade AKS on Azure Stack HCI. When an AKS on Azure Stack HCI cluster is not upgraded within 60 days, the KMS plug-in token and the certificates both expire within the 60 days. The cluster is still functional, however, since it's beyond 60 days, you need to call Microsoft support to upgrade. If the cluster is rebooted after this period, it will continue to remain in a non-functional state.

To resolve this issue, run the following steps:

1. Repair the management cluster certificate by [manually rotating the token and then restart the KMS plug-in and container](#the-api-server-is-not-responsive-after-several-days).
2. Repair the `mocctl` certificates by running `Repair-MocLogin`.
3. Repair the workload cluster certificates by [manually rotating the token and then restart the KMS plug-in and container](#the-api-server-is-not-responsive-after-several-days). 
 

## The certificate renewal pod is in a crash loop state

After upgrading or scaling up the workload cluster, the certificate renewal pod is now in a crash loop state because the pod is expecting the certificate tattoo YAML file from the file location `/etc/Kubernetes/pki`.

This issue may be due to a configuration file that's present in the control plane VMs but not in the worker node VMs. To resolve this issue, manually copy the certificate tattoo YAML file from the control plane node to all worker nodes.

1. Copy the YAML file from control plane VM on the workload cluster to the current directory of your host machine:
   
   ```
   ssh clouduser@<comtrol-plane-vm-ip> -i (get-mocconfig).sshprivatekey
   sudo cp /etc/kubernetes/pki/cert-tattoo-kubelet.yaml ~/
   sudo chown clouduser cert-tattoo-kubelet.yaml
   sudo chgrp clouduser cert-tattoo-kubelet.yaml
   (Change file permissions here, so that `scp` will work)
   scp -i (get-mocconfig).sshprivatekey clouduser@<comtrol-plane-vm-ip>:~/cert*.yaml .\
   ```

1. Copy the YAML file from the host machine to the worker node VM. Before you copy the file, you must change the name of the machine in the YAML file to the node name to which you're copying (this is the node name for the workload cluster control plane).

   ```
   scp -i (get-mocconfig).sshprivatekey .\cert-tattoo-kubelet.yaml clouduser@<workernode-vm-ip>:~/cert-tattoo-kubelet.yaml
   ```

3. If the owner and group information in the YAML file is not already set to root, set the information to the root:

   ```
   ssh clouduser@<workernode-vm-ip> -i (get-mocconfig).sshprivatekey
   sudo cp ~/cert-tattoo-kubelet.yaml /etc/kubernetes/pki/cert-tattoo-kubelet.yaml (copies the certificate file to the correct location)
   sudo chown root cert-tattoo-kubelet.yaml
   sudo chgrp root cert-tattoo-kubelet.yaml
   ```

4. Repeat steps 2 and 3 for all worker nodes.

## ContainerD is unable to pull the pause image as _kubelet_ mistakenly collects the image 

When _kubelet_ is under disk pressure, it collects unused container images which may include pause images, and when this happens, ContainerD cannot pull the image. 

Currently, AKS on Azure Stack HCI uses Azure Container Registry (ACR) only with authentication disabled as a workaround for an ACR bug. Therefore, the same credentials shipped to customers could be used to pull the pause images on affected nodes, for example, username: 1516df5a-f1cc-4a6a-856c-03d127b02d05, password: 92684690-48b5-4dce-856d-ef4cccb54f22.

To resolve this issue, run the following steps:

1. Connect to the affected node using SSH and run the following command:

   ```
   sudo su
   ```

2. To pull the image, run the following command:

   ```powershell
   crictl pull --creds aaa:bbb ecpacr.azurecr.io/pause:3.2
   ```

## In a workload cluster with static IP, all pods in a node are stuck in a _ContainerCreating_ state
In a workload cluster with static IP and Windows nodes, all of the pods in a node (including the `daemonset` pods) are stuck in a _ContainerCreating_ state. When attempting to connect to that node using SSH, it fails with a _Connection timed out_ error.

To resolve this issue, use Hyper-V Manager or the Failover Cluster Manager to turn off the VM of that node. After five to ten minutes, the node should have been recreated and with all the pods running.

## Linux and Windows VMs were not configured as highly available VMs when scaling a workload cluster
When scaling out a workload cluster, the corresponding Linux and Windows VMs were added as worker nodes, but they were not configured as highly available VMs. When running the [Get-ClusterGroup](/powershell/module/failoverclusters/get-clustergroup?view=windowsserver2019-ps&preserve-view=true) command, the newly created Linux VM was not configured as a Cluster Group.

This is a known issue. After a reboot, the ability to configure VMs as highly available is sometimes lost. The current workaround is to restart `wssdagent` on each of the Azure Stack HCI nodes. 
Note that this works only for new VMs that are generated by creating node pools when performing a scale up operation or when creating new Kubernetes clusters after restarting the `wssdagent` on the nodes. However, you will have to manually add the existing VMs to the failover cluster. 

When you scale down a cluster, the high availability cluster resources are in a failed state while the VMs are removed. The workaround for this issue is to manually remove the failed resources.

## Attempt to create new workload clusters failed because the AKS host was turned off for several days
An AKS on Azure Stack HCI cluster deployed in an Azure VM was previously working fine, but after the AKS host was turned off for several days, the `Kubectl` command did not work. After running either the `Kubectl get nodes` or `Kubectl get services` command, this error message appeared: _Error from server (InternalError): an error on the server ("") has prevented the request from succeeding_.

This issue occurred because the AKS host was turned off for longer than four days, which caused the certificates to expire. Certificates are frequently rotated in a four-day cycle. Run [Repair-AksHciClusterCerts](./reference/ps/repair-akshciclustercerts.md) to fix the certificate expiration issue.

## The API server is not responsive after several days
When attempting to bring up an AKS on Azure Stack HCI deployment after a few days, `Kubectl` did not execute any of its commands. The Key Management Service (KMS) plug-in log displayed the error message _rpc error:code = Unauthenticated desc = Valid Token Required_. After running [Repair-AksHciCerts](./reference/ps/repair-akshcicerts.md) to try to fix the issue, a different error appeared: _failed to repair cluster certificates_.

The `Repair-AksHciCerts` cmdlet fails if the API server is down. If AKS on Azure Stack HCI has not been upgraded for 60 or more days, when you try to restart the KMS plug-in, it won't start. This failure also causes the API server to fail.

To fix this issue, you need to manually rotate the token and then restart the KMS plug-in and container to get the API server back up. To do this, run the following steps:

1. Rotate the token by running the following command:

   ```
   $ mocctl.exe security identity rotate --name "KMSPlugin-<cluster-name>-moc-kms-plugin" --encode=false --cloudFqdn (Get-AksHciConfig).Moc.cloudfqdn > cloudlogin.yaml
   ```

2. Copy the token to the VM using the following command. The `ip` setting in the command below refers to the IP address of the AKS host's control plane.

   ```
   $ scp -i (Get-AksHciConfig).Moc.sshPrivateKey .\cloudlogin.yaml clouduser@<ip>:~/cloudlogin.yaml $ ssh -i (Get-AksHciConfig).Moc.sshPrivateKey clouduser@<ip> sudo mv cloudlogin.yaml /opt/wssd/k8s/cloudlogin.yaml
   ```

3. Restart the KMS plug-in and the container. 

   To get the container ID, run the following command:

   ```
   $ ssh -i (Get-AksHciConfig).Moc.sshPrivateKey clouduser@<ip> "sudo docker container ls | grep 'kms'"
   ```

   The output should appear with the following fields:

   ```Output
   CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
   ``` 

   The output should look similar to this example:
   ```Output
   4169c10c9712 f111078dbbe1 "/kms-plugin" 22 minutes ago Up 22 minutes k8s_kms-plugin_kms-plugin-moc-lll6bm1plaa_kube-system_d4544572743e024431874e6ba7a9203b_1
   ```

4. Finally, restart the container by running the following command:

   ```
   $ ssh -i (Get-AksHciConfig).Moc.sshPrivateKey clouduser@<ip> "sudo docker container kill <Container ID>"
   ```

## When using kubectl to delete a node, the associated VM might not be deleted

You'll see this issue if you follow these steps:

1. Create a Kubernetes cluster.
2. Scale the cluster to more than two nodes.
3. Delete a node by running the following command: 
   ```powershell
   kubectl delete node <node-name>
   ```

4. Return a list of the nodes by running the following command:
   ```powershell
   kubectl get nodes
   ```
   The removed node isn't listed in the output.
5. Open a PowerShell with administrative privileges and run the following command:
   ```powershell
   get-vm
   ```
The removed node is still listed.

This failure causes the system not to recognize that the node is missing, and therefore, a new node will not spin up. 

## The workload cluster is not found 

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

## Hyper-V manager shows high CPU and/or memory demands for the management cluster (AKS host)
When you check Hyper-V manager, high CPU and memory demands for the management cluster can be safely ignored. They are usually related to spikes in compute resource usage when provisioning workload clusters. Increasing the memory or CPU size for the management cluster has not shown a significant improvement and can be safely ignored.

## Moving virtual machines between Azure Stack HCI cluster nodes quickly leads to VM startup failures
When using the cluster administration tool to move a VM from one node (Node A) to another node (Node B) in the Azure Stack HCI cluster, the VM may fail to start on the new node. After moving the VM back to the original node, it will fail to start there as well.

This issue happens because the logic to clean up the first migration runs asynchronously. As a result, Azure Kubernetes Service's "update VM location" logic finds the VM on the original Hyper-V on node A, and deletes it, instead of un-registering it.

To work around this issue, ensure the VM has started successfully on the new node before moving it back to the original node.

## New-AksHciCluster times out when creating an AKS cluster with 200 nodes 
The deployment of a large cluster may time out after two hours, however, this is a static time-out. You can ignore this time out occurrence as the operation is running in the background. Use the `kubectl get nodes` command to access your cluster and monitor the progress.

## When using large clusters, the Get-AksHciLogs command may fail with an exception
With large clusters, the `Get-AksHciLogs` command may throw an exception, fail to enumerate nodes, or won't generate the c:\wssd\wssdlogs.zip output file. This is because the PowerShell command to zip a file, Compress-Archive, has an output file size limit of 2GB. 

## The Windows or Linux node count cannot be seen when Get-AksHciCluster is run
If you provision an AKS cluster on Azure Stack HCI with zero Linux or Windows nodes, when you run [Get-AksHciCluster](./reference/ps/get-akshcicluster.md), you will get an empty string or null value as your output.

## Attempt to increase the number of worker nodes fails
When using PowerShell to create a cluster with static IP and then attempt to increase the number of worker nodes in the workload cluster, the installation got stuck at _control plane count at 2, still waiting for desired state: 3_. After a period of time, another error message appears: _Error: timed out waiting for the condition_.

When [Get-AksHciCluster](./reference/ps/get-akshcicluster.md) was run, it showed that the control plane nodes were created and provisioned and were in a _Ready_ state. However, when `kubectl get nodes` was run, it showed that the control plane nodes had been created but not provisioned and were not in a _Ready_ state.

If you get this error, verify that the IP addresses have been assigned to the created nodes using either Hyper-V Manager or PowerShell:

```powershell
(Get-VM |Get-VMNetworkAdapter).IPAddresses |fl
```
Then, verify the network settings to ensure there are enough IP addresses left in the pool to create more VMs.  

## When running `kubectl get pods`, pods were stuck in a _Terminating_ state
When deploying AKS on Azure Stack HCI, and then running `kubectl get pods`, pods in the same node are stuck in the _Terminating_ state. The machine rejects SSH connections because the node was likely experiencing a lot of memory demand. This issue occurs because the Windows nodes are over-provisioned, and there's no reserve for core components. 

To avoid this situation, add the resource limits and resource requests for CPU and memory to the pod specification to ensure that the nodes aren't over-provisioned. Windows nodes don't support eviction based on resource limits, so you should estimate how much the containers will use and then ensure the nodes have sufficient CPU and memory amounts. You can find more information in [system requirements](system-requirements.md).

## Running the Remove-ClusterNode command evicts the node from the failover cluster, but the node still exists
When running the [Remove-ClusterNode](/powershell/module/failoverclusters/remove-clusternode?view=windowsserver2019-ps&preserve-view=true) command, the node is evicted from the failover cluster, but if [Remove-AksHciNode](./reference/ps/remove-akshcinode.md) is not run afterwards, the node will still exist in CloudAgent.

Since the node was removed from the cluster, but not from CloudAgent, if you use the VHD to create a new node, a _File not found_ error appears. This issue occurs because the VHD is in shared storage, and the evicted node does not have access to it.

To resolve this issue, remove a physical node from the cluster and then follow the steps below:

1. Run `Remove-AksHciNode` to de-register the node from CloudAgent.
2. Perform routine maintenance, such as re-imaging the machine.
3. Add the node back to the cluster.
4. Run `Add-AksHciNode` to register the node with CloudAgent.

## When running Get-AksHciCluster, a _release version not found_ error occurs
When running [Get-AksHciCluster](./reference/ps/get-akshcicluster.md) to verify the status of an AKS on Azure Stack HCI installation in Windows Admin Center, the output shows an error: _A release with version 1.0.3.10818 was NOT FOUND_. However, when running [Get-AksHciVersion](./reference/ps/get-akshciversion.md), it showed the same version was installed. This error indicates that the build is expired. To resolve this issue, run `Uninstall-AksHci`, and then run a new AKS on Azure Stack HCI build.

## When creating a new workload cluster, the error _Error: rpc error: code = DeadlineExceeded desc = context deadline exceeded_ occurs

This is a known issue with the AKS on Azure Stack HCI July Update (version 1.0.2.10723). The error _Error: rpc error: code = DeadlineExceeded desc = context deadline exceeded_ occurs because the CloudAgent service times out during distribution of virtual machines across multiple cluster shared volumes in the system. 

To resolve this issue, you should [upgrade to the latest AKS on Azure Stack HCI release](update-akshci-host-powershell.md#update-the-aks-on-azure-stack-hci-host).

## Creating a workload cluster fails with the error `A parameter cannot be found that matches parameter name 'nodePoolName'`

On an AKS on Azure Stack HCI installation with the Windows Admin Center extension version 1.82.0, the management cluster was set up using PowerShell, and an attempt was made to deploy a workload cluster using Windows Admin Center. One of the machines had PowerShell module version 1.0.2 installed, and other machines had PowerShell module 1.1.3 installed. The attempt to deploy the workload cluster failed with the error _A parameter cannot be found that matches parameter name 'nodePoolName'_. This error may have occurred because of a version mismatch. Starting with PowerShell version 1.1.0, the `-nodePoolName <String>` parameter was added to the [New-AksHciCluster](./reference/ps/new-akshcicluster.md) cmdlet, and by design, this parameter is now mandatory when using the Windows Admin Center extension version 1.82.0.

To resolve this issue, do one of the following:

- Use PowerShell to manually update the workload cluster to version 1.1.0 or later.
- Use Windows Admin Center to update the cluster to version 1.1.0 or to the latest PowerShell version.

This issue does not occur if the management cluster is deployed using Windows Admin Center as it already has the latest PowerShell modules installed.

## PowerShell deployment doesn't check for available memory before creating a new workload cluster

The **Aks-Hci** PowerShell commands do not validate the available memory on the host server before creating Kubernetes nodes. This issue can lead to memory exhaustion and virtual machines that do not start. This failure is currently not handled gracefully, and the deployment will stop responding with no clear error message. If you have a deployment that stops responding, open Event Viewer and check for a Hyper-V-related error message indicating there's not enough memory to start the VM.

## Next steps
- [Troubleshooting overview](troubleshoot-overview.md)
- [Networking issues and errors](known-issues-networking.md)
- [storage known issues](known-issues-storage.md)