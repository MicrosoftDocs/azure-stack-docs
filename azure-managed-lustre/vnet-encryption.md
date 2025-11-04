---
title: Enable and Validate Virtual Network Encryption
description: Learn how to enable and test virtual network (VNet) encryption for the Azure Managed Lustre file system.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: brianl
ms.date: 07/18/2025
ms.lastreviewed: 07/21/2023
---

# Enable and validate VNet encryption with Azure Managed Lustre

Azure Managed Lustre supports [virtual network (VNet) encryption](/azure/virtual-network/virtual-network-encryption-overview) to encrypt data in transit between Managed Lustre and client virtual machines (VMs). This feature is valuable for customers in regulated industries, such as finance, healthcare, and government, where data confidentiality is paramount.

## How VNet encryption works

VNet encryption in Azure uses Datagram Transport Layer Security (DTLS) 1.2 to secure traffic at the network layer. Key characteristics include:

- **Encryption Protocol**: DTLS 1.2 with AES-GCM-256 encryption.
- **Key Exchange**: Session keys are negotiated by using ECDSA certificates.
- **Performance**: Encryption is offloaded to inline field-programmable gate arrays (FPGAs) on the VM host to help ensure high throughput and low latency.

## Enable VNet encryption for Managed Lustre

To enable VNet encryption with Managed Lustre:

1. **Enable VNet encryption on the virtual network**:  To enable VNet encryption where Managed Lustre is deployed, use the Azure CLI or the Azure portal:

   Example Azure CLI command:

   ```bash
   az network vnet update --name <vnet-name> --resource-group <rg-name> --enable-encryption true
   ```

1. **Ensure client VM compatibility**: Azure supports only specific VM series for VNet encryption. Unsupported VMs don't encrypt traffic, even if the VNet is encrypted. For requirements and a list of VM SKUs that support encryption, see [Azure Virtual Network encryption requirements](/azure/virtual-network/virtual-network-encryption-overview#requirements).

   Existing VMs must be rebooted for encryption to be enabled.

1. **Deploy Managed Lustre to an encrypted VNet**: You can deploy Managed Lustre to:

   - An encrypted VNet  
   - A peered VNet that also has encryption enabled  

   > [!NOTE]  
   > If you enable VNet encryption on a VNet after you deploy Managed Lustre, the cluster doesn't immediately support encrypted traffic. Encryption capability is activated only after a maintenance event and cluster reboot. For guidance on scheduling and managing updates, see the Managed Lustre maintenance window documentation.

## Enforcement mode

Azure currently supports only [`AllowUnencrypted`](/azure/virtual-network/virtual-network-encryption-overview#limitations) enforcement mode:

- Unencrypted traffic is still allowed, even when VNet encryption is enabled.
- The stricter `DropUnencrypted` mode isn't generally available and requires special feature registration.

## Validate encrypted traffic

To confirm that traffic between Managed Lustre and client VMs is encrypted:

1. **Use Azure Network Watcher**.

   - Enable Network Watcher in the region.  
   - To inspect traffic headers, use packet capture on the client VM.  
   - Encrypted traffic shows DTLS encapsulation.

1. **Run diagnostic reports**.

   - Use Azure Monitor or custom scripts to validate encrypted traffic paths.  
   - Check VM metrics and logs for [encryption status](/azure/network-watcher/vnet-flow-logs-overview?tabs=Americas#log-format) indicators.

1. **Check VM capabilities**.

   Use the following command to determine whether a VM supports VNet encryption:

   ```bash
   az vm show --name <vm-name> --resource-group <rg-name> --query "storageProfile.osDisk.managedDisk.encryptionSettingsCollection"
   ```

   > [!TIP]
   > For more information on verifying encryption, understanding performance impact, and managing certificate handling, see the [FAQ for Azure Virtual Network encryption](/azure/virtual-network/virtual-network-encryption-faq).

## Caveats and limitations

- **Encryption enforcement**: Managed Lustre doesn't enforce encryption. It relies on the configuration of the VNet and VM.
- **Unsupported VMs**: Traffic from unsupported VM series remains unencrypted, even if VNet Encryption is enabled.
- **Firewall visibility**: Azure Firewall can't inspect traffic encrypted at the network layer.
- **Enforcement mode**: `DropUnencrypted` mode isn't generally available and must be explicitly enabled via feature registration.

## Related content

- [Azure Virtual Network encryption](/azure/virtual-network/virtual-network-encryption-overview)
- [Azure encryption of data in transit](/azure/security/fundamentals/encryption-overview#encryption-of-data-in-transit)
