---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 05/13/2024
---

## Step 3: Check the status of an update

To get the summary information about an update in progress, run the `Get-CauRun` cmdlet:

```PowerShell
Get-CauRun -ClusterName <SystemName>
```

Here's a sample output: <!--ASK-->

```output
RunId                   : <Run ID> 
RunStartTime            : 10/13/2024 1:35:39 PM 
CurrentOrchestrator     : NODE1 
NodeStatusNotifications : { 
Node      : NODE1 
Status    : Waiting 
Timestamp : 10/13/2024 1:35:49 PM 
} 
NodeResults             : { 
Node                     : NODE2 
Status                   : Succeeded 
ErrorRecordData          : 
NumberOfSucceededUpdates : 0 
NumberOfFailedUpdates    : 0 
InstallResults           : Microsoft.ClusterAwareUpdating.UpdateInstallResult[] 
}
```

You're now ready to perform the post-OS upgrade steps for your system.