---
title: Troubleshoot Azure Stack HCI version 22H2 (preview) deployment
description: Learn to troubleshoot Azure Stack HCI version 22H2 (preview)
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Troubleshoot Azure Stack HCI version 22H2 (preview) deployment

> Applies to: Azure Stack HCI, version 22H2 (preview)

For troubleshooting purposes, this article discusses how to rerun and reset deployment if you encounter issues during your Azure Stack HCI 22H2 deployment.

Also see [Known issues for Azure Stack HCI version 22H2](deployment-tool-known-issues.md).

## Rerun deployment

To rerun the deployment in case of a failure, in PowerShell, run `Invoke-CloudDeployment.ps1` with the parameter `-rerun`.

Depending on which step the deployment fails, you may have to use `Set-ExecutionPolicy bypass`.

## Reset deployment

You may have to reset your deployment because it is in a not recoverable state, for example an incorrect network configuration, or rerun does not resolve the issue. In this case, do the following:

1. Back up all your data first. The orchestrated deployment will always clean the drives used by Storage Spaces Direct in this preview release.
1. Remove the *ServerHCI.vhdx* file and replace it with a new *ServerHCI.vhdx* file that you have downloaded.
1. [Reinstall](deployment-tool-install-os.md) the Azure Stack HCI 22H2 operating system.

## Next steps

- [Collect log data]() from your deployment
- View [known issues](deployment-tool-known-issues.md) for Azure Stack HCI version 22H2