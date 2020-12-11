---
title: Troubleshoot CredSSP
description: Learn how to troubleshoot CredSSP
author: v-dasis
ms.topic: how-to
ms.date: 12/11/2020
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

- To use the Create Cluster wizard when running Windows Admin Center on a server instead of a PC, you must be a member of the Gateway Administrators group on the Windows Admin Center server. For more information, see [User access options with Windows Admin Center](/windows-server/manage/windows-admin-center/plan/user-access-options).

- When running the Create cluster wizard, CredSSP may report an issue if an Active Directory trust isn't established or is broken. This results when workgroup-based servers are used for cluster creation. In this case, try manually restarting each server in the cluster.

- When running Windows Admin Center on a server (service mode), make sure the user account is a member of the Gateway administrators group.

- We recommend running Windows Admin Center on a computer that is a member of the same domain as the managed servers.

- To be able to enable or disable CredSSP on a server, make sure you belong to the Gateway administrators group on that computer. For more information, see the first two sections of [Configure User Access Control and Permissions](/windows-server/manage/windows-admin-center/configure/user-access-control#gateway-access-role-definitions).

- Restarting the Windows Remote Management (WinRM) service on the servers in the cluster might prompt you to re-establish the WinRM connection between each cluster server and Windows Admin Center.

    One way to do this is by going to each cluster server, and in Windows Admin Center on the **Tools** menu, select **Services**, select **WinRM**, select **Restart**, and then on the **Restart Service** prompt, select **Yes**.

## Manual troubleshooting

If you receive the following error message, try using the manual verification steps in this section to resolve the error.

Example error message:

`Connecting to remote <sever name> failed with the following error message : The WinRM client cannot process the request. A computer policy does not allow the delegation of the user credentials to the target computer because the computer is not trusted. The identity of the target computer can be verified if you configure the WSMAN service to use a valid certificate.`

The manual verification steps in this section require you to configure the following computers:
- The computer running Windows Admin Center
- The primary target computer where you received the error message

To resolve the error, try the following remedy steps as needed:

**Remedy 1:**
1 Restart the computer running Windows Admin Center and the primary target computer.
1 Try running the Cluster creation wizard again.
For details on running the wizard, see [Create an Azure Stack HCI cluster using Windows Admin Center](../deploy/create-cluster.md)

**Remedy 2:**




## Next steps

For more information on CredSSP, see [Credential Security Support Provider](/windows/win32/secauthn/credential-security-support-provider).