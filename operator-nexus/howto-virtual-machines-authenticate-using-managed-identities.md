---
title: How to create virtual machines with managed identities and authenticate with a managed identity
description: Learn how to use system-assigned and user-assigned managed identities associated with Azure Operator Nexus virtual machines.
ms.service: azure-operator-nexus
ms.custom: azure-operator-nexus
ms.topic: how-to
ms.date: 10/23/2025
ms.author: omarrivera
author: g0r1v3r4
---

# How to create virtual machines with managed identities and authenticate with a managed identity

This guide explains how to create Azure Operator Nexus virtual machines (VM) with managed identities and how to authenticate using those identities.
The authentication using managed identities enables the ability to obtain access tokens without the need to manage credentials explicitly.

[!INCLUDE [virtual-machine-managed-identity-version-prereq](./includes/virtual-machine/howto-virtual-machines-managed-identities-version-prerequisites.md)]

[!INCLUDE [virtual-machine-managed-identity-options-explained](./includes/virtual-machine/howto-virtual-machines-managed-identity-options-explained.md)]

## Create a VM with the managed identity

[!INCLUDE [virtual-machine-prereq](./includes/virtual-machine/quickstart-prereq.md)]

- Ensure you have permissions to create managed identities and manage the role assignments in your Azure subscription.
- Ensure to create the VM with either a system-assigned or user-assigned managed identity.

Complete the [Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md) for deploying a Nexus virtual machine.

  - Before creating the virtual machine, you need to create the required networking resources.
    - **L3 isolation domain** - For network isolation and routing
    - **L3 network** - For VM connectivity
    - **Cloud Services Network (CSN)** - For external connectivity and proxy services

Review how to create virtual machines using one of the following deployment methods:

  - [Azure CLI](./quickstarts-virtual-machine-deployment-cli.md)
  - [Azure PowerShell](./quickstarts-virtual-machine-deployment-ps.md)
  - [ARM template](./quickstarts-virtual-machine-deployment-arm.md)
  - [Bicep](./quickstarts-virtual-machine-deployment-bicep.md)

### Associate managed identities at VM creation time

When creating an Operator Nexus VM with managed identities, you must assign either a system-assigned or user-assigned managed identity during VM creation.
Creating the VM with an associated managed identity enables the capabilities for the authentication method.
Although the VM resource can be updated to add or change the managed identity after creation, the VM must be recreated to enable managed identity support.
If you plan to use other authentication methods, such as using a service principal, you can create the VM without a managed identity.

> [!IMPORTANT]
> If you don't specify a managed identity when creating the VM, you can't enable managed identity support by updating the VM after provisioning.

[!INCLUDE [virtual-machine-howto-virtual-machines-environment-variables](./includes/virtual-machine/howto-virtual-machines-environment-variables.md)]

## Automate using cloud-init user data script

It's possible to pass in a cloud-init script to the VM during creation using the `--user-data-content` parameter (or the alias `--udc`).
The cloud-init script must be base64 encoded before passing it to the `--user-data-content "$ENCODED_USER_DATA"` parameter of the `az networkcloud virtualmachine create` command.
The cloud-init script runs during the VM's first boot and can be used to perform various setup tasks.

Ensure you complete the necessary setup for your chosen managed identity option before creating the VM such as assigning roles or permissions.
After the VM is created and boots, you can check the cloud-init logs to verify that the script completed successfully.
The cloud-init logs file is found at `/var/log/cloud-init-output.log`.
It's necessary to SSH into the VM to access the logs.

> [!NOTE]
> The previous `--user-data` parameter is deprecated and will be removed in a future release.
> Verify in the [`networkcloud` extension release history] for the latest updates.

> [!TIP]
> The cloud-init script runs only during the first boot of the VM.
> You can also authenticate with managed identities manually from inside the VM after creation and boot.

[!INCLUDE [virtual-machine-howto-virtual-machines-proxy-settings](./includes/virtual-machine/howto-virtual-machines-proxy-settings.md)]

[!INCLUDE [virtual-machine-howto-virtual-machines-authenticate-with-managed-identity](./includes/virtual-machine/howto-virtual-machines-authenticate-with-managed-identity.md)]

## Related articles

It might be useful to review the [troubleshooting guide](./troubleshoot-virtual-machines-arc-enroll-with-managed-identities.md) for common issues and pitfalls.

[!INCLUDE [contact-support](./includes/contact-support.md)]