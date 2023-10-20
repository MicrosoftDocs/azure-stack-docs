---
title: Troubleshoot Azure Stack HCI registration issues and errors
description: Common issues registering Azure Stack HCI clusters with Azure.
author: sethmanheim
ms.author: sethm
ms.reviewer: arduppal
ms.topic: conceptual
ms.custom:
  - devx-track-azurepowershell
ms.date: 09/22/2023
---

# Troubleshoot Azure Stack HCI registration

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

Troubleshooting Azure Stack HCI registration issues requires looking at both PowerShell registration logs and hcisvc debug logs from each server in the cluster.

## Collect PowerShell registration logs

When the `Register-AzStackHCI` and `Unregister-AzStackHCI` cmdlets are run, log files named **RegisterHCI_{yyyymmdd-hhss}.log** and **UnregisterHCI_{yyyymmdd-hhss}.log** are created for each attempt. You can set the log directory for these log files using the `-LogsDirectory` parameter in the `Register-AzStackHCI` cmdlet, and call `Get-AzStackHCILogsDirectory` to obtain the location. By default, these files are created in **C:\ProgramData\AzureStackHCI\Registration**. For PowerShell module version 2.1.2 or earlier, these files are created in the working directory of the PowerShell session in which the cmdlets are run.

By default, debug logs are not included. If there is an issue that needs the additional debug logs, set the debug preference to **Continue** by running the following cmdlet before running `Register-AzStackHCI` or `Unregister-AzStackHCI`:

```PowerShell
$DebugPreference = 'Continue'
```

## Collect on-premises hcisvc logs

To enable debug logs for hcisvc, run the following command in PowerShell on each server in the cluster:

```PowerShell
wevtutil.exe sl /q /e:true Microsoft-AzureStack-HCI/Debug
```

To get the logs:

```PowerShell
Get-WinEvent -Logname Microsoft-AzureStack-HCI/Debug -Oldest -ErrorAction Ignore
```

## Failed to register. Couldn't generate self-signed certificate on node(s) {Node1,Node2}. Couldn't set and verify registration certificate on node(s) {Node1,Node2}

**Failure state explanation**:

During registration, each server in the cluster must be up and running with outbound internet connectivity to Azure. The [Register-AzStackHCI](/powershell/module/az.stackhci/register-azstackhci) cmdlet talks to each server in the cluster to provision certificates. Each server uses its certificate to make an API call to HCI services in the cloud to validate registration.

If registration fails, you may see the following message: **Failed to register. Couldn't generate self-signed certificate on node(s) {Node1,Node2}. Couldn't set and verify registration certificate on node(s) {Node1,Node2}**

If there are node names after the **Couldn't generate self-signed certificate on node(s)** part of the error message, then the system wasn't able to generate the certificate on those server(s).

**Remediation action**:

1. Check that each server listed in the above message is up and running. You can check the status of hcisvc by running `sc.exe query hcisvc` and start it if needed with `start-service hcisvc`.

1. Check that each server listed in the error message has connectivity to the machine on which the `Register-AzStackHCI` cmdlet is run. Verify this by running the following cmdlet from the machine on which `Register-AzStackHCI` is run, using `New-PSSession` to connect to each server in the cluster and make sure it works:

   ```PowerShell
   New-PSSession -ComputerName {failing nodes}
   ```

If there are node names after the **Couldn't set and verify registration certificate on node(s)** part of the error message, then the service was able to generate the certificate on the server(s), but the server(s) weren't able to successfully call the HCI cloud service API. To troubleshoot:

1. Make sure each server has the required internet connectivity to talk to Azure Stack HCI cloud services and other required Azure services like Microsoft Entra ID, and that it's not being blocked by firewall(s). See [Firewall requirements for Azure Stack HCI](../concepts/firewall-requirements.md).

