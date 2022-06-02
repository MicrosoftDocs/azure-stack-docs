---
title: Troubleshoot Azure Stack HCI registration issues and errors
description: Common issues registering Azure Stack HCI clusters with Azure.
author: sethmanheim
ms.author: sethm
ms.reviewer: arduppal
ms.topic: conceptual
ms.date: 06/03/2022
---

# Troubleshoot Azure Stack HCI registration

Troubleshooting Azure Stack HCI registration issues requires looking at both PowerShell registration logs and hcisvc debug logs from each server in the cluster.

## Collect PowerShell registration logs

When the `Register-AzStackHCI` and `Unregister-AzStackHCI` cmdlets are run, log files called **RegisterHCI_{yyyymmdd-hhss}.log** and **UnregisterHCI_{yyyymmdd-hhss}.log** are created for each attempt. These files are created in the working directory of the PowerShell session in which the cmdlets are run. Debug logs are not included by default. If there is an issue that needs the additional debug logs, set debug preference to **Continue** by running the following cmdlet before running `Register-AzStackHCI` or `Unregister-AzStackHCI`:

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

**Failure state explanation**: During registration, each server in the cluster must be up and running with outbound internet connectivity to Azure. The `Register-AzStackHCI` cmdlet talks to all servers in the cluster to provision certificates for each. Each server will use its certificate to make API call to HCI services in the cloud to validate registration.

If registration fails, you may see the following message: **Failed to register. Couldn't generate self-signed certificate on node(s) {Node1,Node2}. Couldn't set and verify registration certificate on node(s) {Node1,Node2}**

If there are node names after the 'Couldn't generate self-signed certificate on node(s)' part of the error message, then we weren't able to generate the certificate on those server(s).

**Remediation action**:

1. Check that each server listed in the above message is up and running. You can check the status of hcisvc by running `sc.exe query hcisvc` and start it if needed with `start-service hcisvc`.

2. Check that each server listed in the error message has connectivity to the machine on which the `Register-AzStackHCI` cmdlet is run. Verify this by running the following cmdlet from the machine on which `Register-AzStackHCI` is run, using `New-PSSession` to connect to each server in the cluster and make sure it works:

   ```PowerShell
   New-PSSession -ComputerName {failing nodes}
   ```

If there are node names after the 'Couldn't set and verify registration certificate on node(s)' part of the error message, then we were able to generate the certificate on the server(s), but the server(s) weren't able to successfully call the HCI cloud service API. To troubleshoot:

1. Make sure each server has the required internet connectivity to talk to Azure Stack HCI cloud services and other required Azure services like Azure Active Directory, and that it's not being blocked by firewall(s). See [Firewall requirements for Azure Stack HCI](../concepts/firewall-requirements.md).

2. Try running the `Test-AzStackHCIConnection` cmdlet and make sure it succeeds. This cmdlet will invoke the health endpoint of HCI cloud services to test connectivity.

3. Look at the hcisvc debug logs on each node listed in the error message.

   - It's ok to have 'ExecuteWithRetry operation AADTokenFetch failed with retryable error' appear a few times before it either fails with 'ExecuteWithRetry operation AADTokenFetch failed after all retries' or 'ExecuteWithRetry operation AADTokenFetch succeeded in retry'.
   - If you encounter 'ExecuteWithRetry operation AADTokenFetch failed after all retries' in the logs, we weren't able to fetch the Azure Active Directory token from the service even after all the retries. There will be an associated AAD exception that's logged with this message. 
   - If you see "AADSTS700027: Client assertion contains an invalid signature. [Reason - The key used is expired. Thumbprint of key used by client: '{SomeThumbprint}', Found key 'Start=06/29/2021 21:13:15, End=06/29/2023 21:13:15'", this is an issue with how the time is set on the server. Check the UTC time on all the servers by running `[System.DateTime]::UtcNow` in PowerShell, and compare it with the actual UTC time. If the time isn't correct, then set the correct the times on the servers and then try registration again.

## Deleting HCI resource from portal and re-registering the same cluster causes issues

