---
title: Troubleshoot Azure Arc VM using collected files
description: Learn how to troubleshoot an Azure Arc VM using collected files. 
author: alkohli
ms.topic: how-to
ms.date: 07/19/2024
ms.author: alkohli
ms.reviewer: vlakshmanan
---

# Troubleshoot an Azure Arc VM using collected files

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

You can collect logs and other files to identify and troubleshoot issues with Arc virtual machines (VMs) in your Azure Stack HCI system.

## Collect files

 Use these files to gather key information before you contact Microsoft Support for more help.

## Collect logs when VM provisioning fails

Examine the following log files to investigate a VM provisioning failure.

### Windows VMs

The Windows Panther folder contains Windows setup, installation, and upgrade log files. This folder also includes logs for all scripts used to customize the VM.

| File              | Directory       | Description |
|-------------------|-----------------|-------------|
| Critical logs     | C:\ProgramData\mocguestagent\log\mocguestagent.log | sudo journalctl -u mocguestagent.service |
| Operational logs  | C:\ProgramData\mocguestagent\log\agent-log-0 | /opt/mocguestagent/log/agent-log-0 |

   Logs can be found at following location: C:\Windows\panther.

   - **SetupAct.log** - Contains information about setup actions during the installation.
   - **SetupErr.log** - Contains information about setup errors during the installation.
   - **SetupComplete.log** - Setupcomplete.cmd is custom scripts that run during or after the Windows Setup process. Logs from this execution go to setupComplete logs. SetupComplete.cmd for HCI includes enabling WinRM, enabling ssh, and installing Microsoft On-premises Cloud (MOC) guest agent.

1. Look in folder C:\Windows\Setup\Scripts to make sure scripts from ISO are copied there.

1. Collect Windows event logs from C:\Windows\System32\winevt\Logs\System.evtx.

### Linux VMs

Examine these log files to investigate a VM provisioning failure:

- **/var/log/cloud-init-output.log** - Captures the output from each stage of cloud-init when it runs.
- **/var/log/cloud-init.log** – A detailed log with debugging output, detailing each action taken.
- **/run/cloud-init** - Contains logs about how cloud-init decided to enable or disable itself, and what platforms/datasources were detected. These logs are most useful when trying to determine what cloud-init ran or didn't run.

## Collect guest logs

Collect guest logs to gather information on Arc VM issues before you contact Microsoft Support.

### Logs inside the VM

- Netlogon: C:\Windows\Debug\netsetup.log <br>
  Netlogon logs are used for domain join failure. If you don't see a domain join error, this log is optional.

- Extension logs: C:\ProgramData\GuestConfig\extension_logs

For more information, see [Active Directory domain join troubleshooting guidance](/troubleshoot/windows-server/active-directory/active-directory-domain-join-troubleshooting-guidance).

### MOC guest agent logs

MOC guest agent logs are useful when Arc VM provisioning fails with the following error:

`Could not establish HyperV connection for VM ID...`

Example error:

`{"code":"moc-operator virtualmachine serviceClient returned an error while reconciling: rpc error: code = Unknown desc = Could not establish HyperV connection for VM ID [E5BF0FC3-DB6D-40AA-BB46-DD94E4E0719A] within [900] seconds, error: [<nil>]","message":"moc-operator virtualmachine serviceClient returned an error while reconciling: rpc error: code = Unknown desc = Could not establish HyperV connection for VM ID [E5BF0FC3-DB6D-40AA-BB46-DD94E4E0719A] within [900] seconds, error: [<nil>]","additionalInfo":[{"type":"ErrorInfo","info":{"category":"Uncategorized","recommendedAction":"","troubleshootingURL":""}}]}`

Examine these guest agent log files:

| Log type          | Windows | Linux |
|-------------------|---------|-------|
| Critical logs     | C:\ProgramData\mocguestagent\log\mocguestagent.log | sudo journalctl -u mocguestagent.service |
| Operational logs  | C:\ProgramData\mocguestagent\log\agent-log-0 | /opt/mocguestagent/log/agent-log-0 |

## Next steps

- [Collect logs](./collect-logs.md).
