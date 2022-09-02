---
title: Troubleshoot Azure Stack HCI version 22H2 (preview) deployment
description: Learn to troubleshoot Azure Stack HCI version 22H2 (preview)
author: dansisson
ms.topic: how-to
ms.date: 08/29/2022
ms.author: v-dansisson
ms.reviewer: alkohli
---

# Troubleshoot Azure Stack HCI version 22H2 deployment (preview) 

> Applies to: Azure Stack HCI, version 22H2 (preview)

For troubleshooting purposes, this article discusses how to rerun and reset deployment if you encounter issues during your deployment.

Also see [Known issues for version 22H2](/manage/preview-channel.md).

## Rerun deployment

To rerun the deployment if there is a failure, follow these steps:

1. Run PowerShell as administrator.

1. Change the directory to *C:\clouddeployment\setup*.

1. Run the following command on your first (staging) server: 
 
    ```powershell
    Invoke-CloudDeployment.ps1 -Rerun -Verbose
    ```
    
    This command should restart the deployment in verbose mode.


> [!NOTE]
> Depending on which step the deployment fails, you may have to use `Set-ExecutionPolicy bypass`.

## Reset deployment

You may have to reset your deployment if it is in a not recoverable state. For example, if it is an incorrect network configuration, or if rerun doesn't resolve the issue. In these cases, do the following:

1. Back up all your data first. The orchestrated deployment will always clean the drives used by Storage Spaces Direct in this preview release.
1. Remove the *ServerHCI.vhdx* file and replace it with a new *ServerHCI.vhdx* file that you've downloaded.
1. [Reinstall](deployment-tool-install-os.md) the Azure Stack HCI 22H2 operating system.

## Next steps

- [Collect log data](/manage/collect-logs.md) from your deployment.
- View [known issues](../known-issues-22h2.md) for Azure Stack HCI version 22H2.
