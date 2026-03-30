---
title: "Azure Operator Nexus: Network Fabric Runtime Upgrade Template"
description: Learn how to upgrade Network Fabric for Azure Operator Nexus with a step-by-step parameterized template.
author: jeffreymason 
ms.author: jeffreymason
ms.service: azure-operator-nexus
ms.date: 11/25/2025
ms.topic: how-to
ms.custom: azure-operator-nexus, template-include
---

# Azure Operator Nexus Fabric runtime upgrade template

This how-to guide provides a step-by-step template for upgrading an Azure Operator Nexus Network Fabric instance. Use this template to manage a reproducible end-to-end upgrade through Azure APIs and standard operating procedures. Regularly update your system to maintain integrity and access the latest product improvements.

## Overview
<details>

### Runtime bundle components

These components require operator consent for upgrades that might affect traffic behavior or necessitate device reboots. The network fabric's design allows you to apply updates while maintaining continuous data traffic flow.

Runtime changes are divided into the following categories:

- **Operating system updates**: Necessary to support new features or resolve issues.
- **Base configuration updates**: Initial settings applied during device bootstrapping.
- **Configuration structure updates**: Generated based on user input for configuration.

</details>

## Prerequisites
<details>

- Latest version of the [Azure CLI](https://aka.ms/azcli).
- Latest `managednetworkfabric` [CLI extension](howto-install-cli-extensions.md).
- Latest `networkcloud` [CLI extension](howto-install-cli-extensions.md).
- Subscription access to run the Azure Operator Nexus Network Fabric and Network Cloud CLI extension commands.
- Target fabric must be healthy and in a running state. Learn more about how to check the health of a fabric in [Network Fabric runtime upgrade](./howto-upgrade-nexus-fabric.md#required-preupgrade-validations).

</details>

## Required parameters
<details>

- `\<ENVIRONMENT\>`: Instance name.
- `<AZURE_REGION>`: Azure region of the instance.
- `<CUSTOMER_SUB_NAME>`: Subscription name.
- `<CUSTOMER_SUB_ID>`: Subscription ID.
- `\<NEXUS_VERSION\>`: Azure Operator Nexus release version (for example, `2504.1`).
- `<NNF_VERSION>`: Azure Operator Nexus Fabric release version (for example, `8.1`).
- `<NF_VERSION>`: Network Fabric runtime version for the upgrade (for example, `5.0.0`).
- `<NFC_NAME>`: Associated Network Fabric controller.
- `<NFC_RG>`: Network Fabric controller resource group.
- `<NFC_RID>`: Network Fabric controller Azure Resource Manager ID.
- `<NFC_MRG>`: Network Fabric controller managed resource group.
- `<NF_NAME>`: The fabric name.
- `<NF_RG>`: Network Fabric resource group.
- `<NF_RID>`: Network Fabric Resource Manager ID.
- `<NF_DEVICE_NAME>`: Network Fabric device name.
- `<NF_DEVICE_RID>`: Network Fabric device resource ID.
- `<CM_NAME>`: Associated cluster manager.
- `<CLUSTER_NAME>`: Associated cluster name.
- `<MISE_CID>`: `Microsoft.Identity.ServiceEssentials` (MISE) correlation ID in the debug output for device updates.
- `<CORRELATION_ID>`: Operation correlation ID in the debug output for device updates.
- `<ASYNC_URL>`: Asynchronous URL in the debug output for device updates.

</details>

## Deployment data
<details>

```
- Nexus: <NEXUS_VERSION>
- NC: <NC_VERSION>
- NF: <NF_VERSION>
- Subscription Name: <CUSTOMER_SUB_NAME>
- Subscription ID: <CUSTOMER_SUB_ID>
- Tenant ID: <CUSTOMER_SUB_TENANT_ID>
```

</details>

## Debug information for Azure CLI commands
<details>

Azure CLI deployment commands issued with the `--debug` value contain the following information in the command output:

```
cli.azure.cli.core.sdk.policies:     'mise-correlation-id': '<MISE_CID>'
cli.azure.cli.core.sdk.policies:     'x-ms-correlation-request-id': '<CORRELATION_ID>'
cli.azure.cli.core.sdk.policies:     'Azure-AsyncOperation': '<ASYNC_URL>'
```

To view the status of long-running asynchronous operations, run the following command with `az rest`:

```
az rest -m get -u '<ASYNC_URL>'
```

Command status information is returned along with detailed informational or error messages:

- `"status": "Accepted"`
- `"status": "Succeeded"`
- `"status": "Failed"`

If you experience any failures, open a support request. Report the values for `<MISE_CID>` and `<CORRELATION_ID>`, the status code, and detailed messages.

</details>

## Pre-checks
<details>

1. Validate the provisioning status for the Network Fabric controller, Network Fabric instance, and Network Fabric devices.

   Sign in to the Azure CLI and select or set the `<CUSTOMER_SUB_ID>` value:

   ```
   az login
   az account set --subscription <CUSTOMER_SUB_ID>
   ```

   Make sure that the Network Fabric controller is in a provisioned state:

   ```
   az networkfabric controller show -g <NFC_RG> --resource-name <NFC_NAME> --subscription <CUSTOMER_SUB_ID> -o table
   ```

   Check the status of the Network Fabric instance:

   ```
   az networkfabric fabric show -g <NF_RG> --resource-name <NF_NAME> --subscription <CUSTOMER_SUB_ID> -o table
   ```

   Record the values for `fabricVersion` and `provisioningState`.

   Check the status of the devices.

   ```
   az networkfabric device list -g <NF_RG> -o table --subscription <CUSTOMER_SUB_ID>
   ```

   > [!NOTE]
   > If `provisioningState` doesn't have a value of `Succeeded`, stop the upgrade until you resolve the problems.

2. The minimum available disk space on each device must be more than 3.5 GB for a successful device upgrade.

   Verify the available space on each Network Fabric device by using the following Azure CLI command:

   ```
   az networkfabric device run-ro --resource-name <NF_DEVICE_NAME> --resource-group <NF_RG> --ro-command "show file systems" --subscription <CUSTOMER_SUB_ID> --debug
   ```

   Contact Microsoft support if there's not enough space to perform the upgrade. The support team can help you remove archived extensible operating system images and support bundle files.

3. In the Azure portal, check the fabric's network packet broker (NPB) for any orphaned network taps.

   1. Select **Network Fabric** under **Azure Services**, and then select **<NF_NAME>**.

   1. Select the appropriate resource group for the fabric.

   1. In the **Resources** list, select the **Network Packet Broker** filter, and then select the appropriate name from the list.

   1. Select the **Network Taps** tab on the **Overview** screen. All network taps should have a status of **Succeeded** for **Configuration State** and **Provisioning State**.

   1. Look for any taps with a red X, and a status of **Not Found**, **Failed**, or **Error**.

   > [!NOTE]
   > If any taps show a status of **Not Found**, **Failed**, or **Error**, stop the upgrade until you clear these problems. Provide this information to Microsoft support when you open a support ticket.

4. Run and validate the Network Fabric cable validation report. See details: [Validate cables for Azure Operator Nexus Network Fabric](how-to-validate-cables.md).

   > [!NOTE]
   > Resolve any connection and cable problems before you continue the upgrade.

5. Review the Azure Operator Nexus release notes for the required checks and configuration updates that aren't included in this article.

</details>

## Upgrade procedure
<details>

### Verify the current Network Fabric runtime version

[Check the current cluster runtime version.](./howto-check-runtime-version.md#check-current-fabric-runtime-version)

```
az networkfabric fabric list -g <NF_RG> --query "[].{name:name,fabricVersion:fabricVersion,configurationState:configurationState,provisioningState:provisioningState}" -o table --subscription <CUSTOMER_SUB_ID>
az networkfabric fabric show -g <NF_RG> --resource-name <NF_NAME> --subscription <CUSTOMER_SUB_ID>
```

### Initiate the Network Fabric upgrade

Start the upgrade by running the following command:

```Azure CLI
az networkfabric fabric upgrade -g <NF_RG> --resource-name <NF_NAME> --subscription <CUSTOMER_SUB_ID> --action start --version "6.0.0"
{}
```

The upgrade is successful if you get an output that shows `{}`.

The Network Fabric resource provider validates whether your existing Network Fabric version can be upgraded to the target version. Only N+1 major release upgrades are allowed (for example, `5.0.0` to `6.0.0`).

After the command finishes successfully, it changes the Network Fabric status to **Under Maintenance** and prevents any other operation on the fabric.

### Follow the device-specific workflow

Azure Operator Nexus Network Fabric racks include the following device types:

- Customer edge switch (CE)
- Management switch (MGMT)
- Top-of-rack switch (TOR)
- Network packet broker (NPB)

Eight-rack environments have 30 devices:

- **Aggregate rack**: Two CEs, two NPBs, and two MGMTs (six devices total).
- **Eight compute racks**: Each compute rack has two TORs and one MGMT (24 devices total).

Four-rack environments have 17 devices:

- Aggregate rack: Two CEs, one NPB, and two MGMTs (five devices total).
- Four compute racks: Each compute rack has two TORs and one MGMT (12 devices total).

To maintain networking service during the upgrade, upgrade the devices in the following order:

1. Compute rack odd-numbered TORs: Upgrade together in parallel.
1. Compute rack even-numbered TORs: Upgrade together in parallel.
1. Compute rack MGMT switches: Upgrade together in parallel.
1. Aggregate rack CEs: Upgrade one after the other in serial.

   > [!IMPORTANT]
   > After each CE upgrade, wait for a duration of five minutes to ensure that the recovery process is complete before proceeding to the next CE.
   >
   > For the remaining aggregate rack devices, the order for the device upgrades isn't important as long as you upgrade them in a serial manner.

1. Aggregate rack NPBs: Upgrade one after the other in serial.
1. Aggregate rack MGMTs: Upgrade one after the other in serial.

> [!NOTE]
> Wait for a successful upgrade to finish on all the devices in a group before moving to the next group.

### Follow device-specific upgrades

Run the following command to upgrade the version on each device:

```
az networkfabric device upgrade --version <NF_VERSION> -g <NF_RG> --resource-name <NF_DEVICE_NAME> --subscription <CUSTOMER_SUB_ID> --debug
```

As part of the upgrade, the devices enter maintenance mode. The device drains all traffic and stops advertising routes so that the traffic flow to the device stops. When the upgrade finishes, the Azure Operator Nexus Network Fabric service updates the device resource version property to the new version.

Gather the information for `ASYNC_URL` and `CORRELATION_ID`, so that you have it if you need to troubleshoot in the future.

```
cli.azure.cli.core.sdk.policies:     'mise-correlation-id': '<MISE_CID>'
cli.azure.cli.core.sdk.policies:     'x-ms-correlation-request-id': '<CORRELATION_ID>'
cli.azure.cli.core.sdk.policies:     'Azure-AsyncOperation': '<ASYNC_URL>'
```

Provide this information to Microsoft support when you open a support ticket for upgrade problems.

After you finish upgrading devices, make sure that they all show `<NF_VERSION>` by running the following command:

```
az networkfabric device list -g <NF_RG> --query "[].{name:name,version:version}" -o table --subscription <CUSTOMER_SUB_ID>
```

### Complete the Network Fabric upgrade

After all the devices are upgraded, run the following command to take the Network Fabric out of the maintenance state.

```
az networkfabric fabric upgrade --action Complete --version <NF_VERSION> -g <NF_RG> --resource-name <NF_NAME> --debug --subscription <CUSTOMER_SUB_ID>
```

### Troubleshoot device update failures

1. Collect any errors in the Azure CLI output.

1. Collect the device operation state from the Azure portal or the Azure CLI.

1. Create an Azure support request for any device upgrade failures. Attach any errors along with `ASYNC_URL`, `CORRELATION_ID`, and the operation state of the fabric and the devices.

</details>

## Post-upgrade tasks
<details>

### Review Azure Operator Nexus release notes

Review the Azure Operator Nexus release notes for any version-specific actions that are required after the upgrade.

### Validate the Azure Operator Nexus instance

Perform resource validation of all Azure Operator Nexus instance components by using the Azure CLI:

```
# Check `ProvisioningState = Succeeded` in all resources

# NFC
az networkfabric controller list -g <NFC_RG> --subscription <CUSTOMER_SUB_ID> -o table
az customlocation list -g <NFC_MRG> --subscription <CUSTOMER_SUB_ID> -o table

# Fabric
az networkfabric fabric list -g <NF_RG> --subscription <CUSTOMER_SUB_ID> -o table
az networkfabric rack list -g <NF_RG> --subscription <CUSTOMER_SUB_ID> -o table
az networkfabric fabric device list -g <NF_RG> --subscription <CUSTOMER_SUB_ID> -o table
az networkfabric nni list -g <NF_RG> --fabric <NF_NAME> --subscription <CUSTOMER_SUB_ID> -o table
az networkfabric acl list -g <NF_RG> --fabric <NF_NAME> --subscription <CUSTOMER_SUB_ID> -o table
az networkfabric l2domain list -g <NF_RG> --fabric <NF_NAME> --subscription <CUSTOMER_SUB_ID> -o table

# CM
az networkcloud clustermanager list -g <CM_RG> --subscription <CUSTOMER_SUB_ID> -o table

# Cluster
az networkcloud cluster list -g <CLUSTER_RG> --subscription <CUSTOMER_SUB_ID> -o table
az networkcloud baremetalmachine list -g <CLUSTER_MRG> --subscription <CUSTOMER_SUB_ID> --query "sort_by([]. {name:name,kubernetesNodeName:kubernetesNodeName,location:location,readyState:readyState,provisioningState:provisioningState,detailedStatus:detailedStatus,detailedStatusMessage:detailedStatusMessage,cordonStatus:cordonStatus,powerState:powerState,machineRoles:machineRoles| join(', ', @),createdAt:systemData.createdAt}, &name)" -o table
az networkcloud storageappliance list -g <CLUSTER_MRG> --subscription <CUSTOMER_SUB_ID> -o table

# Tenant Workloads
az networkcloud virtualmachine list --sub <CUSTOMER_SUB_ID> --query "reverse(sort_by([?clusterId=='<CLUSTER_RID>'].{name:name, createdAt:systemData.createdAt, resourceGroup:resourceGroup, powerState:powerState, provisioningState:provisioningState, detailedStatus:detailedStatus,bareMetalMachineId:bareMetalMachineIdi,CPUCount:cpuCores, EmulatorStatus:isolateEmulatorThread}, &createdAt))" -o table
az networkcloud kubernetescluster list --sub <CUSTOMER_SUB_ID> --query "[?clusterId=='<CLUSTER_RID>'].{name:name, resourceGroup:resourceGroup, provisioningState:provisioningState, detailedStatus:detailedStatus, detailedStatusMessage:detailedStatusMessage, createdAt:systemData.createdAt, kubernetesVersion:kubernetesVersion}" -o table
```

</details>

## Related content

<details>

- [Access the Azure portal](https://aka.ms/nexus-portal)
- [Install the Azure CLI](https://aka.ms/azcli)
- [Install the CLI extension](howto-install-cli-extensions.md)
- [Network Fabric Upgrade](howto-upgrade-nexus-fabric.md)

</details>