**Failure state explanation**: If you explicitly deleted the Azure Sack HCI cluster resource from the Azure portal without first unregistering the cluster from Windows Admin Center or PowerShell, deletion of an HCI Azure resource manager resource directly from the portal results in a bad-cluster resource state. Unregistration should be always triggered from within the HCI cluster using the `Unregister-AzStackHCI` cmdlet for a clean unregistration. This section describes cleanup steps for scenarios in which the HCI cluster resource was deleted from the portal.

**Remediation action**:

1. Sign in to the on-premises HCI cluster server using the cluster user credentials.
2. Run the `Unregister-AzStackHCI` cmdlet on the cluster to clean up the cluster registration state and cluster Arc state.</br>
    a. If unregistration succeeds, navigate to **Azure Active Directory > App registrations (All applications)** and search for the name matching `clusterName` and `clusterName.arc`. Delete the two app IDs if they exist.</br>
    b. If unregistration fails with the error **ERROR: Couldn't disable Azure Arc integration on Node \<node name\>**, try running the `Disable-AzureStackHCIArcIntegration` cmdlet on the node. If the node is in a state where `Disable-AzureStackHCIArcIntegration` cannot be run, remove the node from the cluster and try running the `Unregister-AzStackHCI` cmdlet again.
3. Sign in to each individual node:
    a. Change directory to where the Arc agent is installed: `cd 'C:\Program Files\AzureConnectedMachineAgent\'`.
    b. Get the status on arcmagent.exe and determine the Azure resource group it is projected to: `.\azcmagent.exe show`. Output for this command shows the resource group information.
    c. Force disconnect the Arc agent from node: `.\azcmagent.exe disconnect --force-local-only`.
    d. Sign in to the Azure portal and delete the **Arc-for-Server** resource from the resource group determined in step 3.

## User deleted the App IDs by mistake

**Failure state explanation**: If the cluster is disconnected for more than 8 hours, it is possible that the associated Azure AD app registrations representing the HCI cluster and Arc registrations could have been accidentally deleted. For the proper functioning of HCI cluster and Arc scenarios, two app registrations are created in the tenant during registration.

- If the `<clustername>` app ID is deleted, the cluster resource **Azure Connection** in the Azure portal displays **Disconnected - Cluster not in connected state for more than 8 hours**.
  - Look at the **HCIsvc** debug logs on the node: the error message will be **Application with identifier '\<ID\>' was not found in the directory 'Default Directory'. This can happen if the application has not been installed by the administrator of the tenant or consented to by any user in the tenant. You may have sent your authentication request to the wrong tenant.**
- If `<clustername>.arc` created during Arc enablement is deleted, there are no visible errors during normal operation. This identity is required only during the registration and unregistration processes. In this scenario, unregistration fails with the error **Couldn't disable Azure Arc integration on Node \<Node Name\>. Try running the Disable-AzureStackHCIArcIntegration cmdlet on the node. If the node is in a state where the Disable-AzureStackHCIArcIntegration cmdlet could not be run, remove the node from the cluster and try running the Unregister-AzStackHCI cmdlet again.**

Deleting any of these applications results in a failure to communicate from the HCI cluster to the cloud.

**Remediation action**:

1. If only the `<clustername> AppId` is deleted, perform a repair registration on the cluster to set up the Azure AD applications:

   ```powershell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1 -RepairRegistration
   ```

   Repairing the registration recreates the necessary Azure AD applications while retaining other information such as resource name, resource group and other registration choices.

