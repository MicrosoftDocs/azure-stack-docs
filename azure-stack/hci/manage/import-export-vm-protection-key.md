---
title: Importing and exporting a VM guest state protection key
description: Learn about importing and exporting a VM guest state protection key on an Azure Stack HCI cluster.
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.reviewer: alkohli
ms.date: 11/03/2023
---

# Importing and exporting a VM guest state protection key

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes importing and exporting a VM guest state protection key on an Azure Stack HCI cluster.

A VM guest state protection key is used to protect the VM guest state, like the vTPM state, while at rest in storage. It is not possible to boot up a Trusted launch VM without the guest state protection key. The key is stored in a key vault in the Azure Stack HCI cluster where VM is located.

## Export Trusted launch VM from source cluster and import it to a target cluster

You can export the VM from a source cluster using [Export-VM (Hyper-V)]().

You can import the VM to the target cluster using [Import-VM (Hyper-V)]().

Use the following steps to transfer the VM guest state protection key from source to target cluster:

1. Log in to the key vault on the target Azure Stack HCI cluster:

   ```azurepowershell
   mocctl.exe security login --identity --loginpath C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\IgvmAgent\Credentials\AzureStackIgvmAgentMocStackIdentity.yaml
   ```

1. Create a master key in the target key vault:

   ```azurepowershell
   mocctl.exe security keyvault key create --location VirtualMachineLocation --group AzureStackHostAttestation --vault-name AzureStackTvmKeyVault --key-size 2048 --key-type RSA --name master
   ```

1. Download the PEM file:

   ```azurepowershell
   mocctl.exe security keyvault key download --name master  --file-path C:\master.pem --vault-name AzureStackTvmKeyVault
   ```

On the source Azure Stack HCI cluster:

1. Copy the PEM file from target cluster to source cluster.

1. Run the following cmdlet to determine the ID of the VM:

   ```azurepowershell
   (Get-VM  -Name <vmName>).vmid  
   ```

1. Log in to the key vault:

   ```azurepowershell
   mocctl.exe security login --identity --loginpath C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\IgvmAgent\Credentials\AzureStackIgvmAgentMocStackIdentity.yaml  
   ```

1. Export the VM guest state protection key for the VM:

   ```azurepowershell
   mocctl.exe security keyvault key export --vault-name AzureStackTvmKeyVault --name <vmID> --wrapping-pub-key-file C:\master.pem  --out-file C:\<vmID>.wrap  
   ```

On the target Azure Stack HCI cluster:

1. Copy the `vmID` and `vmID.wrap` file from the source cluster to the target cluster.

1. Import the VM guest state protection key for the VM.

   ```azurepowershell
   mocctl.exe security keyvault key import --key-file-path C:\<vmID>.wrap --name <vmID> --vault-name AzureStackTvmKeyVault --wrapping-key-name master --key-type AES --key-size 256
   ```

## Frequently Asked Questions

### Does Trusted launch for Azure Arc VMs support virtualization-based security (VBS)?

Trusted launch for Azure Arc VMs supports virtualization-based security (VBS). However, the guest operating system running in the VM must enable and make use of VBS.

### Which versions of Azure Stack HCI support Trusted launch for Azure Arc VMs?

Trusted launch for Azure Arc VMs is supported on Azure Stack HCI 23H2 and later.

## Troubleshooting

### How can I tell if all the host components required for Trusted launch for Azure Arc VMs are installed and working properly?

Trusted launch for Azure Arc VMs relies on Azure Arc and Azure Stack HCI services on the cloud side and some components on the host side.

The following components on the host side are required and should be running:

- Azure Arc resource bridge VM running on each node in the cluster.
- MOC NodeAgent service running on each node in the cluster.
- MOC Cloud Agent service running on a node in the cluster.
- IGVmAgent service running on each node in the cluster.

For instance, you can run `Get-Service IGVmAgent` to check if the IGVmAgent service is running.

### What to do if IGVmAgent is not installed on the nodes?

This is an unexpected situation. IGVmAgent should be installed as part of cluster setup. If this happens, try setting up the cluster again. If the problem persists, call Microsoft support.

### What can I do if IGVmAgent is running but not working as expected?

Run the following cmdlets to stop and then restart the IGVmAgent:

```azurepowershell
SC.exe stop IGVmAgent
```

```azurepowershell
SC.exe start IGVmAgent
```

If the problem persists, contact Microsoft support.

### How can I tell if the VM that I created is a "Trusted launch" VM?

"Trusted launch" is available only for Azure Arc managed VMs on Azure Stack HCI. Once an Arc VM with a security type of "Trusted launch" is created, view its VM properties to verify that the security type is "Trusted launch".

:::image type="content" source="media/import-export-vm-protection-key/verify-trusted-launch.png" alt-text="View VM properties to verify that the security type is "Trusted launch". lightbox="media/import-export-vm-protection-key/verify-trusted-launch.png":::

To verify "Trusted launch" VM status, you can also run the following Hyper-V command on the node where the VM is located:

```azurepowershell
(Get-VM <vmName>).GuestStateIsolationType 
```

On a "Trusted launch" VM, the command will return a value of “TrustedLaunch”.
