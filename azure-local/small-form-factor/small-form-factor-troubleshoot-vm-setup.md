---
title: Troubleshoot VM setup
description: Learn how to troubleshoot virtual machine setup for small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: troubleshooting
ms.date: 10/28/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Troubleshoot VM setup

This article describes how to troubleshoot virtual machine (VM) setup for small form factor deployments of Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## The VM doesn't get an IP address

- Confirm the virtual machine (VM) uses the `HV-Internal-NAT` switch created by [`set-network.ps1`](https://github.com/Azure-Samples/AzureLocal/blob/main/small-form-factor/set-network.ps1).
- Confirm the host has internet connectivity.
- Rerun `set-network.ps1` from an elevated PowerShell session.

## The Configurator app can't connect

- Confirm the VM reached one of the success messages in the Hyper-V console.
- Use the IP address shown in the VM console.
- Confirm Windows Firewall or VPN settings aren't blocking local host-to-VM traffic.

## You need to debug from the VM console

For the normal flow, don't sign in to the VM console. If the setup fails or you need diagnostics, sign in with the maintenance environment credentials:

- Username: `edgeuser`
- Password: `Password1`

Use local console access only for troubleshooting. After the VM is successfully provisioned and the target OS is installed, use the SSH connection flow in [Connect a provisioned machine from the Azure portal](small-form-factor-connect-portal.md).

## Related content

- [Test small form factor deployments in a Hyper-V virtual machine](small-form-factor-vm-installation.md)
- [Troubleshoot management and connectivity](small-form-factor-troubleshoot.md)