1. Try running the `Invoke-AzStackHciConnectivityValidation` cmdlet from the [AzStackHCI.EnvironmentChecker](https://www.powershellgallery.com/packages/AzStackHci.EnvironmentChecker/0.2.5) module and make sure it succeeds. This cmdlet invokes the health endpoint of HCI cloud services to test connectivity.

1. Look at the hcisvc debug logs on each node listed in the error message.

   - It's OK to have the message **ExecuteWithRetry operation AADTokenFetch failed with retryable error** appear a few times before it either fails with **ExecuteWithRetry operation AADTokenFetch failed after all retries** or **ExecuteWithRetry operation AADTokenFetch succeeded in retry**.
   - If you encounter **ExecuteWithRetry operation AADTokenFetch failed after all retries** in the logs, the system wasn't able to fetch the Microsoft Entra token from the service even after all the retries. There will be an associated Microsoft Entra exception that's logged with this message. 
   - If you see **AADSTS700027: Client assertion contains an invalid signature. [Reason - The key used is expired. Thumbprint of key used by client: '{SomeThumbprint}', Found key 'Start=06/29/2021 21:13:15, End=06/29/2023 21:13:15'**, this is an issue with how the time is set on the server. Check the UTC time on all servers by running `[System.DateTime]::UtcNow` in PowerShell, and compare it with the actual UTC time. If the time isn't correct, then set the correct times on the servers and try the registration again.

## Deleting HCI resource from portal and re-registering the same cluster causes issues

**Failure state explanation**:

If you explicitly deleted the Azure Sack HCI cluster resource from the Azure portal without first unregistering the cluster from Windows Admin Center or PowerShell, deletion of an HCI Azure Resource Manager resource directly from the portal results in a bad-cluster resource state. Unregistration should be always triggered from within the HCI cluster using the `Unregister-AzStackHCI` cmdlet for a clean unregistration. This section describes cleanup steps for scenarios in which the HCI cluster resource was deleted from the portal.

**Remediation action**:

1. Sign in to the on-premises HCI cluster server using the cluster user credentials.
2. Run the `Unregister-AzStackHCI` cmdlet on the cluster to clean up the cluster registration state and cluster Arc state.
    - If unregistration succeeds, navigate to **Microsoft Entra ID > App registrations (All applications)** and search for the name matching `clusterName` and `clusterName.arc`. Delete the two app IDs if they exist.
    - If unregistration fails with the error **ERROR: Couldn't disable Azure Arc integration on Node \<node name\>, try running the `Disable-AzureStackHCIArcIntegration` cmdlet on the node. If the node is in a state where `Disable-AzureStackHCIArcIntegration` cannot be run, remove the node from the cluster and try running the `Unregister-AzStackHCI` cmdlet again.** Sign in to each individual node:
        1. Change directory to where the Arc agent is installed: `cd 'C:\Program Files\AzureConnectedMachineAgent\'`.
        2. Get the status on arcmagent.exe and determine the Azure resource group it is projected to: `.\azcmagent.exe show`. Output for this command shows the resource group information.
        3. Force disconnect the Arc agent from node: `.\azcmagent.exe disconnect --force-local-only`.
        4. Sign in to the Azure portal and delete the **Arc-for-Server** resource from the resource group determined in step ii.

## User deleted the App IDs by mistake

**Failure state explanation**:

If the cluster is disconnected for more than 8 hours, it is possible that the associated Microsoft Entra app registrations representing the HCI cluster and Arc registrations could have been accidentally deleted. For the proper functioning of HCI cluster and Arc scenarios, two app registrations are created in the tenant during registration.

- If the `<clustername>` app ID is deleted, the cluster resource **Azure Connection** in the Azure portal displays **Disconnected - Cluster not in connected state for more than 8 hours**. Look at the **HCIsvc** debug logs on the node: the error message will be **Application with identifier '\<ID\>' was not found in the directory 'Default Directory'. This can happen if the application has not been installed by the administrator of the tenant or consented to by any user in the tenant. You may have sent your authentication request to the wrong tenant.**
- If `<clustername>.arc` created during Arc enablement is deleted, there are no visible errors during normal operation. This identity is required only during the registration and unregistration processes. In this scenario, unregistration fails with the error **Couldn't disable Azure Arc integration on Node \<Node Name\>. Try running the Disable-AzureStackHCIArcIntegration cmdlet on the node. If the node is in a state where the Disable-AzureStackHCIArcIntegration cmdlet could not be run, remove the node from the cluster and try running the Unregister-AzStackHCI cmdlet again.**

Deleting any of these applications results in a failure to communicate from the HCI cluster to the cloud.

**Remediation action**:

- If only the `<clustername> AppId` is deleted, perform a repair registration on the cluster to set up the Microsoft Entra applications:

   ```powershell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1 -RepairRegistration
   ```

   Repairing the registration recreates the necessary Microsoft Entra applications while retaining other information such as resource name, resource group and other registration choices.

- If the `<clustername>.arc` app ID is deleted, there is no visible error in the logs. Unregistration will fail if `<clustername>.arc` is deleted. If unregistration fails, follow the same remediation action [described in this section](#deleting-hci-resource-from-portal-and-re-registering-the-same-cluster-causes-issues).

## Out of policy error

**Failure state explanation**:

If a previously registered cluster is showing a status of **OutOfPolicy**, changes to the system configuration may have caused the registration status of Azure Stack HCI to fall out of policy.

For example, system changes may include, but are not limited to:

- Turning off Secure Boot settings conflicts on the registered node.
- Clearing the Trusted Platform Module (TPM).
- A significant system time change.

> [!NOTE]
> Azure Stack HCI 21H2 with KB5010421, and later versions, will attempt to automatically recover from the **OutOfPolicy** state. Review the **Microsoft-AzureStack-HCI/Admin Event Log** for more information about the present **OutOfPolicy** status and other information.

### What 'OutOfPolicy' Event ID messages could I expect to see during registration?

There are three types of event ID messages: informational, warnings, and errors.

The following messages were updates with Azure Stack HCI 21H2 with KB5010421, and will not be seen if this KB is not installed.

### Informational event ID

Informational event ID messages that occur during registration. Review and follow-through on any suggestions in the message:

- (Informational) **Event ID 592:** "Azure Stack HCI has initiated a repair of its data. No further action from the user is required at this time."

- (Informational) **Event ID 594:** "Azure Stack HCI encountered an error accessing its data. To repair, please check which nodes are affected - if the entire cluster is OutOfPolicy (run Get-AzureStackHCI) please run Unregister-AzStackHCI on the cluster, restart and then run Register-AzStackHCI. If only this node is affected, remove this node from the cluster, restart and wait for repair to complete, then rejoin to cluster."

### Warning event ID

With warning messages, the status of the registration is not completed. There may or may not be a problem. First, review the event ID message before taking any troubleshooting step(s).

(Warning) **Event ID 585:** "Azure Stack HCI failed to renew license from Azure. To get more details about the specific error, enable the Microsoft-AzureStack-HCI/Debug event channel."

> [!NOTE]
> Possible delays in re-establishing a full connection to Azure are expected after successful automatic repair and may result in **Event ID 585** appearing. This does not affect workloads or licensing of the node. That is, there is still an installed license, unless the node was out of the 30-day window before automatic repair.

> [!NOTE]
> In some cases, Azure Stack HCI may not succeed in automatic recovery. This can occur when the registration status of all nodes in the cluster are out of policy. Some manual steps are required. See the **Microsoft-AzureStack-HCI/Admin** event ID messages.

### Error event ID

Event ID error messages identify a failure in the registration process. The error message provides instructions on how to resolve the error.

- (Error) **Event ID 591:** "Azure Stack HCI failed to connect with Azure. If you continue to see this error, try running `Register-AzStackHCI` again with the `-RepairRegistration` parameter."

- (Error) **Event ID 594:** "Azure Stack HCI encountered an error accessing its data. To repair, please check which nodes are affected - if the entire cluster is **OutOfPolicy** (run `Get-AzureStackHCI`), run `Unregister-AzStackHCI` on the cluster, restart, and then run `Register-AzStackHCI`. If only this node is affected, remove this node from the cluster, restart, wait for the repair to complete, then rejoin the cluster."

## Cluster and Arc resource in Azure portal exists but the Get-AzureStackHCI status says "Not Yet" registered

**Failure state explanation**:

This issue is caused by unregistering an HCI cluster with the wrong cloud environment or incorrect subscription information. If a user runs the `Unregister-AzStackHCI` cmdlet with incorrect `-EnvironmentName` or `-SubcriptionId` parameters for a cluster, the registration state of the cluster is removed from the on-premises cluster itself, but the cluster and Arc resources in the Azure portal will still exist in the original environment or subscription.

For example:

- **Wrong `-EnvironmentName <value>`**: You registered your cluster in `-EnvironmentName AzureUSGovernment` as in the following example. Note that the default `-EnvironmentName` is "Azurecloud". For example, you ran:

   ```powershell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -EnvironmentName AzureUSGovernment
   ```

   But you then ran the `Unregister-AzStackHCI` cmdlet with `-EnvironmentName Azurecloud` (the default) as follows:

   ```powershell
   Unregister-AzStackHCI -SubscriptionId "<subscription_ID>"
   ```

- **Wrong `-SubscriptionId <value>`**: You registered your cluster with `-SubscriptionId "<subscription_id_1>"` as follows:

   ```powershell
   Register-AzStackHCI  -SubscriptionId "<subscription_id_1>"
   ```

   But you then ran the `Unregister-AzStackHCI` cmdlet for a different subscription ID:

   ```powershell
   Unregister-AzStackHCI -SubscriptionId "<subscription_id_2>"
   ```

**Remediation action**:

1. Delete the cluster and Arc resources from the portal.
2. Navigate to **Microsoft Entra ID > App registrations (All applications)**, and search for the name matching `<clusterName>` and `<clusterName>.arc`, then delete the two app IDs.

## Issuing Sync-AzureStackHCI immediately after restart of the nodes of the cluster result in Arc resource deletion

**Failure state explanation**:

Performing a census sync before node synchronization can result in the sync being sent to Azure, which does not include the node. This results in the Arc resource for that node being removed. The `Sync-AzureStackHCI` cmdlet must be used only to debug the HCI cluster's cloud connectivity. The HCI cluster has a small warmup time after a reboot to reconcile the cluster state; therefore, do not execute `Sync-AzureStackHCI` soon after rebooting a node.

**Remediation action**:

1. On the Azure portal, sign in to the node that appears as **Not installed**.

2. Disconnect the Arc agent using the following two commands:

   ```bash
   cd "C:\Program Files\AzureConnectedMachineAgent"
   ```

   then

   ```bash
   .\azcmagent.exe disconnect --force-local-only
   ```

3. Repair the registration:

   ```powershell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1  -RepairRegistration
   ```

4. After the repair operation, the node returns to a connected state.

## Registration completes successfully but Azure Arc connection in portal says Not Installed

### Scenario 1

**Failure state explanation**:

This can happen if the required role **Azure Connected Machine Resource Manager** is removed from the HCI resource provider in the Arc-for-Server resource group.

You can find the permission under the **Access Control** blade of the resource group in the Azure portal. The following image shows the permission:

:::image type="content" source="media/troubleshoot-hci-registration/access-control-troubleshooting.png" alt-text="Screenshot of access control blade." lightbox="media/troubleshoot-hci-registration/access-control-troubleshooting.png":::

**Remediation action**:

Run the repair registration cmdlet:

```powershell
Register-AzStackHCI -TenantId "<tenant_ID>" -SubscriptionId "<subscription_ID>" -ComputerName Server1  -RepairRegistration
```

### Scenario 2

**Failure state explanation**:

This message can also be due to a transient issue that sometimes occurs while performing Azure Stack HCI registration. When that happens, the `Register-AzStackHCI` cmdlet shows the following warning message:

:::image type="content" source="media/troubleshoot-hci-registration/hci-cmdlet-output.png" alt-text="Screenshot of output message from Register-AzStackHCI cmdlet." lightbox="media/troubleshoot-hci-registration/hci-cmdlet-output.png":::

**Remediation action**:

Wait for 12 hours after the registration for the problem to be resolved automatically.

### Scenario 3

**Failure state explanation**:

This can also happen when the proxy is not configured properly for a connection to Azure ARC cloud services from HCI nodes. You might see the following error in the Arc agent logs:

:::image type="content" source="media/troubleshoot-hci-registration/azure-arc-logs.png" alt-text="Screenshot of Arc agent logs." lightbox="media/troubleshoot-hci-registration/azure-arc-logs.png":::

**Remediation action**:

To resolve this issue, follow the [guidelines to update proxy settings](/azure/azure-arc/servers/manage-agent#update-or-remove-proxy-settings). Then, re-register the Azure Stack HCI cluster.

## Not able to rotate certificates in Fairfax and Mooncake

**Failure state explanation**:

1. From the Azure portal, the cluster resource **Azure Connection** displays **Disconnected**.
2. Look at the HCIsvc debug logs on the node. The error message will be **exception: AADSTS700027: Client assertion failed signature validation**.
3. The error can also be shown as **RotateRegistrationCertificate failed: Invalid Audience**.

**Remediation action**:

Perform a repair registration on the cluster to add new certificates in the Microsoft Entra application:

```powershell
Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1 -RepairRegistration
```

Repairing the registration generates new replacement certificates in the Microsoft Entra application, while retaining other information such as the resource name, resource group, and other registration choices.

## OnPremisesPasswordValidationTimeSkew

**Failure state explanation**:

Microsoft Entra token generation fails with a time error if the local node time is too far out of sync with true current time (UTC). Microsoft Entra ID returns the following error:

**AADSTS80013: OnPremisesPasswordValidationTimeSkew - The authentication attempt could not be completed due to time skew between the machine running the authentication agent and AD. Fix time sync issues.**

**Remediation action**:

Ensure the time is synchronized to a known and accurate time source.

## Unable to acquire token for tenant with error

**Failure state explanation**:

If the user account used for registration is part of multiple Microsoft Entra tenants, you must specify `-TenantId` during cluster registration and un-registration, otherwise it will fail with the error **Unable to acquire token for tenant with error. You must use multi-factor authentication to access tenant. Please rerun `Connect-AzAccount` with additional parameter `-TenantId`.**

**Remediation action**:

- For cluster registration, specify the `-TenantId` parameter:

   ```powershell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1 -TenantId <Tenant_ID>
   ```

- For unregistration, specify the `-TenantId` parameter:

   ```powershell
   Unregister-AzStackHCI -ComputerName ClusterNode1 -SubscriptionId "<subscription ID GUID>" -ResourceName HCI001 -TenantId <Tenant_ID>
   ```

## One or more cluster nodes not able to connect to Azure

**Failure state explanation**:

This issue happens when one or more cluster nodes had connectivity issues after registration, and were not able to connect to Azure for a long time. Even after the resolution of connectivity issues, the nodes are unable to reconnect to Azure due to the expired certificates.

**Remediation action**:

1. Sign in to the disconnected node.
2. Run `Disable-AzureStackHCIArcIntegration`.
3. Check the status of ARC integration by running `Get-AzureStackHCIArcIntegration` and make sure it now says "Disabled" for the disconnected node:

   :::image type="content" source="media/troubleshoot-hci-registration/cluster-node-integration.png" alt-text="Screenshot of Get-AzureStackHCIArcIntegration cmdlet output.":::

4. Sign in to the Azure portal and delete the Azure Resource Manager resource representing the Arc server for this node.
5. Sign in to the disconnected node again and run `Enable-AzureStackHCIArcIntegration`.
6. Run `Sync-AzureStackHCI` on the node.

## Job failure when attempting to create VM

**Failure state explanation**:

If the cluster is not registered with Azure upon deployment, or if the cluster is registered but has not connected to Azure for more than 30 days, the system will not allow new virtual machines (VMs) to be created or added. When this occurs, you will see the following error message when attempting to create VMs:

`There was a failure configuring the virtual machine role for 'vmname'. Job failed. Error opening "vmname" clustered roles. The service being accessed is licensed for a particular number of connections. No more connections can be made to the service at this time because there are already as many connections as the service can accept.`

**Remediation action**:

Register your HCI cluster with Azure. For information on how to register the cluster, [see the instructions in the Register-AzStackHCI documentation](/powershell/module/az.stackhci/register-azstackhci).

## Use common resource group for cluster and Arc-for-Server resources

The latest PowerShell module supports having a common resource group for both cluster and Arc-for-Server resources, or using any pre-existing resource group for Arc-for-Server resources.

For clusters registered with PowerShell module version 1.4.1 or earlier, you can perform the following steps to use the new feature:

1. Unregister the cluster by running `Unregister-AzStackHCI` from one of the nodes. See [Unregister Azure Stack HCI Using PowerShell](../manage/manage-cluster-registration.md?tab=power-shell#unregister-azure-stack-hci).
2. Install the latest PowerShell module: `Install-Module Az.StackHCI -Force`.
3. Run [`Register-AzStackHCI`](./register-with-azure.md?tab=power-shell#register-a-cluster) by passing the appropriate parameters for `-ResourceGroupName` and `-ArcForServerResourceGroupName`.

> [!NOTE]
> If you are using a separate resource group for Arc-for-Server resources, we recommend using a resource group having Arc-for-Server resources related only to Azure Stack HCI. The Azure Stack HCI resource provider has permissions to manage any other Arc-for-Server resources in the **ArcServerResourceGroup**.

## Next steps

- [Register Windows Admin Center with Azure](../manage/register-windows-admin-center.md)
- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)
