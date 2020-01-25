---
title: Validation report for Azure Stack Hub | Microsoft Docs
description: Use the Azure Stack Hub readiness checker report to review validation results.
author: sethmanheim

ms.topic: conceptual
ms.date: 01/07/2020
ms.author: sethm
ms.reviewer: unknown
ms.lastreviewed: 10/23/2018

---

# Azure Stack Hub validation report

Use the *Azure Stack Hub readiness checker* tool to run validations that support deployment and servicing of an Azure Stack Hub environment. The tool writes results to a .json report file. The report displays detailed and summarized data about the state of prerequisites for deployment of Azure Stack Hub. The report also displays information about secrets rotation for existing Azure Stack Hub deployments.  

## Where to find the report

When the tool runs, it logs results to **AzsReadinessCheckerReport.json**. The tool also creates a log named **AzsReadinessChecker.log**. The location of these files displays along with the validation results in PowerShell:

![run-validation](./media/azure-stack-validation-report/validation.png)

Both files persist the results of subsequent validation checks when run on the same computer. For example, the tool can be run to validate certificates, run again to validate Azure identity, and then a third time to validate registration. The results of all three validations are available in the resulting .json report.  

By default, both files are written to **C:\Users\username\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessCheckerReport.json**.  

- Use the `-OutputPath <path>` parameter at the end of the command line to specify a different report location.
- Use the `-CleanReport` parameter at the end of the command line to clear information about previous runs of the tool from **AzsReadinessCheckerReport.json**.

## View the report

To view the report in PowerShell, supply the path to the report as a value for `-ReportPath`. This command displays the contents of the report and identifies validations that do not yet have results.

For example, to view the report from a PowerShell prompt that is open to the location where the report is located, run the following command:

```powershell
Read-AzsReadinessReport -ReportPath .\AzsReadinessReport.json
```

The output is similar to the following example:

```shell
Reading All Validation(s) from Report C:\Contoso-AzsReadinessCheckerReport.json

############### Certificate Validation Summary ###############

Certificate Validation results not available.

############### Registration Validation Summary ###############

Azure Registration Validation results not available.

############### Azure Identity Results ###############

Test                          : ServiceAdministrator
Result                        : OK
AAD Service Admin             : admin@contoso.onmicrosoft.com
Azure Environment             : AzureCloud
Azure Active Directory Tenant : contoso.onmicrosoft.com
Error Details                 : 

############### Azure Identity Validation Summary ###############

Azure Identity Validation found no errors or warnings.

############### Azure Stack Hub Graph Validation Summary ###############

Azure Stack Hub Graph Validation results not available.

############### Azure Stack Hub ADFS Validation Summary ###############

Azure Stack Hub ADFS Validation results not available.

############### AzsReadiness Job Summary ###############

Index             : 0
Operations        : 
StartTime         : 2018/10/22 14:24:16
EndTime           : 2018/10/22 14:24:19
Duration          : 3
PSBoundParameters :
```

## View the report summary

To view a summary of the report, you can add the `-summary` parameter to the end of the PowerShell command. For example:

```powershell
Read-AzsReadinessReport -ReportPath .\Contoso-AzsReadinessReport.json -summary
```

The summary shows validations that do not have results, and indicates pass or fail for validations that are complete. The output is similar to the following example:

```shell
Reading All Validation(s) from Report C:\Contoso-AzsReadinessCheckerReport.json

############### Certificate Validation Summary ###############

Certificate Validation found no errors or warnings.

############### Registration Validation Summary ###############

Registration Validation found no errors or warnings.

############### Azure Identity Validation Summary ###############

Azure Identity Validation found no errors or warnings.

############### Azure Stack Hub Graph Validation Summary ###############

Azure Stack Hub Graph Validation results not available.

############### Azure Stack Hub ADFS Validation Summary ###############

Azure Stack Hub ADFS Validation results not available.
```

## View a filtered report

To view a report that is filtered on a single type of validation, use the **-ReportSections** parameter with one of the following values:

- Certificate
- AzureRegistration
- AzureIdentity
- Graph
- ADFS
- Jobs
- All  

For example, to view the report summary for certificates only, use the following PowerShell command line:

```powershell
Read-AzsReadinessReport -ReportPath .\Contoso-AzsReadinessReport.json -ReportSections Certificate - Summary
```
