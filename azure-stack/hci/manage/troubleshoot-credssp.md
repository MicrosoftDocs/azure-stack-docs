---
title: Troubleshoot CredSSP
description: Learn how to troubleshoot CredSSP
author: v-dasis
ms.topic: how-to
ms.date: 07/27/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Troubleshoot CredSSP

> Applies to Azure Stack HCI, version v20H2

Some Windows PowerShell scripts for Azure Stack HCI use Windows Remote Management (WinRM), which does not allow credential delegation by default. To allow delegation, the computer needs to have Credential Security Support Provider (CredSSP) enabled temporarily. CredSSP is a security support provider that allows a client to delegate credentials to a target server for remote authentication. Enabling CredSSP is a degraded security posture, and in most circumstances should be disabled after the task or operation is completed.

Some tasks that require CredSSP to be enabled include:

- Create cluster wizard workflow
- Active Directory queries or updates
- SQL server queries or updates
- Locating accounts or computers on a different domain or non-domain joined environment

If you experience issues with CredSSP, the following troubleshooting tips may help:

- When running the Create cluster wizard, CredSSP may report an issue if an Active Directory trust isn't established or is broken. This results when workgroup-based servers are used for cluster creation. In this case, try manually restarting each server in the cluster.

- When running Windows Admin Center on a server (service mode), make sure the user account is a member of the local Administrators group.

- To enable or disable CredSSP on a particular server, make sure you belong to the local Administrators group on that computer.

## Next steps

For more information on CredSSP, see [Credential Security Support Provider](https://docs.microsoft.com/windows/win32/secauthn/credential-security-support-provider).