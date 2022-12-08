---
title: Use Azure Stack HCI Environment Checker to assess deployment readiness (preview)
description: How to use the Environment Checker to assess if your environment is ready for deploying Azure Stack HCI.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/19/2022
---

# Assess your environment for deployment readiness (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes how to use the Azure Stack HCI Environment Checker in a standalone mode to assess how ready your environment is for deploying the Azure Stack HCI solution.

For a smooth deployment of the Azure Stack HCI solution, your IT environment must meet certain requirements for connectivity, hardware, networking, and Active Directory. The Azure Stack HCI Environment Checker is a readiness assessment tool that checks these minimum requirements and helps determine if your IT environment is deployment ready.

[!INCLUDE [important](../../includes/hci-preview.md)]

## About the Environment Checker tool

The Environment Checker tool runs a series of tests on each server in your Azure Stack HCI cluster, reports the result for each test, provides remediation guidance when available, and saves a log file and a detailed report file.

The Environment Checker tool consists of the following validators:

- **Connectivity validator.** Checks whether each server in the cluster meets the [connectivity requirements](../concepts/firewall-requirements.md?tabs=allow-table#firewall-requirements-for-outbound-endpoints). For example, each server in the cluster has internet connection and can connect via HTTPS outbound traffic to well-known Azure endpoints through all firewalls and proxy servers.
- **Hardware validator.** Checks whether your hardware meets the [system requirements](../concepts/system-requirements.md). For example, all the servers in the cluster have the same manufacturer and model.
- **Active Directory validator.** Checks whether the Active Directory preparation tool is run prior to running the deployment.
- **Network validator.** Validates your network infrastructure for valid IP ranges provided by customers for deployment. For example, it checks there are no active hosts on the network using the reserved IP range.

## Why use Environment Checker?

You can run the Environment Checker to:

- Ensure that your Azure Stack HCI infrastructure is ready before deploying any future updates or upgrades.
- Identify the issues that could potentially block the deployment, such as not running a pre-deployment Active Directory script.
- Confirm that the minimum requirements are met.
- Identify and remediate small issues early and quickly, such as a misconfigured firewall URL or a wrong DNS.
- Identify and remediate discrepancies on your own and ensure that your current environment configuration complies with the [Azure Stack HCI system requirements](/azure-stack/hci/concepts/system-requirements).
- Work with the support team more effectively in troubleshooting any advanced issues.

## Environment Checker modes

You can run the Environment Checker in two modes:

- As a built-in tool: The Environment Checker functionality comes built-in with the Azure Stack HCI Deployment Tool. By default, the Deployment Tool runs all the validators to perform the pre-deployment readiness checks.

- As a standalone tool: It's a light-weight PowerShell tool that you can download for free from the Windows PowerShell gallery. You can run the standalone tool anytime, independent of the Deployment Tool. For example, you can run it even before receiving the actual hardware to check if all the connectivity requirements are met. You can also run it from any Windows server or client on the network where you'll deploy Azure Stack HCI.

This article describes how to run the Environment Checker in a standalone mode.

## Prerequisites

Before you begin, complete the following tasks:

- Review [Azure Stack HCI system requirements](/azure-stack/hci/concepts/system-requirements).
- Review [Firewall requirements for Azure Stack HCI](/azure-stack/hci/concepts/firewall-requirements?tabs=allow-table).
- Make sure you have access to a client computer that is running on the network where you'll deploy the Azure Stack HCI cluster.
- Make sure that the client computer used is running PowerShell 5.1 or later.
- Make sure you have permission to verify the Active Directory preparation tool is run.

## Install Environment Checker

The [Environment Checker](https://www.powershellgallery.com/packages/AzStackHci.EnvironmentChecker/) works with PowerShell 5.1, which is built into Windows.

To install the Environment Checker on the client computer, follow these steps:

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

1. Enter the following cmdlet to install the Environment Checker module:

   ```powershell
   Install-Module -Name AzStackHci.EnvironmentChecker -AllowPrerelease
   ```

1. If prompted, press **Y** (Yes) or **A** (Yes to All) to install the module.

## Run readiness checks

Each validator in the Environment Checker tool checks specific settings and requirements. You can run these validators by invoking their respective PowerShell cmdlet on each server in your Azure Stack HCI cluster or from any computer on the network where you'll deploy Azure Stack HCI.

You can run the validators from the following locations:  

- Locally from the Azure Stack HCI server node

- Remotely via PowerShell session  

- Locally from a workstation or a staging server

Select each of the following tabs to learn more about the corresponding validator.

### [Connectivity](#tab/connectivity)

Use the connectivity validator to check if all the servers in your cluster have internet connectivity and meet the minimum connectivity requirements. For connectivity prerequisites, see [Firewall requirements for Azure Stack HCI](/azure-stack/hci/concepts/firewall-requirements?tabs=allow-table).

You can use the connectivity validator to:

- Check the connectivity of your servers before receiving the actual hardware. You can run the connectivity validator from any client computer on the network where you'll deploy the Azure Stack HCI cluster.
- Check the connectivity of all the servers in your cluster after you've deployed the cluster using the Deployment Tool. You can check the connectivity of each server by running the validator cmdlet locally on each server. Or, you can remotely connect from a staging server to check the connectivity of one or more servers.

> [!NOTE]
> You can use the connectivity validator with Azure Stack HCI, version 21H2 installations also.

### Run the connectivity validator

To run the connectivity validator, follow these steps.

1. Open PowerShell locally on the Azure Stack HCI server, workstation, or a staging server.

1. Run a connectivity validation by entering the following cmdlet:

   ```powershell
   Invoke-AzStackHciConnectivityValidation 
   ```

   > [!NOTE]
   > Using the `Invoke-AzStackHciConnectivityValidation` cmdlet without any parameter checks connectivity for all the service endpoints that are enabled from your device. You can also pass parameters to run readiness checks for specific scenarios. See examples, below.

Here are some examples of running the connectivity validator cmdlet with parameters.
 
#### Example 1: Check connectivity of a remote computer

In this example, you remotely connect from your workstation or a staging server to check the connectivity of one or more remote systems.

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

If you're using a proxy server, you can specify the connectivity validator to go through the specified proxy and credentials, as shown in the following example:

```powershell
Invoke-AzStackHciConnectivityValidation -Proxy http://proxy.contoso.com:8080 -ProxyCredential $proxyCredential 
```

> [!NOTE]
> The connectivity validator validates general proxy, it doesn’t check if your Azure Stack HCI is configured correctly to use a proxy. For information about how to configure firewalls for Azure Stack HCI, see [Firewall requirements for Azure Stack HCI](../concepts/firewall-requirements.md).

#### Example 4: Check connectivity and create PowerShell output object

You can view the output of the connectivity checker as an object by using the `–PassThru` parameter:

```powershell
Invoke-AzStackHciConnectivityValidation –PassThru
```

Here's a sample screenshot of the output:

   :::image type="content" source="./media/environment-checker/connectivity-validator-pass-thru-parameter.png" alt-text="Screenshot of a passed connectivity validator report for PassThru parameter." lightbox="./media/environment-checker/connectivity-validator-pass-thru-parameter.png":::

### Connectivity validator attributes

You can filter any of the following attributes and display the connectivity validator result in your desired format:

| Attribute name | Description |
| -------------  | ----------- |
| EndPoint       | The endpoint being validated. |
| Protocol       | Protocol used – example https. |
| Service        | The service endpoint being validated. |
| Operation Type | Type of operation – deployment, update. |
| Group          | Readiness Checks. |
| System         | For internal use. |
| Name           | Name of the individual service. |
| Title          | Service title ; user facing name. |
| Severity       | Critical, Warning, Informational, Hidden. |
| Description    | Description of the service name. |
| Tags           | Internal Key-value pairs to group or filter tests. |
| Status         | Succeeded, Failed, In Progress. |
| Remediation    | URL link to documentation for remediation. |
| TargetResourceID | Unique identifier for the affected resource (node or drive). |
| TargetResourceName | Name of the affected resource. |
| TargetResourceType | Type of the affected resource. |
| Timestamp | The time in which the test was called. |
| AdditionalData | Property bag of key value pairs for additional information. |
| HealthCheckSource | The name of the services called for the health check. |

### Connectivity validator output

The following samples are the output from successful and unsuccessful runs of the connectivity validator.

To learn more about different sections in the readiness check report, see [Understand readiness check report](#understand-readiness-check-report).

**Sample output: Successful test**

The following sample output is from a successful run of the connectivity validator. The output indicates a healthy connection to all the endpoints, including well-known Azure services and observability services. Under **Diagnostics**, you can see the validator checks if a DNS server is present and healthy. It collects WinHttp, IE proxy, and environment variable proxy settings for diagnostics and data collection. It also checks if a transparent proxy is used in the outbound path and displays the output.

   :::image type="content" source="./media/environment-checker/connectivity-validator-sample-passed.png" alt-text="Screenshot of a passed report after running the connectivity validator." lightbox="./media/environment-checker/connectivity-validator-sample-passed.png":::

**Sample output: Failed test**

If a test fails, the connectivity validator returns information to help you resolve the issue, as shown in the sample output below. The **Needs Remediation** section displays the issue that caused the failure. The **Remediation** section lists the relevant article to help remediate the issue.

   :::image type="content" source="./media/environment-checker/connectivity-validator-sample-failed.png" alt-text="Screenshot of a failed report after running the connectivity validator." lightbox="./media/environment-checker/connectivity-validator-sample-failed.png":::

## [Hardware](#tab/hardware)

The hardware validator checks whether the servers and other hardware components meet the [system requirements](../concepts/system-requirements.md). For example, it checks if all physical servers in your cluster are configured uniformly and all hardware components use the same versions of firmware and are operating as expected.

We recommend you use the hardware validator before starting the deployment.

Refer to the following table for a description of the tests the hardware validator performs on different hardware component:

| **Test source** | **Test description** | **Status** |
| -------| ------------------------| --------------- |
| Processor | All processor for desired properties | Warning |
| Processor | All processor for consistent properties | Warning |
| Processor | Hyper-V Virtualization Enabled | Warning |
| Memory | All physical memory for consistent properties | Warning |
| Memory | All physical memory for desired properties | Warning |
| Network adapter | All network adapter for consistent properties | Critical |
| Network adapter | All network adapter for desired properties | Critical |
| Network adapter | All network adapter groups for consistent properties | Critical |
| GPU | Video controller for desired properties | Warning |
| Storage | PhysicalDisk count | Critical |
| Storage | PhysicalDisk for desired properties | Warning |
| Storage | PhysicalDisk Groups for consistent properties | Warning |
| Storage | No storage pools exist | Critical |
| Firmware | BIOS for desired properties | Warning |
| Firmware | Secure Boot enabled | Critical |
| Firmware | TPM for desired certificates | Critical |
| Firmware | TPM for desired properties | Critical |
| Firmware | TPM 2.0 | Critical |

### Run the hardware validator

To run the hardware validator, follow these steps.

1. Open PowerShell as administrator locally on the Azure Stack HCI server node.

1. Run the following cmdlet to invoke the hardware validator:

   ```powershell
   Invoke-AzStackHciHardwareValidation 
   ```

Here are some examples of using the hardware validator.
 
### Example 1: Check hardware readiness of one or more remote servers

In this example, you remotely connect from a workstation or a staging server to check hardware readiness of two remote systems.

```powershell
$session = New-PSSession –ComputerName remotesystem1.contoso.com,remotesystem2.contoso.com -Credential $credential  

Invoke-AzStackHciHardwareValidation -PsSession $Session 
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

With this release, you must run the Active Directory preparation tool to create group managed service accounts (gMSAs) and make them discoverable by deployment in a dedicated Organizational Unit (OU).

Use the Active Directory validator to:

- Validate the Active Directory preparation tool is run and the gMSAs are set and groups are provisioned prior to starting the deployment.
- Assess any Active Directory issue during deployment. The support team can check the validator report logs to assess if you'd run the Active Directory preparation tool before deployment.

### Run the Active Directory validator

To run the Active Directory validator locally from an Azure Stack HCI server node, a workstation, or a staging sever, follow these steps.

1. Ensure the following parameters are unique in the Active Directory per cluster instance:

   - Azure Stack HCI deployment user
   - Azure Stack HCI organization unit name
   - Azure Stack HCI deployment prefix (must be at the max eight characters)
   - Azure Stack HCI deployment cluster name
   - Physical nodes objects (if already created) must be available under nested computers organization unit

1. Run the following command in PowerShell as administrator:

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

   The `Invoke-AzStackHciExternalActiveDirectoryValidation` cmdlet checks if Active Directory and Group Policy object (GPO) modules are available, and attempts to install them if they aren't.

### Active Directory validator output

The following samples are the output from successful and unsuccessful runs of the Active Directory validator.

To learn more about different sections in the readiness check report, see [Understand readiness check report](#understand-readiness-check-report).

**Sample output: Successful test**

The following sample is the output from a successful run of the Active Directory validator. The output indicates that the specified OU exists and contains proper sub-OUs.

   :::image type="content" source="./media/environment-checker/active-directory-validator-sample-passed.png" alt-text="Screenshot of a passed report after running the Active Directory validator." lightbox="./media/environment-checker/active-directory-validator-sample-passed.png":::

**Sample output: Failed test**

The following sample is the output from a failed run of the Active Directory validator. The report indicates that the Active Directory tool hasn't been run and proper Organizational Unit (OU) isn't created.

   :::image type="content" source="./media/environment-checker/active-directory-validator-sample-failed.png" alt-text="Screenshot of another failed report after running the Active Directory validator." lightbox="./media/environment-checker/active-directory-validator-sample-failed.png":::

To remediate the blocking issues in this output, open the Active Directory tool and pass the following parameters:

```powershell
.\AsHciADArtifactsPreCreationTool.ps1 -AsHciDeploymentUserCredential (get-credential) -AsHciOUName "OU=Hci001,DC=contoso,DC=local,DC=stbtest,DC=microsoft,DC=com" -AsHciPhysicalNodeList @("Physical Machine1", "Physical Machine2") -DomainFQDN "'contoso.local " -AsHciClusterName "s-cluster" -AsHciDeploymentPrefix "Hci001"
```

### [Network](#tab/network)

It is possible that the IP addresses allocated to Azure Stack HCI may already be active on the network. The network validator validates your network infrastructure for valid IP ranges reserved for deployment. It attempts to ping and connect to WinRM and SSH ports to ensure there's no active host using the IP address from the reserved IP range.

You provide the network IP range reserved for Azure Stack HCI deployment as part of the answer file JSON, which you can use during network validation. Or, you can manually provide the starting and ending IP addresses when running the validator cmdlet.

### Run the network validator

To run the network validator locally on the Azure Stack HCI server node, the workstation, or the staging server with the answer file, follow these steps.

1. Run one of the following cmdlets:

    
   - If using the answer file:
   
      ```powershell
      Invoke-AzStackHciNetworkValidation -AnswerFile <Answerfilename>.json
      ```
   
   - If entering the starting and ending IP addresses manually:
       
      ```powershell
      Invoke-AzStackHciNetworkValidation -StartingAddress <StartingIPRangeAddress> -EndingAddress <EndingIPRangeAddress> 
      ```

### Network validator output

The following samples are the output from successful and unsuccessful runs of the network validator.

To learn more about different sections in the readiness check report, see [Understand readiness check report](#understand-readiness-check-report).

**Sample output: Successful test**

The following sample is the output from a successful run of the network validator. The output indicates no active host is using an IP address from the reserved IP range.

   :::image type="content" source="./media/environment-checker/network-validator-sample-passed.png" alt-text="Screenshot of a passed report after running the network validator." lightbox="./media/environment-checker/network-validator-sample-passed.png":::

**Sample output: Failed test**

The following sample is the output from a failed run of the network validator. This output shows two active hosts are using IP address from the reserved IP range.

   :::image type="content" source="./media/environment-checker/network-validator-sample-failed.png" alt-text="Screenshot of a failed report after running the network validator." lightbox="./media/environment-checker/network-validator-sample-failed.png":::

---

### Understand readiness check report

Each validator generates a readiness check report after completing the check. Make sure to review the report and correct any issues before starting the actual deployment.

The information displayed on each readiness check report varies depending on the checks the validators perform. The following table summarizes the different sections in the readiness check reports for each validator:

| **Section** | **Description** | **Available in** |
| ------- | ----------- | ----------- |
| Services | Displays the health status of each service endpoint that the connectivity validator checks. Any service endpoint that fails the check is highlighted with the **Needs Remediation** tag.| Connectivity validator report|
| **Diagnostics** | Displays the result of the diagnostic tests. For example, the health and availability of a DNS server. It also shows what information the validator collects for diagnostic purposes, such as WinHttp, IE proxy, and environment variable proxy settings. | Connectivity validator report|
| Hardware | Displays the health status of all the physical servers and their hardware components. For information on the tests performed on each hardware, see the table under the "Hardware" tab in the [Run readiness checks](#run-readiness-checks) section. | Hardware validator report|
| **AD OU Diagnostics** | Displays the result of the Active Directory organization unit test. Displays if the specified organizational unit exists and contains proper sub-organizational units. | Active Directory validator report|
| Network range test | Displays the result of the network range test. If the test fails, it displays the IP addresses that belong to the reserved IP range. | Network validator report |
| **Summary** | Lists the count of successful and failed tests. Failed test results are expanded to show the failure details under **Needs Remediation**.| All reports |
| **Remediation** | Displays only if a test fails. Provides a link to the article that provides guidance on how to remediate the issue. | All reports |
| **Log location (contains PII)** | Provides the path where the log file is saved. The default path is:<br><br>- `$HOME\.AzStackHci\AzStackHciEnvironmentChecker.log` when you run the Environment Checker in a standalone mode.<br>- `C:\CloudDeployment\Logs` when the Deployment Tool runs the Environment Checker internally.<br><br> Each run of the validator overwrites the existing file.| All reports |
| **Report Location (contains PII)** | Provides the path where the completed readiness check report is saved in the JSON format. The default path is:<br><br>- `$HOME\.AzStackHci\AzStackHciEnvironmentReport.json` when you run the Environment Checker in a standalone mode.<br>- `C:\CloudDeployment\Logs` when the Deployment Tool runs the Environment Checker internally.<br><br> The report provides detailed diagnostics that are collected during each test. This information can be helpful for system integrators or when you need to contact the support team to troubleshoot the issue. Each run of the validator overwrites the existing file. | All reports |
| Completion message | At the end of the report, displays a message that the validation check is completed.| All reports|

## Environment Checker results

> [!NOTE]
> The results reported by the Environment Checker tool reflect the status of your settings only at the time that you ran it. If you make changes later, for example to your Active Directory or network settings, items that passed successfully earlier can become critical issues.

For each test, the validator provides a summary of the unique issues and classifies them into: success, critical issues, warning issues, and informational issues. Critical issues are the blocking issues that you must fix before proceeding with the deployment.

## Troubleshoot connectivity validator

This section describes the known issue with connectivity validator and how to troubleshoot it.

### Known issue in connectivity validator

The connectivity validator checks for SSL inspection before testing connectivity of any required endpoints. The connectivity validator makes an HTTPS call to endpoints and inspects the certificate chain in the response. The check reads the distinguished names (subject) of the certificates in the certificate chain to determine if they are **DigiCert** and **Microsoft** intermediate certificate authority (CA) certificates.

If SSL inspection is turned on in your Azure Stack HCI system, a device on the network decrypts the HTTPS call, inspects it, and re-encrypts it with its own certificate. Because of this decryption and re-encryption, the distinguished names (subject) of the certificates no longer match with the ones in the certificate chain. Azure Stack HCI doesn't support this configuration, and when detected, the connectivity validator blocks it during deployment and fails with the following error. This is done to prevent any unwanted tampering or malicious activity over the network.

:::image type="content" source="./media/environment-checker/error-connectivity-validation.png" alt-text="Screenshot of the error when the connectivity validation fails." lightbox="./media/environment-checker/error-connectivity-validation.png":::

**Workaround**

Turn off SSL inspection on Azure Stack HCI servers and then run the connectivity validator.

**Alternative workaround if you have SSL inspection turned on**

If you receive the certificate validation error message, run the following commands individually for each endpoint to manually check the certificate information:

```powershell
C:\> Import-Module AzStackHci.EnvironmentChecker 
C:\> Get-SigningRootChain -Uri <Endpoint-URI> | ft subject 
```

For example, if you want to verify the certificate information for two endpoints, say `https://login.microsoftonline.com` and `https://portal.azure.com`, run the following commands individually for each endpoint:

- For `https://login.microsoftonline.com`:

   ```powershell
   C:\> Import-Module AzStackHci.EnvironmentChecker 
   C:\> Get-SigningRootChain -Uri https://login.microsoftonline.com | ft subject
   ```

   Here's a sample output:

   ```powershell
   Subject
   -------
   CN=portal.office.com, O=Microsoft Corporation, L=Redmond, S=WA, C=US
   CN=Microsoft Azure TLS Issuing CA 02, O=Microsoft Corporation, C=US
   CN=DigiCert Global Root G2, OU=www.digicert.com, O=DigiCert Inc, C=US
   ```

- For `https://portal.azure.com`:

   ```powershell
   C:\> Import-Module AzStackHci.EnvironmentChecker
   C:\> Get-SigningRootChain -Uri https://portal.azure.com | ft Subject 

   ```

   Here's a sample output:

   ```powershell
   Subject
   -------
   CN=portal.azure.com, O=Microsoft Corporation, L=Redmond, S=WA, C=US
   CN=Microsoft Azure TLS Issuing CA 01, O=Microsoft Corporation, C=US
   CN=DigiCert Global Root G2, OU=www.digicert.com, O=DigiCert Inc, C=US
   ```

In the example above, the connectivity validator checks two endpoints that are Microsoft’s properties and their SSL certificates have expiry dates six months out of phase with each other. The test only requires success from one endpoint and requires only one certificate in the chain to be **Microsoft** or **Digicert**. The reason for this tolerance is in consideration for certificate rotation. If one certificate is rotated out of the chain, the test expects the other can still satisfy the test, for up to six months. If part of the chain rotates, the test requires only one certificate to match **Microsoft** or **Digicert**.

## Next steps

- [Review the deployment checklist](../deploy/deployment-tool-checklist.md)
- [Contact Microsoft Support](get-support.md)
