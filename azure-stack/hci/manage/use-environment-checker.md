---
title: Assess deployment readiness by using Environment Checker
description: How to use the Environment Checker to assess if your environment is ready for deploying Azure Stack HCI.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/15/2022
---

# Assess your environment for deployment readiness

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article describes how to use the Azure Stack HCI Environment Checker to assess how ready your environment is for deploying the Azure Stack HCI solution.

For a smooth deployment of the Azure Stack HCI solution, your IT environment must meet certain requirements for connectivity, hardware, networking, and Active Directory. The Azure Stack HCI Environment Checker is a readiness assessment tool that checks these minimum requirements and helps determine if your IT environment is deployment ready.

> [!IMPORTANT]
> The Environment Checker for Azure Stack HCI is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## About the Environment Checker tool

The Environment Checker tool runs a series of tests on each server in your Azure Stack HCI cluster, reports the result for each test, provides remediation guidance when available, and saves a log file and a detailed report file.

The Environment Checker comprises several validators:

- **Connectivity validator.** Checks whether each server in the cluster meets the [connectivity requirements](../concepts/firewall-requirements.md?tabs=allow-table#firewall-requirements-for-outbound-endpoints). For example, each server in the cluster has internet connection and can connect via HTTPS outbound traffic to well-known Azure endpoints through all firewalls and proxy servers.
- **Hardware validator.** Checks whether your hardware meets the [system requirements](../concepts/system-requirements.md). For example, all the servers in the cluster have the same manufacturer and model.
- **Active Directory validator.** Checks whether the Active Directory preparation tool is run prior to running the deployment.
- **Network validator.** Validates your network infrastructure for valid IP ranges provided by customers for deployment. For example, it checks there are no active hosts on the network using the reserved IP range.

The Environment Checker comes built-in with the Azure Stack HCI Deployment Tool. By default, the Deployment Tool runs all the validators to perform the pre-deployment readiness checks. It runs the connectivity validator at the time of bootstrapping and rest of the validators before the actual deployment starts.

The Environment Checker also comes as a standalone tool, which you can run anytime, independent of the Deployment Tool. For example, you can run it even before receiving the actual hardware to check if all the connectivity requirements are met. It's a light-weight PowerShell tool that you can download for free from the Windows PowerShell gallery. You can also run it from any computer on the network where you'll deploy Azure Stack HCI.

This article describes how to run the Environment Checker in a standalone mode.

## Why use Environment Checker?

By running the Environment Checker tool, you can:

- Identify the issues that could potentially block the deployment, such as not running a pre-deployment Active Directory script.
- Confirm that the minimum requirements are met.
- Identify and remediate small issues early and quickly, such as a misconfigured firewall URL or a wrong DNS.
- Identify and remediate discrepancies on your own and ensure that your current environment configuration complies with the [Azure Stack HCI system requirements](/azure-stack/hci/concepts/system-requirements).
- Work with the support team more effectively in troubleshooting any advanced issues.
- Ensure that your Azure Stack HCI infrastructure is ready before deploying any future updates or upgrades.

## Prerequisites

Before you begin, complete the following tasks:

- Review [Azure Stack HCI system requirements](/azure-stack/hci/concepts/system-requirements).
- Review [Firewall requirements for Azure Stack HCI](/azure-stack/hci/concepts/firewall-requirements?tabs=allow-table).
- Make sure you have access to a client computer that is running on the network where you'll deploy the Azure Stack HCI cluster.
- Install the Environment Checker tool in PowerShell by following the steps in [Install and import Environment Checker](#install-and-import-environment-checker), below.
- Make sure you have permissions to verify the Active Directory preparation tool is run.

## Install and import Environment Checker

The Environment Checker tool works with PowerShell 5.1, which is built into Windows.

To install and import the Environment Checker on the client computer, follow these steps:

1. Run PowerShell as administrator (5.1 or later). If you need to install PowerShell, see [Installing PowerShell on Windows](/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2&preserve-view=true).

1. Enter the following cmdlet to install the latest version of the PowerShellGet module:

   ```powershell
   Install-Module PowerShellGet -AllowClobber -Force
   ``` 

1. After the installation completes, close the PowerShell window and open a new PowerShell session as administrator.

1. In the new PowerShell session, register PowerShell gallery as a trusted repo:

   ```powershell
   Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
   ```

1. In a browser, go to [AzStackHci.EnvironmentChecker](https://www.powershellgallery.com/packages/AzStackHci.EnvironmentChecker/0.1.0-preview) in the PowerShell Gallery.

1. On the **Install Module** tab, select the **Copy** icon to copy the Install-Module command that installs `AzStackHci.EnvironmentChecker`.

1. Paste in the command at the PowerShell command prompt, and press **Enter**.

1. When prompted, press **Y** (Yes) or **A** (Yes to All) to install the module.

1. Enter the following cmdlet to import the Environment Checker module:

   ```powershell
   Import-Module AzStackHci.EnvironmentChecker
   ```

## Run readiness checks

Each validator in the Environment Checker tool checks specific settings and requirements. You can run these validators by invoking their respective PowerShell cmdlet on each server in your Azure Stack HCI cluster or from any computer on the network where you'll deploy Azure Stack HCI.

Select each of the following tabs to learn more about the corresponding validator.

### [Connectivity](#tab/connectivity)

Use the connectivity validator to check if all the servers in your cluster have internet connectivity and meet the minimum connectivity requirements. For connectivity prerequisites, see [Firewall requirements for Azure Stack HCI](/azure-stack/hci/concepts/firewall-requirements?tabs=allow-table).

You can use the connectivity validator to:

- Check the connectivity of your servers before receiving the actual hardware. You can run the connectivity validator from any client computer on the network where you'll deploy the Azure Stack HCI cluster.
- Check the connectivity of all the servers in your cluster after you've deployed the cluster using the Deployment Tool. You can check the connectivity of each server by running the validator cmdlet locally on each server. Or, you can remotely connect from a staging server to check the connectivity of one or more servers.

### Run the connectivity validator

To run the connectivity validator, follow these steps.

1. Open PowerShell on a client computer running on the network where you'll deploy the Azure Stack HCI.

1. Run a connectivity readiness check by entering the following cmdlet:

   ```powershell
   Invoke-AzStackHciConnectivityValidation 
   ```
   > [!NOTE]
   > Using the `Invoke-AzStackHciConnectivityValidation` cmdlet without any parameter checks connectivity for all the service endpoints that are enabled from your device. You can also pass parameters to run readiness checks for specific scenarios. See [Examples](#examples), below.

### Examples

Here are some examples of running the connectivity validator cmdlet with parameters.
 
#### Example 1: Check connectivity of a remote computer

In this example, you remotely connect from a staging server to check the connectivity of one or more servers.

```powershell
$session = New-PSSession -ComputerName remotesystem.contoso.com -Credential $credential
Invoke-AzStackHciConnectivityValidation -PsSession $Session
```

#### Example 2: Check connectivity for a specific service
 
You can check connectivity for a specific service endpoint by passing the `Service` parameter. In the following example, the validator checks connectivity for Azure Arc service endpoints.

```powershell
Invoke-AzStackHciConnectivityValidation -Service Arc
```
 
#### Example 3: Check connectivity if you're using a proxy

If you're using a proxy server, you can specify the connectivity check to go through the specified proxy and credentials, as shown in the following example:

```powershell
Invoke-AzStackHciConnectivityValidation -Proxy http://proxy.contoso.com:8080 -ProxyCredential $proxyCredential 
```

### Connectivity validator output

The following samples are the output from successful and unsuccessful runs of the connectivity validator.

To learn more about different sections in the readiness check report, see [Understand readiness check report](#understand-readiness-check-report).

**Sample output: Successful test**

The following sample is the output from a successful run of the connectivity validator. The output indicates a healthy connection to all the endpoints, including well-known Azure services and observability services. Under **Diagnostics**, you can see the validator checks if a DNS server is present and healthy. It collects WinHttp, IE proxy, and environment variable proxy settings for diagnostics and data collection. It also checks if a transparent proxy is used in the outbound path and displays the output.

   :::image type="content" source="./media/environment-checker/connectivity-validator-sample-passed.png" alt-text="Screenshot of a passed report after running the connectivity validator." lightbox="./media/environment-checker/connectivity-validator-sample-passed.png":::

**Sample output: Failed test**

If a test fails, the connectivity validator returns information to help you resolve the issue, as shown in the sample output below. The **Needs Remediation** section displays the issue that caused the failure. The **Remediation** section lists the relevant article to help remediate the issue.

   :::image type="content" source="./media/environment-checker/connectivity-validator-sample-failed.png" alt-text="Screenshot of a failed report after running the connectivity validator." lightbox="./media/environment-checker/connectivity-validator-sample-failed.png":::

## [Hardware](#tab/hardware)

The hardware validator checks whether the servers and other hardware components meet the [system requirements](../concepts/system-requirements.md). For example, it checks if all physical servers in your cluster are configured uniformly and all hardware components use the same versions of firmware and are operating as expected.

You can use the hardware validator at any step of the deployment—before starting the deployment (when you're still waiting to receive the actual hardware), during deployment, or after deployment.

Refer to the following table for a description of the tests the hardware validator performs on different hardware component:

| **Source** | **Description of the test** | **Proposed action** |
| -------| ------------------------| --------------- |
| Processor | All processor for desired properties | Warning |
| Processor | All processor for consistent properties | Warning |
| Memory | All physical memory for consistent properties | Warning |
| Memory | All physical memory for desired properties | Warning |
| Network adapter | All network adapter for consistent properties | Fail |
| Network adapter | All network adapter for desired properties | Fail |
| Network adapter | All network adapter groups for consistent properties | Fail |
| GPU | Video controller for desired properties | Warning |
| Storage | PhysicalDisk count | Fail |
| Storage | PhysicalDisk for desired properties | Warning |
| Storage | PhysicalDisk Groups for consistent properties | Warning |
| Storage | No storage pools exist | Fail |
| Firmware | BIOS for desired properties | Warning |
| Firmware | Secure Boot enabled | Fail |
| Firmware | TPM for desired certificates | Warning/Fail |
| Firmware | TPM for desired properties | Warning/Fail |
| Firmware | TPM 2.0 | Fail |
| Firmware | Hyper-V Virtualization Enabled | Fail |

### Run the hardware validator

To run the hardware validator, follow these steps.

1. Open PowerShell on a client computer running on the network where you'll deploy the Azure Stack HCI. Or, open it locally on each server of the cluster.

1. Run the following cmdlet to invoke the hardware validator:

   ```powershell
   Invoke-AzStackHciHardwareValidation 
   ```

### Examples

Here are some examples of using the hardware validator.
 
### Example 1: Check hardware readiness of one or more remote servers

In this example, you remotely connect from a staging server to check hardware readiness of two servers.

```powershell
$remoteSession = New-PsSession CSSLAB2N0201,CSSLAB2N0202 -Credential (Get-Credential -Message 'Remote System Credential')
Invoke-AzStackHciHardwareValidation -PsSession $remoteSession
```

### Hardware validator output

The following samples are the output from successful and unsuccessful runs of the hardware validator.

To learn more about different sections in the readiness check report, see [Understand readiness check report](#understand-readiness-check-report).

**Sample output: Successful test**

The following sample is the output from a successful run of the hardware validator:

   :::image type="content" source="./media/environment-checker/hardware-validator-sample-passed.png" alt-text="Screenshot of a passed report after running hardware validator." lightbox="./media/environment-checker/hardware-validator-sample-passed.png":::

**Sample output: Failed test**

The following sample is the output from a failed run of the hardware validator:

This sample output indicates seven critical issues that you must fix before proceeding with the deployment. One server in the cluster doesn't have the same network adapters as others. Also, some of the network adapter properties in that server don't meet the minimum requirements.

   :::image type="content" source="./media/environment-checker/hardware-validator-sample-failed.png" alt-text="Screenshot of a failed report after running the hardware validator." lightbox="./media/environment-checker/hardware-validator-sample-failed.png":::

### [Active Directory](#tab/active-directory)

With Azure Stack HCI, version 22H2 (preview) release, you can use an Active Directory preparation tool to create group managed service accounts (gMSAs) and make them discoverable by deployment in a dedicated Organizational Unit (OU).

You can use the Active Directory validator to:

- Validate the Active Directory preparation tool is run and the gMSAs are set and groups are provisioned prior to starting the deployment.
- Assess any Active Directory issue during deployment. The support team can check the validator report logs to assess if you'd run the Active Directory preparation tool before deployment.

### Run the Active Directory validator

To run the Active Directory validator, follow these steps.

1. Ensure the following parameters are unique in the Active Directory per cluster instance:

   - Azure Stack HCI deployment user
   - Azure Stack HCI organization unit name
   - Azure Stack HCI deployment prefix (must be at the max eight characters)
   - Azure Stack HCI deployment cluster name
   - Physical nodes objects (if already created) must be available under nested computers organization unit

1. Run the following command in an elevated PowerShell session:

   ```powershell
   $params = @{
   ADOUPath = 'OU=Hci001,DC=contoso,DC=local'
   DomainFQDN = 'contoso.local'
   NamingPrefix = "hci"
   ActiveDirectoryServer = 'contoso.local'
   ActiveDirectoryCredentials = (Get-Credential -Message 'Active Directory Credentials')
   ClusterName = 'S-Cluster'
   }
   Invoke-AzStackHciExternalActiveDirectoryValidation @params
   ```

### Active Directory validator output

The following samples are the output from successful and unsuccessful runs of the Active Directory validator.

To learn more about different sections in the readiness check report, see [Understand readiness check report](#understand-readiness-check-report).

**Sample output: Successful test**

The following sample is the output from a successful run of the Active Directory validator. The output indicates that the specified OU exists and contains proper sub-OUs.

   :::image type="content" source="./media/environment-checker/ad-validator-sample-passed.png" alt-text="Screenshot of a passed report after running the Active Directory validator." lightbox="./media/environment-checker/ad-validator-sample-passed.png":::

**Sample output: Failed test**

The following sample is the output from a failed run of the Active Directory validator. The report indicates that the Active Directory tool hasn't been run and proper Organizational Unit (OU) isn't created.

   :::image type="content" source="./media/environment-checker/ad-validator-sample-failed.png" alt-text="Screenshot of another failed report after running the Active Directory validator." lightbox="./media/environment-checker/ad-validator-sample-failed.png":::

To remediate the blocking issues in this output, open the Active Directory tool and pass the following parameters:

```powershell
.\AsHciADArtifactsPreCreationTool.ps1 -AsHciDeploymentUserCredential (get-credential) -AsHciOUName "OU=Hci001,DC=contoso,DC=local,DC=stbtest,DC=microsoft,DC=com" -AsHciPhysicalNodeList @("Physical Machine1", "Physical Machine2") -DomainFQDN "'contoso.local " -AsHciClusterName "s-cluster" -AsHciDeploymentPrefix "Hci001"
```

### [Network](#tab/network)

It is possible that the IP addresses allocated to Azure Stack HCI may already be active on the network. The network validator validates your network infrastructure for valid IP ranges reserved for deployment. It attempts to ping and connect to WinRM and SSH ports to ensure there's no active host using the IP address from the reserved IP range.

### Run the network validator

To run the network validator, follow these steps.

1. Run the following cmdlet:

   ```powershell
   Invoke-AzStackHciNetworkValidation -StartingAddress <StartingIPRangeAddress> -EndingAddress <EndingIPRangeAddress>
   ```

### Network validator output

The following samples are the output from successful and unsuccessful runs of the network validator.

To learn more about different sections in the readiness check report, see [Understand readiness check report](#understand-readiness-check-report).

**Sample output: Successful test**

The following sample is the output from a successful run of the network validator. The output indicates no active host is using an IP address from the reserved IP range.

   :::image type="content" source="./media/environment-checker/network-validator-sample-passed.png" alt-text="Screenshot of a passed report after running the network validator." lightbox="./media/environment-checker/ad-validator-sample-passed.png":::

**Sample output: Failed test**

The following sample is the output from a failed run of the network validator. This output shows two active hosts are using IP address from the reserved IP range.

   :::image type="content" source="./media/environment-checker/network-validator-sample-failed.png" alt-text="Screenshot of a failed report after running the network validator." lightbox="./media/environment-checker/network-validator-sample-failed.png":::

---

### Understand readiness check report

Each validator generates a readiness check report after completing the check. Make sure to review the report and correct any issues before starting the actual deployment.

The information displayed on each readiness check report varies depending on the checks the validators perform. Refer to the following table for a description of different sections available in the readiness check reports for each validator:

| **Section** | **Description** | **Available in** |
| ------- | ----------- | ----------- |
| Services | Displays the health status of each service endpoint that the connectivity validator checks. Any service endpoint that fails the check is highlighted with the **Needs Remediation** tag.| Connectivity validator report|
| **Diagnostics** | Displays the result of the diagnostic tests. For example, the health and availability of a DNS server. It also shows what information the validator collects for diagnostic purposes, such as WinHttp, IE proxy, and environment variable proxy settings. | Connectivity validator report|
| Hardware | Displays the health status of all the physical servers and their hardware components. For information on the tests performed on each hardware, see the table under the "Hardware" tab in the [Run readiness checks](#run-readiness-checks) section. | Hardware validator report|
| **AD OU Diagnostics** | Displays the result of the Active Directory organization unit test. Displays if the specified organizational unit exists and contains proper sub-organizational units. | Active Directory validator report|
| Network range test | Displays the result of the network range test. If the test fails, it displays the IP addresses that belong to the reserved IP range. | Network validator report |
| **Summary** | Lists the count of successful and failed tests. Failed test results are expanded to show the failure details under **Needs Remediation**.| All reports |
| **Remediation** | Displays only if a test fails. Provides a link to the article that provides guidance on how to remediate the issue. | All reports |
| **Log location (contains PII)** | Provides the path where the log file is saved. The default path is:<br><br>- `$HOME\.AzStackHci\AzStackHciEnvironmentChecker.log` when you run the Environment Checker in a standalone mode.<br>- `C:\CloudDeployment\Logs` when the Deployment Tool runs the Environment Checker internally.<br><br>Each run of the validator overwrites the existing file.| All reports |
| **Report Location (contains PII)** | Provides the path where the completed readiness check report is saved in the JSON format. The default path is:<br><br>- `$HOME\.AzStackHci\AzStackHciEnvironmentReport.json` when you run the Environment Checker in a standalone mode.<br>- `C:\CloudDeployment\Logs` when the Deployment Tool runs the Environment Checker internally.<br><br> The report provides detailed diagnostics that are collected during each test. This information can be helpful for system integrators or when you need to contact the support team to troubleshoot the issue. Each run of the validator overwrites the existing file. | All reports |
| Completion message | At the end of the report, displays a message that the validation check is completed.| All reports|

## Environment Checker results

> [!NOTE]
> The results reported by the Environment Checker tool reflect the status of your settings only at the time that you ran it. If you make changes later, for example to your Active Directory or network settings, items that passed successfully earlier can become critical issues.

For each test, the validator provides a summary of the unique issues and classifies them into: success, critical issues, warning issues, and informational issues. Critical issues are the blocking issues that you must fix before proceeding with the deployment.

## Known issues and workarounds

We're aware of the following issues affecting the public preview version of the Azure Stack HCI Environment Checker tool:

**Issue.** The tool will only return the result for one remote system when you run the connectivity checker, even if you target multiple PsSessions.

**Workaround.** Run the cmdlet multiple times targeting a remote user session.

## Next steps

- Review the deployment checklist
- Contact Microsoft Support