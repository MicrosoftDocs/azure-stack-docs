---
title: Enable and Validate VNet Encryption with Azure Managed Lustre
description: Learn how to enable and test VNet encryption for the Azure Managed Lustre file system.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: brianl
ms.date: 07/18/2025
ms.lastreviewed: 07/21/2023
---

# Enable and Validate VNet Encryption with Azure Managed Lustre

Azure Managed Lustre (AMLFS) supports Virtual Network (VNet) Encryption, enabling encryption of data in transit between AMLFS and client virtual machines (VMs). This feature is  valuable for customers in regulated industries such as finance, healthcare, and government, where data confidentiality is paramount.

## How VNet Encryption Works

VNet Encryption in Azure uses Datagram Transport Layer Security (DTLS) 1.2 to secure traffic at the network layer. Key characteristics include:

- **Encryption Protocol**: DTLS 1.2 with AES-GCM-256 encryption.
- **Key Exchange**: Session keys are negotiated using ECDSA certificates.
- **Performance**: Encryption is offloaded to inline FPGAs on the VM host, ensuring high throughput and low latency.

## Enable VNet Encryption for AMLFS

To enable VNet Encryption with AMLFS:

1. **Enable VNet Encryption on the virtual network** where AMLFS is deployed.  
   Use the Azure CLI or portal to enable encryption on the VNet.  
   Example CLI command:

   ```bash
   az network vnet update --name <vnet-name> --resource-group <rg-name> --enable-encryption true
   ```

1. Ensure Client VM Compatibility
   Only specific VM series support VNet Encryption:

   - Dsv6-series  
   - Ebsv5-series  

   > [!IMPORTANT]  
   > Unsupported VMs do not encrypt traffic, even if the VNet is encrypted.  
   > Existing VMs must be rebooted for encryption to be enabled.

1. Deploy AMLFS into an Encrypted VNet
   You can deploy Azure Managed Lustre (AMLFS) into:

   - An encrypted VNet  
   - A peered VNet that also has encryption enabled  

   > [!NOTE]  
   > If you enable VNet Encryption on a VNet after deploying AMLFS, the cluster won't immediately support encrypted traffic.
   > Encryption capability is activated only after a maintenance event and cluster reboot.  
   > Refer to the AMLFS maintenance window documentation for guidance on scheduling and managing updates.

## Enforcement Mode

Azure currently supports only the `AllowUnencrypted` enforcement mode:

- Unencrypted traffic is still allowed, even when VNet Encryption is enabled.
- The stricter `DropUnencrypted` mode isn't generally available and requires special feature registration.

## Validate Encrypted Traffic

To confirm that traffic between AMLFS and client VMs is encrypted:

1. **Use Azure Network Watcher**  
   - Enable Network Watcher in the region.  
   - To inspect traffic headers, use packet capture on the client VM.  
   - Encrypted traffic shows DTLS encapsulation.

1. **Run Diagnostic Reports**  
   - Use Azure Monitor or custom scripts to validate encrypted traffic paths.  
   - Check VM metrics and logs for encryption status indicators.

1. **Check VM Capabilities**  
   Use the following command to verify if a VM supports VNet Encryption:

   ```bash
   az vm show --name <vm-name> --resource-group <rg-name> --query "storageProfile.osDisk.managedDisk.encryptionSettingsCollection"
   ```

     [!TIP]
    > For more information on verifying encryption, understanding performance impact, and managing certificate handling, see the #.

## Caveats and Limitations

- **Encryption enforcement**: AMLFS doesn't enforce encryption; it relies on the configuration of the VNet and VM.
- **Unsupported VMs**: Traffic from unsupported VM series remains unencrypted, even if VNet Encryption is enabled.
- **Firewall visibility**: Azure Firewall can't inspect traffic encrypted at the network layer.
- **Enforcement mode**: The `DropUnencrypted` mode isn't generally available (GA) and must be explicitly enabled via feature registration.
