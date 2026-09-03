---
title: What's new in multi-rack deployments of Azure Local?
description: Find out about the new features and enhancements in the latest multi-rack deployments release of Azure Local.
ms.topic: overview
author: ronmiab
ms.author: robess
ms.service: azure-local
ms.date: 08/20/2026
ms.subservice: multi-rack
---

# What's new in multi-rack deployments of Azure Local?

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article lists the features and improvements that are available in multi-rack deployments of Azure Local. The multi-rack release focuses on Azure Local virtual machine (VM) management, Azure Kubernetes Service (AKS) enabled by Azure Arc, networking, storage, security, and more.

<!-- Monikers below are placeholders while the multi-rack moniker set is finalized:
     Multi-rack 1.3 -> azloc-2606
     Multi-rack 1.4 -> azloc-2607
     Multi-rack 1.5 -> azloc-2608
-->

::: moniker range="=azloc-2608"

## Features and improvements in 1.5

<!-- TODO: Confirm exact 1.5 build/version string. -->

The July 2026 release of multi-rack deployments of Azure Local is version **1.5.0**. This release includes new features across AKS enabled by Azure Arc, Azure Local VMs, security, and storage validation, along with reliability improvements and bug fixes.

- **AKS enabled by Azure Arc**:

  - **Azure RBAC for Kubernetes authorization**: You can now use Azure role-based access control (RBAC) to authorize Kubernetes access on AKS enabled by Azure Arc clusters. Both admin and non-admin users are supported through `az aksarc get-credentials`.

  - **Automated GPU driver installation**: GPU drivers are now included in the operating system image and installed automatically at VM creation on GPU-enabled node pool VMs. You no longer need to manually install NVIDIA drivers on AKS worker nodes.

- **Kubernetes version support**: This release adds support for Kubernetes versions 1.35 and 1.36 for AKS enabled by Azure Arc.

- **Azure Local VMs**:

  - **Choose graceful shutdown or immediate power-off**: You can now choose between graceful shutdown and immediate power-off when you stop an Azure Local VM. Run `az stack-hci-vm stop` for a graceful shutdown, or add `--skip-shutdown` for an immediate power-off. This capability requires the `stack-hci-vm` Azure CLI extension version 1.14.5 or later. For more information, see [Supported VM operations](./multi-rack-virtual-machine-operations.md).

  - **Secondary NICs get IPs automatically on Static logical networks**: Secondary network interfaces (NICs) on a Static logical network (LNET) now automatically obtain their IP addresses from the platform. This capability supports both cold-add and hot-add scenarios. The DHCP service is managed by the platform; you don't need to deploy or operate a DHCP server. The primary NIC continues to use the static IP address and gateway assigned at VM creation.
  
    Multi-rack deployments support only static logical networks. Dynamic logical networks, which rely on a customer-managed DHCP server, aren't supported. For more information, see [Create network interfaces](./multi-rack-create-network-interfaces.md).

- **Security**:

  - **Customer-managed public key encryption for Azure Key Vault (API 2026-08-01-preview)**: You can now provide a public key that the cluster uses to encrypt secrets before they're stored in Azure Key Vault. You're responsible for managing the corresponding private key required to decrypt the secrets. For more information, see [Security concepts](./multi-rack-security.md).

- **Storage**:

  - **Pure FlashArray R5 controllers on Gen2 chassis (validated)**: Multi-rack deployments now support Pure FlashArray R5 controllers on the Gen2 chassis, validated with Purity 6.9.x and certified for full storage functionality.

  - **Purity 6.9.5 certified**: Purity 6.9.5 is now certified for multi-rack deployments running this release or later. If your arrays run Purity 6.5.11 or earlier, coordinate with Pure Storage to complete any required pre-upgrade actions before you upgrade.

::: moniker-end

::: moniker range="=azloc-2607"

## Features and improvements in 1.4

<!-- TODO: Confirm exact 1.4 build/version string. -->

The June 2026 release of multi-rack deployments of Azure Local is version **1.4.0**. This release adds new capabilities for logical networking, Azure Local VMs, GPU workloads, and update visibility, along with reliability improvements and bug fixes.

- **Networking**:

  - **Logical network default gateway (managed fabric)**: Logical networks (LNETs) now accept a default gateway in the LNET's route table, matching hyperconverged Azure Local behavior. This capability unblocks the Hybrid AKS enabled by Azure Arc CLI flow, which requires every LNET used for cluster creation to expose a default route. Existing LNETs without a default route are backfilled automatically after upgrade, with no user action required. For more information, see [Create logical network](./multi-rack-create-logical-networks.md).

