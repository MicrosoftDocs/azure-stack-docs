---
title: Validate Datacenter Network Integration
titleSuffix: Azure Stack Hub
description: Learn how to use the Azure Stack Hub Readiness Checker to validate datacenter network integration for Azure Stack Hub.
author: sethmanheim
ms.topic: how-to
ms.date: 10/19/2021
ms.author: sethm
ms.reviewer: brhoug
ms.lastreviewed: 10/25/2021

# Intent: As an Azure Stack Hub operator, I want to use the Azure Stack Hub Readiness Checker to validate datacenter network integration for Azure Stack Hub.
# Keyword: azure stack hub readiness checker network

---


# Validate datacenter network integration for Azure Stack Hub

Use the Azure Stack Hub Readiness Checker tool (AzsReadinessChecker) to validate that your datacenter network is ready for deployment of Azure Stack Hub. Validate datacenter network integration before an Azure Stack Hub deployment.

The network validation in the readiness checker tool can be run in two different modes. Prior to receiving the Azure Stack Hub hardware, use the Appliance mode to validate the datacenter network readiness. The appliance mode requires the use of a physical server with hardware specifications listed later in this article. After the Azure Stack Hub hardware has arrived and connected to the datacenter network, use the HLH mode by running the Readiness Checker tool on the hardware lifecycle host of Azure Stack Hub. The HLH mode does not require additional hardware.

The readiness checker validates:

* Border connectivity
* Switch configuration
* DNS integration
* DNS forwarder
* Time server
* Microsoft Entra connectivity
* AD FS and Graph connectivity
* Duplicate IP address assignments

For more information about Azure Stack Hub datacenter integration, see [Network Integration Planning for Azure Stack](azure-stack-network.md).

## Get the readiness checker tool

Download the latest version of the Azure Stack Hub Readiness Checker tool (AzsReadinessChecker) from the [PowerShell Gallery](https://aka.ms/AzsReadinessChecker).

Download the latest version of the Posh-SSH module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/Posh-SSH).

## Get the virtual router image

