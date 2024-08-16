---
title: Collect log files for Azure Arc VM on Azure Stack HCI
description: Learn how to collect log files for an Azure Arc VM on your Azure Stack HCI system. 
author: alkohli
ms.topic: how-to
ms.date: 08/16/2024
ms.author: alkohli
ms.reviewer: vlakshmanan
---

# Collect log files for Azure Arc VM on your Azure Stack HCI system

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

Collect logs and other files to identify and troubleshoot issues with Arc virtual machines (VMs) in your Azure Stack HCI system.

## Collect files when VM provisioning fails

 Use these files to gather key information about a VM provisioning failure before you contact Microsoft Support for more help.

### Windows VMs

The Windows Panther folder contains Windows setup, installation, and upgrade log files. This folder also includes logs for all scripts used to customize the VM.

| File              | Directory       | Description |
|-------------------|-----------------|-------------|
| agent-log-0 | C:\ProgramData\mocguestagent\log\ | Operational logs |
| SetupAct.log | C:\Windows\panther\ | Contains information about setup actions during the installation. |
| SetupErr.log | C:\Windows\panther\ | Contains information about setup errors during the installation. |
| SetupComplete.log | C:\Windows\panther\ | Contains custom scripts that run during or after the Windows Setup process. For HCI, includes enabling WinRM, enabling ssh, and installing Microsoft On-premises Cloud (MOC) guest agent. |
| Script files | C:\Windows\setup\scripts\ | Scripts from ISO |
| System.evtx | C:\Windows\system32\winevt\logs\ | Windows event logs |

### Linux VMs

Examine these log files to investigate a VM provisioning failure:

| File              | Directory       | Description |
|-------------------|-----------------|-------------|
| cloud-init-output.log | /var/log/ | Captures the output from each stage of cloud-init when it runs. |
| cloud-init.log | /var/log/ | A detailed log with debugging output, detailing each action taken. |
| log files | /run/cloud-init/ | Contains logs about how cloud-init decided to enable or disable itself, and what platforms/datasources were detected. These logs are most useful when trying to determine what cloud-init ran or didn't run. |

## Collect guest logs

Collect guest logs to gather information on Arc VM issues before you contact Microsoft Support.

### Logs inside the VM

Windows VM domain join and extension logs:

| File              | Directory       | Description |
|-------------------|-----------------|-------------|
| Netsetup.log | C:\Windows\debug\ | Netlogon logs are used for domain join failure. If you don't see  a domain join error, this log is optional. |
| Extension logs | C:\ProgramData\GuestConfig\extension_logs\ | Extension logs |

For more information, see [Active Directory domain join troubleshooting guidance](/troubleshoot/windows-server/active-directory/active-directory-domain-join-troubleshooting-guidance).

### MOC guest agent logs

MOC guest agent logs are useful when Arc VM provisioning fails with the following error:

`Could not establish HyperV connection for VM ID...`

Example error:

`{"code":"moc-operator virtualmachine serviceClient returned an error while reconciling: rpc error: code = Unknown desc = Could not establish HyperV connection for VM ID [E5BF0FC3-DB6D-40AA-BB46-DD94E4E0719A] within [900] seconds, error: [<nil>]","message":"moc-operator virtualmachine serviceClient returned an error while reconciling: rpc error: code = Unknown desc = Could not establish HyperV connection for VM ID [E5BF0FC3-DB6D-40AA-BB46-DD94E4E0719A] within [900] seconds, error: [<nil>]","additionalInfo":[{"type":"ErrorInfo","info":{"category":"Uncategorized","recommendedAction":"","troubleshootingURL":""}}]}`

#### Windows VMs

Examine these MOC guest agent log files:

| File              | Directory       | Description |
|-------------------|-----------------|-------------|
| mocguestagent.log | C:\ProgramData\mocguestagent\log\ | Critical logs |
| agent-log-0 | C:\ProgramData\mocguestagent\log\ | Operational logs |

#### Linux VMs

Examine these MOC guest agent log files:

| File              | Directory       | Description |
|-------------------|-----------------|-------------|
| mocguestagent.service  | sudo journalctl -u | Critical logs |
| agent-log-0 | /opt/mocguestagent/log/ | Operational logs |

## Next steps

- [Collect logs](./collect-logs.md).
