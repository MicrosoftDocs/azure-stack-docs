---
title: Zero-Touch Provisioning for Azure Local (preview)
description: Learn about zero-touch provisioning for Azure Local (preview).
author: sipastak
ms.topic: concept-article
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Zero-touch provisioning for Azure Local (preview)

Zero-touch provisioning (ZTP) reduces the manual work required to claim, configure, and manage a physical device from Azure. Instead of configuring each device on-site, the device acquires a simple network connection and ARM identity through an ownership voucher, and then receives its final configuration through Azure.

This provisioning service uses the same core ideas described by the [FIDO Device Onboard (FDO) specification](https://fidoalliance.org/device-onboarding-overview/) and the same core technology as [simplified provisioning for Azure Local](../deploy/simplified-machine-provisioning.md).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Why zero-touch provisioning matters

Edge deployments often span stores, factories, branch offices, or other remote locations where skilled IT staff might not be available. Manual device setup at each location is slow, expensive, and inconsistent. ZTP shifts most of that work to Azure so that on-site staff can perform a few physical tasks while central IT teams manage configuration remotely.

ZTP helps with:

- **Scale**: Repeat a consistent provisioning flow across many devices and sites.
- **Reduced on-site expertise**: On-site staff can install media, connect power and network, and share the ownership voucher without needing deep Azure or infrastructure knowledge.
- **Security**: Azure validates the device identity before provisioning, reducing the risk of claiming the wrong device or sending configuration to an untrusted endpoint.
- **Late binding**: A device can be manufactured or prepared before the final customer, site, or management configuration is known.
- **Central management**: Azure becomes the control plane for site configuration, device state, and follow-on lifecycle operations.

## FDO concepts used by ZTP

[FIDO Device Onboard (FDO)](https://fidoalliance.org/device-onboarding-overview/) defines an onboarding model for securely connecting devices to their target management platform. The following FDO concepts are important for understanding Azure Local ZTP.

This article uses FDO terminology as a conceptual model. In the Azure Local preview, operators don't configure FDO clients, rendezvous services, or owner services directly. The user-visible workflow is the Azure Local provisioning flow: boot the maintenance environment, export an ownership voucher, upload it to Azure, and create a provisioned machine.

| Concept | Description |
|---|---|
| FDO client | Software and credentials on the device that let it prove its identity and participate in onboarding. |
| Ownership voucher | A cryptographic document that links a physical device to its digital identity. The owner uploads this voucher to the target platform to prove they're authorized to manage that device. |
| Rendezvous service | A directory-like service that helps a device discover the correct owner or management platform when it first comes online. |
| Owner platform | The cloud or management service that claims the device, authenticates it, and sends final configuration. |
| Secure onboarding channel | The mutually authenticated connection used to transfer configuration, credentials, and software instructions to the device. |

In a pure FDO flow, the device moves through a supply chain and the ownership voucher is transferred to the final owner. The owner then registers the voucher with the management platform and the device is redirected to that platform when it powers on. Azure Local uses those same concepts, with Azure acting as the central management plane for the provisioned machine.

## How ZTP works for Azure Local deployments

For Azure Local deployments, ZTP has two major phases:

1. **Local preparation** - Prepare the physical device, install the maintenance environment, and extract the ownership voucher.
1. **Azure provisioning** - Upload the ownership voucher to Azure, associate the device with an Azure Arc site, and let Azure complete provisioning.

The following diagram shows the high-level flow.

```text
Supported Azure Local device
    |
    | Boot from prepared USB media
    v
Maintenance environment
    |
    | Export ownership voucher
    v
Azure portal or CLI
    |
    | Create or select Azure Arc site
    | Upload ownership voucher
    | Configure installed OS and access settings
    v
Provisioned machine resource
    |
    | Azure validates ownership and completes onboarding
    v
Provisioned Azure Local device
```

### 1. Prepare the device locally

The local preparation phase gets the physical device into a bootstrap state. This phase is done by downloading the maintenance OS from the Azure portal, creating bootable USB media, booting the target device from that media, and waiting for the maintenance environment installation to complete.

The maintenance environment is a lightweight bootstrap environment. It's not the final workload operating system. Its job is to prepare the device for secure onboarding and make the ownership voucher available for upload to Azure.

For the step-by-step procedure, see [Machine installation](small-form-factor-installation.md).

### 2. Extract the ownership voucher

After the maintenance environment is installed, the device produces an ownership voucher. The ownership voucher is the proof that allows Azure to claim that specific machine. You can download the voucher by using the Configurator App, copy it from the USB drive, or retrieve it from the device over SSH or SCP.

Store ownership vouchers carefully. Anyone with access to a voucher might be able to attempt to claim the corresponding device to their Azure tenant. Treat vouchers as sensitive deployment artifacts and keep them in a secure, backed-up location until the device is registered. After the device is registered, delete them.

### 3. Create or select an Azure Arc site

An Azure Arc site represents the physical location where one or more devices are deployed, such as a store, factory, or branch office. The site is where Azure stores site-level provisioning context and groups related provisioned machines.

For more information about the Azure Local resource model, see [Azure Local resource overview](small-form-factor-resource-overview.md).

### 4. Upload the voucher and create the provisioned machine

When you upload the ownership voucher, Azure creates a provisioned machine resource for you to interact with and creates an entry in the global rendezvous server, which waits for seven days to hear from the physical device. After seven days, if Azure hasn't heard from the device, the entry is dropped from the rendezvous server.

The provisioned machine resource is the main management surface for the Azure Local device. It tracks state, exposes connection options, and supports lifecycle operations such as operating system install and reset.

### 5. Device connects to Azure

The maintenance environment has a built-in polling mechanism that pings the rendezvous server in Azure periodically to see if anyone has uploaded its associated ownership voucher. If it finds the voucher, it pulls down its desired configuration from Azure.

By default, the maintenance environment tries to connect over DHCP. If you need to connect in an environment that only supports static IP, requires a particular gateway IP, or has any other requirements where the out-of-box maintenance environment is failing to connect, you need to configure those settings on the device by using the Configurator App.

## Important concepts

**Ownership vouchers are one-time use.** After an ownership voucher is uploaded to the cloud to create a provisioned machine and that machine connects to Azure, the machine no longer polls to see if it has been claimed.

**A device can't be claimed in two places at once.** If you've already uploaded an ownership voucher for a device and haven't deleted its provisioned machine resource, you have to delete it before you can upload a new one and reconnect it. The ZTP service rejects any attempts to claim a device that it has already assigned to a provisioned machine.

**Anyone can prep a device for ZTP.** The real value of the ZTP feature comes from preparing many devices at scale, shipping them directly to site, then centrally managing them across many locations. However, to make it easier to spin up a quick test, the feature is designed so that anyone can install from a USB drive and achieve the same experience.

**The reset-os command makes a machine identical to a newly installed maintenance environment.** Calling reset-os on a provisioned machine redownloads and then installs the maintenance environment, but maintains the same persistent ARM identity of the provisioned machine. This is designed for scenarios where you want to wipe a device clean but continue to represent it with a persistent ARM resource.