2. If the `<clustername>.arc` app ID is deleted, there is no visible error in the logs. Unregistration will fail if `<clustername>.arc` is deleted. If unregistration fails, follow the same remediation action [described in this section](#deleting-hci-resource-from-portal-and-re-registering-the-same-cluster-causes-issues).

## Out of policy error

**Failure state explanation**: If a previously registered cluster is showing a status of **OutOfPolicy**, changes to the system configuration may have caused the registration status of Azure Stack HCI to fall out of policy.

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

**Failure state explanation**: This issue is caused by unregistering an HCI cluster with the wrong cloud environment or subscription information. If a user runs the `Unregister-AzStackHCI` cmdlet with incorrect `-EnvironmentName` or `-SubcriptionId` parameters for a cluster, the registration state of the cluster is removed from the on-premises cluster itself, but the cluster and Arc resources in the Azure portal will still exist in the original environment or subscription.

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
   Unregister-AzStackHCI -SubscriptionId "subscription_id_2"
   ```

**Remediation action**:

1. Delete the cluster and Arc resources from the portal.
2. Navigate to **Azure Active Directory > App registrations (All applications)**, and search for the name matching `<clusterName>` and `<clusterName>.arc`, then delete the two app IDs.

## Issuing Sync-AzureStackHCI immediately after restart of the nodes of the cluster result in Arc resource deletion

**Failure state explanation**: Performing a census sync before node synchronization can result in the sync being sent to Azure, which does not include the node. This results in the Arc resource for that node being removed. The `Sync-AzureStackHCI` cmdlet must be used only to debug the HCI cluster's cloud connectivity. The HCI cluster has a small warmup time after a reboot to reconcile the cluster state; therefore, do not execute `Sync-AzureStackHCI` soon after rebooting a node.

**Remediation action**:

1. On the Azure portal, sign in to the node that appears as **Not installed**.

   :::image type="content" source="media/troubleshoot-hci-registration/node-monitor.png" alt-text="Screenshot of nodes" lightbox="media/troubleshoot-hci-registration/node-monitor.png":::

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

## Stale Arc agent and extension causes registration failure

**Failure state explanation**: This happens in scenarios in which one or all of the HCI cluster nodes are already Arc-enabled before HCI registration. This can happen if you try to onboard Arc-for-Server manually before the `Register-AzStackHCI` cmdlet is executed, or if the HCI cluster was not correctly unregistered [as recommended in this article](register-with-azure.md#unregister-azure-stack-hci) before trying to re-register the same cluster.

With the cluster in this state, when you attempt to register HCI with Azure, the registration completes successfully. However, in the Azure portal, the **Azure Arc** connection displays **Not Installed**.

**Remediation action**:

1. Sign in to the cluster-node with the **Azure Arc** status that shows as **Not installed**:

   :::image type="content" source="media/troubleshoot-hci-registration/node-monitor.png" alt-text="Screenshot of nodes" lightbox="media/troubleshoot-hci-registration/node-monitor.png":::

2. Disconnect the Arc agent using the following two commands:

   ```bash
   cd "C:\Program Files\AzureConnectedMachineAgent"
   ```

   then

   ```bash
   .\azcmagent.exe disconnect --force-local-only
   ```

3. Run the repair registration cmdlet:

   ```powershell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1  -RepairRegistration
   ```

## Not able to rotate certificates in Fairfax and Mooncake

**Failure state explanation**:

1. From the Azure portal, the cluster resource **Azure Connection** displays **Disconnected**.
2. Look at the HCIsvc debug logs on the node. The error message will be **exception: AADSTS700027: Client assertion failed signature validation**.
3. The error can also be shown as **RotateRegistrationCertificate failed: Invalid Audience**.

**Remediation action**: Perform a repair registration on the cluster to add new certificates in the Azure AD application:

```powershell
Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1 -RepairRegistration
```

Repairing the registration generates new replacement certificates in the Azure AD application, while retaining other information such as the resource name, resource group, and other registration choices.

## OnPremisesPasswordValidationTimeSkew

**Failure state explanation**: Azure AD token generation fails with a time error if the local node time is too far out of sync with true current time (UTC). Azure AD returns the following error:

**AADSTS80013: OnPremisesPasswordValidationTimeSkew - The authentication attempt could not be completed due to time skew between the machine running the authentication agent and AD. Fix time sync issues.**

**Remediation action**: Ensure the time is synchronized to a known and accurate time source.

## Next steps

- [Register Windows Admin Center with Azure](../manage/register-windows-admin-center.md)
- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)