---
title: Enable and Validate VNet Encryption
description: Learn how to enable and test VNet encryption for the Azure Managed Lustre file system.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: brianl
ms.date: 07/18/2025
ms.lastreviewed: 07/21/2023
---

# Enable and validate VNet encryption with Azure Managed Lustre

Azure Managed Lustre supports [virtual network (VNet) encryption](/azure/virtual-network/virtual-network-encryption-overview), enabling encryption of data in transit between Managed Lustre and client virtual machines (VMs). This feature is  valuable for customers in regulated industries, such as finance, healthcare, and government, where data confidentiality is paramount.

## How VNet encryption works

VNet Encryption in Azure uses Datagram Transport Layer Security (DTLS) 1.2 to secure traffic at the network layer. Key characteristics include:

- **Encryption Protocol**: DTLS 1.2 with AES-GCM-256 encryption.
- **Key Exchange**: Session keys are negotiated using ECDSA certificates.
- **Performance**: Encryption is offloaded to inline field-programmable gate arrays (FPGAs) on the VM host to help ensure high throughput and low latency.

## Enable VNet Encryption for Managed Lustre

To enable VNet Encryption with Managed Lustre:

1. **Enable VNet Encryption on the virtual network** where Managed Lustre is deployed.  
   Use the Azure CLI or the Azure portal to enable encryption on the VNet.

   Example Azure CLI command:

   ```bash
   az network vnet update --name <vnet-name> --resource-group <rg-name> --enable-encryption true
   ```

1. Ensure Client VM Compatibility

   Azure only supports specific VM series for VNet Encryption. Unsupported VMs don't encrypt traffic, even if the VNet is encrypted. See [Azure Virtual Network encryption requirements](/azure/virtual-network/virtual-network-encryption-overview#requirements) for requirements and a list of VM SKUs that support encryption.

   Existing VMs must be rebooted for encryption to be enabled.

1. Deploy Managed Lustre into an Encrypted VNet

   You can deploy Managed Lustre into:

   - An encrypted VNet  
   - A peered VNet that also has encryption enabled  

   > [!NOTE]  
   > If you enable VNet Encryption on a VNet after deploying Managed Lustre, the cluster won't immediately support encrypted traffic.
   > Encryption capability is activated only after a maintenance event and cluster reboot.  
   > Refer to the Managed Lustre maintenance window documentation for guidance on scheduling and managing updates.

## Enforcement Mode

Azure currently supports only the [`AllowUnencrypted`](/azure/virtual-network/virtual-network-encryption-overview#limitations) enforcement mode:

- Unencrypted traffic is still allowed, even when VNet Encryption is enabled.
- The stricter `DropUnencrypted` mode isn't generally available and requires special feature registration.

## Validate Encrypted Traffic

To confirm that traffic between Managed Lustre and client VMs is encrypted:

1. **Use Azure Network Watcher**:

   - Enable Network Watcher in the region.  
   - To inspect traffic headers, use packet capture on the client VM.  
   - Encrypted traffic shows DTLS encapsulation.

1. **Run Diagnostic Reports**  
   - Use Azure Monitor or custom scripts to validate encrypted traffic paths.  
   - Check VM metrics and logs for [encryption status](/azure/network-watcher/vnet-flow-logs-overview?tabs=Americas#log-format) indicators.

1. **Check VM capabilities**:

   Use the following command to determine whether a VM supports VNet encryption:

   ```bash
   az vm show --name <vm-name> --resource-group <rg-name> --query "storageProfile.osDisk.managedDisk.encryptionSettingsCollection"
   ```

    > [!TIP]
    > For more information on verifying encryption, understanding performance impact, and managing certificate handling, see the [FAQ for Azure Virtual Network encryption](/azure/virtual-network/virtual-network-encryption-faq).

## Caveats and limitations

- **Encryption enforcement**: Managed Lustre doesn't enforce encryption; it relies on the configuration of the VNet and VM.
- **Unsupported VMs**: Traffic from unsupported VM series remains unencrypted, even if VNet Encryption is enabled.
- **Firewall visibility**: Azure Firewall can't inspect traffic encrypted at the network layer.
- **Enforcement mode**: The `DropUnencrypted` mode isn't generally available (GA) and must be explicitly enabled via feature registration.

## Related content

- [Azure Virtual Network encryption](/azure/virtual-network/virtual-network-encryption-overview)
- [Azure encryption of data in transit](/azure/security/fundamentals/encryption-overview#encryption-of-data-in-transit)
