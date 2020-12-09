---
title: Troubleshoot CredSSP
description: Learn how to troubleshoot CredSSP
author: v-dasis
ms.topic: how-to
ms.date: 12/10/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Troubleshoot CredSSP

> Applies to Azure Stack HCI, version v20H2

Some Azure Stack HCI operations use Windows Remote Management (WinRM), which doesn't allow credential delegation by default. To allow delegation, the computer needs to have Credential Security Support Provider (CredSSP) enabled temporarily. CredSSP is a security support provider that allows a client to delegate credentials to a target server for remote authentication. 

Enabling CredSSP is a degraded security posture, and in most circumstances should be disabled after the task or operation is completed.

Some tasks that require CredSSP to be enabled include:

- Create cluster wizard workflow
- Active Directory queries or updates
- SQL server queries or updates
- Locating accounts or computers on a different domain or non-domain joined environment

## Troubleshooting tips

If you experience issues with CredSSP, the following troubleshooting tips may help:

- Before running the Create cluster wizard, make sure that Windows Admin Center is running in service mode and that you are a member of the Administrators group on the management computer.

- When running the Create cluster wizard, CredSSP may report an issue if an Active Directory trust isn't established or is broken. This results when workgroup-based servers are used for cluster creation. In this case, try manually restarting each server in the cluster.

- When running Windows Admin Center on a server (service mode), make sure the user account is a member of the Gateway administrators group.

- To be able to enable or disable CredSSP on a server, make sure you belong to the Gateway administrators group on that computer. For more information, see the first two sections of [Configure User Access Control and Permissions](/windows-server/manage/windows-admin-center/configure/user-access-control#gateway-access-role-definitions).

## Next steps

For more information on CredSSP, see [Credential Security Support Provider](/windows/win32/secauthn/credential-security-support-provider).