The Azure Stack Hub Readiness Checker tool uses a virtual router image based on SONiC switch operating system. Download the latest version of the SONiC virtual switch image for Hyper-V at [https://aka.ms/azssonic](https://aka.ms/azssonic).

## Hardware prerequisites

The hardware requirements apply only to running the Readiness Checker in the Appliance mode.

The Readiness Checker tool can run on a hardware device that meets the following minimum requirements:

* A single x64 CPU with hardware virtualization capability
* 8 GB of RAM
* 64 GB of local storage
* The number and type of network interfaces equal to the number and type of border switch connections, for example 4 x SFP28 network ports
* Standard KVM input/output

Note that the number of network interfaces in the Readiness Checker device can be fewer than the number of border connections when using the BGP routing. Individual border connections are validated one at a time. Having four separate network interfaces provides the best experience. Refer to [Border connectivity](azure-stack-border-connectivity.md) for routing considerations.

## Software prerequisites

The software prerequisites apply to running the Readiness Checker in both the Appliance and the HLH mode.

The computer where the tool runs must have the following software in place:

* Windows Server 2019 or Windows Server 2016
* Hyper-V and the Hyper-V Management Tools features installed
* The latest version of the [Microsoft Azure Stack Hub Readiness Checker](https://aka.ms/AzsReadinessChecker) tool.
* The latest version of the [SONiC virtual switch image](https://aka.ms/azssonic).
* The latest version of the [Posh-SSH PowerShell module](https://www.powershellgallery.com/packages/Posh-SSH).
* The [deployment worksheet](azure-stack-deployment-worksheet.md) filled out and exported to the DeploymentData.json file.

## Validate datacenter network integration in the Appliance mode

1. Connect a physical device that meets the prerequisites directly to the border switch ports designated for Azure Stack Hub with the appropriate type of network cables and transceivers.

1. Open an administrative PowerShell prompt and then run the following command to initialize AzsReadinessChecker:

    ```powershell
    Import-Module Microsoft.AzureStack.ReadinessChecker
    ```

1. From the PowerShell prompt, run the following command to start validation. Specify the correct values for **-DeploymentDataPath** and **-VirtualRouterImagePath** parameters.

     ```powershell
     Invoke-AzsNetworkValidation -DeploymentDataPath C:\DeploymentData.json -VirtualRouterImagePath C:\sonic-vs.vhdx
     ```

1. After the tool runs, review the output. Confirm that the status is OK for all tests. If the status is not OK, review the details and the log file for additional information.

## Validate datacenter network integration in the HLH mode

1. Sign in to the HLH using the HLHAdmin account.

1. Open an administrative PowerShell prompt and then run the following command to initialize AzsReadinessChecker:

    ```powershell
    Import-Module Microsoft.AzureStack.ReadinessChecker
    ```

1. From the PowerShell prompt, run the following command to start validation. Specify the correct values for **-DeploymentDataPath** and **-VirtualRouterImagePath** parameters.

     ```powershell
     Invoke-AzsNetworkValidation -DeploymentDataPath C:\DeploymentData.json -VirtualRouterImagePath C:\sonic-vs.vhdx -HLH
     ```

1. After the tool runs, review the output. Confirm that the status is OK for all tests. If the status is not OK, review the details and the log file for additional information.

## Syntax

```powershell
Invoke-AzsNetworkValidation
    -DeploymentDataPath <String>
    [-RunTests <String[]>]
    [-SkipTests <String[]>]
    [-VirtualRouterImagePath <String>]
    [-DnsName <String>]
    [-MtuTestDestination <String>]
    [-CustomCloudArmEndpoint <Uri>]
    [-CustomUrl <Uri[]>]
    [-OutputPath <String>]
    [-CleanReport]
    [<CommonParameters>]
```

```powershell
Invoke-AzsNetworkValidation
    -DeploymentDataPath <String>
    [-VirtualRouterImagePath <String>]
    [-CustomCloudArmEndpoint <Uri>]
    [-VirtualSwitchName <String>]
    [-NoUplinksRequired]
    [-NetworkToTest <String>]
    [-HLH]
    [-OutputPath <String>]
    [-CleanReport]
    [<CommonParameters>]
```

## Parameters

### -CleanReport

Remove all previous progress and create a clean report.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomCloudArmEndpoint

Azure Resource Manager endpoint URI for custom cloud.

```yaml
Type: String
Parameter Sets: (All)
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomUrl

List of additional URLs to test.

```yaml
Type: String[]
Parameter Sets: Hub
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeploymentDataPath

Path to Azure Stack Hub deployment configuration file created by the Deployment Worksheet.

```yaml
Type: String
Parameter Sets: (All)
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DnsName

DNS name to resolve for the DNS test.

```yaml
Type: String
Parameter Sets: (All)
Position: Named
Default value: management.azure.com
Accept pipeline input: False
Accept wildcard characters: False
```

### -HLH

Indicates the HLH mode for the readiness checker.

```yaml
Type: SwitchParameter
Parameter Sets: HLH
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MtuTestDestination

DNS name or IP address for the network path MTU test.

```yaml
Type: String
Parameter Sets: Hub
Position: Named
Default value: go.microsoft.com
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkToTest

Allows to execute the test for only one of the networks. Default is to execute tests for the BMC and External networks.

```yaml
Type: String
Parameter Sets: HLH
Accepted values: BmcNetworkOnly, ExternalNetworkOnly
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoUplinksRequired

Indicate that the ping test on P2P interfaces should be skipped.

```yaml
Type: SwitchParameter
Parameter Sets: HLH
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath

Directory path for log and report output.

```yaml
Type: String
Parameter Sets: (All)
Position: Named
Default value: $env:TEMP\AzsReadinessChecker
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunTests

List of tests to run. Default is to run all tests.

```yaml
Type: String[]
Parameter Sets: Hub
Accepted values: LinkLayer, PortChannel, BorderUplink, IPConfig, BgpPeering, BgpDefaultRoute, DnsServer, PathMtu, TimeServer, SyslogServer, AzureEndpoint, AdfsEndpoint, Graph, DuplicateIP, DnsDelegation
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipTests

List of tests to skip. Default is to not skip any tests.

```yaml
Type: String[]
Parameter Sets: Hub
Accepted values: PortChannel, BorderUplink, IPConfig, BgpPeering, BgpDefaultRoute, DnsServer, PathMtu, TimeServer, SyslogServer, AzureEndpoint, AdfsEndpoint, Graph, DuplicateIP, DnsDelegation
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VirtualRouterImagePath

Full path to the sonic-vs.vhdx image.

```yaml
Type: String
Parameter Sets: (All)
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VirtualSwitchName

External Hyper-V Switch name on the HLH.

```yaml
Type: String
Parameter Sets: HLH
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## Report and log file

Each time validation runs, it logs results to **AzsReadinessChecker.log** and **AzsReadinessCheckerReport.json**. The location of these files appears with the validation results in PowerShell.

The validation files can help you share status before you deploy Azure Stack Hub or investigate validation problems. Both files persist the results of each subsequent validation check. The report gives your deployment team confirmation of the identity configuration. The log file can help your deployment or support team investigate validation issues.

By default, both files are written to
`C:\Users\<username>\AppData\Local\Temp\AzsReadinessChecker\`.

Use:

* `-OutputPath`: The *path* parameter at the end of the run command to specify a different report location.
* `-CleanReport`: The parameter at the end of the run command to clear AzsReadinessCheckerReport.json of previous report information. For more information, see [Azure Stack Hub validation report](azure-stack-validation-report.md).

## Validation failures

If a validation check fails, details about the failure appear in the PowerShell window. The tool also logs information to *AzsReadinessChecker.log*.

## Next steps

[View the readiness report](azure-stack-validation-report.md)  
[General Azure Stack Hub integration considerations](azure-stack-datacenter-integration.md)  