- **Azure Local VMs**:

  - **Day-2 Azure Arc enrollment for existing VMs**: You can now enroll an existing Azure Local VM into Azure Arc after creation. Run `az stack-hci-vm update --name <name> --resource-group <rg> --enable-agent true`. No reboot or downtime is required. Day-2 Arc enrollment depends on the VM configuration agent being installed at VM creation time, which is the default. For more information, see [Create Azure Local VMs](./multi-rack-create-arc-virtual-machines.md).

  - **GPU passthrough (Discrete Device Assignment)**: You can now attach physical GPUs to multi-rack Azure Local VMs in passthrough mode (Discrete Device Assignment, or DDA) to enable accelerated compute workloads. Attach GPUs at VM creation or post-creation through Azure Resource Manager (ARM). From the Azure CLI, use `az stack-hci-vm create --gpus GpuDDA,0`. You're responsible for installing NVIDIA drivers inside the guest VM. For more information, see [Prepare GPUs for Azure Local instance](./multi-rack-gpu-preparation.md).

  - **Independent VM management updates**: VM management components can now be updated independently of the platform runtime, which reduces the frequency of full runtime upgrades. No customer action is required.

- **Update management**:

  - **Last successful runtime update timestamp visible in the Azure portal (API 2026-05-01-preview)**: The cluster resource now surfaces the last successful runtime version update timestamp in the Azure portal, so you can confirm when a runtime update last completed successfully.

::: moniker-end

::: moniker range="=azloc-2606"

## Features and improvements in 1.3

<!-- TODO: Confirm 1.3 build/version string and release month. -->

The May 2026 release of multi-rack deployments of Azure Local is version **1.3.0**. This release adds new features across Azure Local VMs, multi-tenancy, networking, the Azure portal experience, and edge credential management, along with reliability improvements and bug fixes.

- **Azure Local VMs**:

  - **Automatic live migration during platform runtime upgrades (GA)**: Multi-rack deployments now support automatic live migration of Arc-enabled Azure Local VMs during platform runtime upgrades. Eligible VMs migrate from the bare metal machine being upgraded to another available node with minimal service interruption (typically sub-second network cutover). Live migration is skipped for VMs that use SR-IOV or GPU devices, and for VMs that aren't running. When live migration isn't available, the VM is gracefully shut down and restarted on another available node. Availability zone requirements are respected during placement. For more information, see [Supported VM operations](./multi-rack-virtual-machine-operations.md).

- **Multi-tenancy**:

  - **Advanced capacity management with quotas and limits (Guardrails)**: You can now define cluster capacity through Guardrails, which you use to allocate resources and delegate operational responsibility across tenants.

- **Networking**:

  - **NAT gateway inbound rules as an Azure Resource Manager (ARM) child resource**: Inbound rules are now modeled in Azure Resource Manager (ARM) as a child resource of the NAT gateway. This change resolves the previous circular deletion dependency between network interface, NAT gateway, and virtual network subnet, so that resource-group deletion completes reliably. For more information, see [NAT gateway for multi-rack deployments](./multi-rack-nat-gateway-overview.md).

- **Azure portal**:

  - **Single cluster view experiences aligned with hyperconverged Azure Local (GA)**: The single-cluster view in the Azure portal now includes additional experiences, aligning multi-rack deployments with hyperconverged Azure Local. Newly available panes include:
    - **Settings > Configurations**: Billing & Telemetry
    - **Disk**
    - **VM network interfaces**
    - **Network security group**
    - **Compute resources**: VM images and logical networks

- **Edge credential management**:

  - **Cluster-local credential rotation**: Cluster-specific credential rotation is now handled locally on the cluster, providing the foundation for future bring-your-own key vault (BYOK) support. If you use Network Security Perimeter, ensure your Key Vault is an associated resource on the perimeter and inbound access rules allow subscription access. For more information, see [Security concepts](./multi-rack-security.md).

  - **Access Bridge resource (API 2026-01-01-preview)**: The Access Bridge resource enables scenarios such as bastion access to storage management interfaces.

::: moniker-end

## Related content

- [What are multi-rack deployments of Azure Local?](./multi-rack-overview.md)
