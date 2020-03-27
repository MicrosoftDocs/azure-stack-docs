---
title: Send Azure Stack Hub diagnostic logs to Azure using the privileged endpoint (PEP)
description: Learn how to send Azure Stack Hub diagnostic logs to Azure using the privileged endpoint (PEP).
author: justinha

ms.topic: article
ms.date: 03/05/2020
ms.author: justinha
ms.reviewer: shisab
ms.lastreviewed: 03/05/2020

---
# Send Azure Stack Hub diagnostic logs to Azure using the privileged endpoint (PEP)

You do not have to provide any target storage location when using this method. If **fromDate** and **toDate** parameters are not provided, then it defaults to last 4 hours from the time of execution. 

You can optionally specify **FilterByRole** or **FilterByResourceProvider** parameter to include only specific role or value-add RP logs. 

Here's an example script you can run using the PEP to collect logs on an integrated system. 


```powershell
$ipAddress = "<IP ADDRESS OF THE PEP VM>" # You can also use the machine name instead of IP address. 
 
$password = ConvertTo-SecureString "<CLOUD ADMIN PASSWORD>" -AsPlainText -Force 
$cred = New-Object -TypeName System.Management.Automation.PSCredential ("<DOMAIN NAME>\CloudAdmin", $password) 
 
$session = New-PSSession -ComputerName $ipAddress -ConfigurationName PrivilegedEndpoint -Credential $cred 
 
$fromDate = (Get-Date).AddHours(-8) # Optional. 
$toDate = (Get-Date).AddHours(-2) # Optional. Provide the time that includes the period for your issue 
 
Invoke-Command -Session $session {Send-AzureStackDiagnosticLog -FromDate $using:fromDate -ToDate $using:toDate} 
 
if ($session) { 
    Remove-PSSession -Session $session 
} 
```

## Parameter considerations 

* The **FromDate** and **ToDate** parameters can be used to collect logs for a particular time period. If these parameters aren't specified, logs are collected for the past four hours by default.

* Use the **FilterByNode** parameter to filter logs by computer name. For example:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByNode azs-xrp01
  ```

* Use the **FilterByLogType** parameter to filter logs by type. You can choose to filter by File, Share, or WindowsEvent. For example:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByLogType File
  ```

* Use the **FilterByResourceProvider** parameter to send diagnostic logs for value-add Resource Providers (RPs). The general syntax is:
 
  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvider <<value-add RP name>>
  ```
 
  To send diagnostic logs for IoT Hub: 

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvider IotHub
  ```
 
  To send diagnostic logs for Event Hubs:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvider eventhub
  ```
 
  To send diagnostic logs for Azure Stack Edge:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvide databoxedge
  ```

* Use the **FilterByRole** parameter to send diagnostic logs from VirtualMachines and BareMetal roles:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByRole VirtualMachines,BareMetal
  ```

* To send diagnostic logs from VirtualMachines and BareMetal roles, with date filtering for log files for the past 8 hours:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByRole VirtualMachines,BareMetal -FromDate (Get-Date).AddHours(-8)
  ```

* To send diagnostic logs from VirtualMachines and BareMetal roles, with date filtering for log files for the time period between 8 hours ago and 2 hours ago:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByRole VirtualMachines,BareMetal -FromDate (Get-Date).AddHours(-8) -ToDate (Get-Date).AddHours(-2)
  ```


## Next steps

[Use the privileged endpoint (PEP) to send Azure Stack Hub diagnostic logs](azure-stack-get-azurestacklog.md)
