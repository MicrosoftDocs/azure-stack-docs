---
title: Connect to VM Serial Console Using Azure CLI on Azure Local
description: Learn how to connect to the serial console of an Azure Local Multi Rack VM using Azure Command-line Interface (CLI).
author: alkohli
ms.author: alkohli
ms.date: 03/12/2026
ms.topic: how-to
ms.service: azure-local
#customer intent: As an Azure Local administrator, I want to connect to a VM serial console using Azure CLI so that I can troubleshoot and manage VM boot and console issues.
---

# Connect to a VM serial console using Azure CLI on multi-rack deployments of Azure Local

This article describes how to connect to the serial console of an Azure Local virtual machine (VM) in a multi-rack deployment using the Azure CLI.

Serial console provides access to a text-based console for VMs running Linux or Windows Server. It connects to VM's COM1 serial port, giving you direct console access independent of the VM's network state. This is useful for troubleshooting boot issues, fixing misconfigured networking, or recovering a VM that is otherwise unreachable via RDP or SSH. On Azure Local multi-rack deployments, serial console access is available through Azure CLI.

> [!NOTE]
> Windows client versions don't include Special Administration Console (SAC). As a result, serial console access is supported for Windows Server editions and Linux VMs.

## Prerequisites

- The name and resource group of your Azure Local multi-rack cluster's Arc-connected Kubernetes resource.

- A proxy session started to your Azure Local multi-rack cluster's Arc-connected Kubernetes resource using `az connectedk8s proxy` (see Start the proxy).

- Azure RBAC role assignments for your Microsoft Entra entity on the Azure Local multi-rack cluster's Arc-connected Kubernetes resource. Get the object ID for your Microsoft Entra entity, then create the required role assignments.

   1. Get the Microsoft Entra entity ID:

      **For a Microsoft Entra group:**

       ```azurecli
       AAD_ENTITY_ID=$(az ad group show --group <group-name> --query id -o tsv)
       ```

      **For a single user account (gets the user principal name):**

       ```azurecli
       AAD_ENTITY_ID=$(az ad signed-in-user show --query userPrincipalName -o tsv)
       ```

       **For a Microsoft Entra application:**

       ```azurecli
       AAD_ENTITY_ID=$(az ad sp show --id <id> --query id -o tsv)
       ```

   2. Create the role assignments:

       ```azurecli
       az role assignment create --role "Azure Arc Kubernetes Viewer" --assignee $AAD_ENTITY_ID --scope $ARM_ID_CLUSTER
       az role assignment create --role "Azure Arc Enabled Kubernetes Cluster User Role" --assignee $AAD_ENTITY_ID --scope $ARM_ID_CLUSTER
       ```

   3. Replace `$ARM_ID_CLUSTER` with the ARM resource ID of your Azure Local multi-rack cluster's Arc-connected Kubernetes resource (for example, `/subscriptions/<sub-id>/resourceGroups/<rg>/providers/Microsoft.Kubernetes/connectedClusters/<cluster-name>`).

    > [!IMPORTANT]
    > You must have access to the VM serial console. Serial console access requires your Microsoft Entra identity to be explicitly granted permission on the VM serial console. 
   To get access, open a support ticket with Microsoft Support and provide:
    - The VM name.
    - Your Microsoft Entra group ID (recommended, so you can manage access by changing group membership) or your user Microsoft Entra object ID.

## Install or verify Azure CLI extensions

The commands in this workflow use these Azure CLI extensions:

- `stack-hci-vm` for `az stack-hci-vm ...` commands.

- `connectedk8s` for `az connectedk8s proxy`.

1. Verify your Azure CLI version (the extension metadata requires Azure CLI core version 2.15.0 or later):

   ```azurecli
   az version
   ```

1. Install the required extensions (or update them if they're already installed):

   ```azurecli
   az extension add --name stack-hci-vm
   az extension add --name connectedk8s
   ```

1. Verify both extensions are installed:

   ```azurecli
   az extension show --name stack-hci-vm
   az extension show --name connectedk8s
   ```

## Sign in

Sign in:

   ```azurecli
   az login --use-device-code
   ```

## Start the proxy session

To connect to a VM serial console, start a proxy session to your Azure Local multi-rack cluster's Arc-connected Kubernetes resource.

```azurecli
az connectedk8s proxy -n "<connected-cluster-name>" -g "<resource-group>" --subscription "<Subscription ID>"
```

For more information about `az connectedk8s proxy`, see [Access your cluster from a client device](/azure/azure-arc/kubernetes/cluster-connect?tabs=azure-cli#access-your-cluster-from-a-client-device).

## Connect to the serial console

Use `az stack-hci-vm serial-console connect` to connect to the serial console of an Azure Local multi-rack virtual machine.

```azurecli
az stack-hci-vm serial-console connect --name "<vm-name>" --resource-group "<resource-group>" --subscription "<Subscription ID>"
```

When you connect successfully, the console session indicates an escape sequence. Press `Ctrl+]` to exit the console session.

Console output is automatically filtered to remove Windows control sequences for better readability.

## Troubleshooting

| Issue | Resolution |
| --- | --- |
| `Config file not found` | Start the proxy by running `az connectedk8s proxy`. |
| `No proxy instance is running` | Start the proxy by running `az connectedk8s proxy`. |
| Proxy and VM resources are in different subscriptions, or a command can't find the expected resource. | Pass `--subscription` to both `az connectedk8s proxy` and `az stack-hci-vm serial-console connect`. |
| `401 Unauthorized` / `Token is expired` | The proxy session token has expired. Close the current `az connectedk8s proxy` session and start a new one. |
| `403 Forbidden` / `Failed to list VirtualMachineInstances` | You don't have permissions on the connected cluster to list VMs. Verify your Azure RBAC role assignments (see [Prerequisites](#prerequisites)). |
| Authorization error | Confirm you have serial console access. If needed, open a support ticket with Microsoft Support and provide the VM name and either your Microsoft Entra group ID or user Microsoft Entra ID. |
| `404 Not Found` / `WebSocket error: Handshake status 404` | The VM is shut down or restarting. Ensure the VM is running before connecting. |
| `ResourceGroupNotFound` | The specified resource group doesn't exist. Verify the resource group name and subscription. |
| `ResourceNotFound` | The specified VM doesn't exist. Verify the VM name, resource group, and subscription. Run `az stack-hci-vm show --name "<vm-name>" --resource-group "<resource-group>" --subscription "<Subscription ID>"` to confirm. |
| `VM not found` | Verify the VM name, resource group, and subscription. Pass `--subscription` to `az stack-hci-vm serial-console connect`. |
| `No VMI found` | The VM exists but isn't running on the connected cluster. Ensure the VM is powered on and running. |
| `Another instance of proxy already running` | Close `az connectedk8s proxy` in other terminals. If that doesn't help, end the `arcProxyWindows.exe` process (or equivalent on your OS) in task manager, then retry. |
| `Port <port> is already in use` | Another process is using the port. Either free that port or run `az connectedk8s proxy` with a different `--port` value. |
| `Overage claim` / `users with more than 200 group membership` | Your account is in more than 200 groups, which isn't currently supported. Open a support ticket with Microsoft Support for a workaround. |

## Related content

- [Access your Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/cluster-connect?tabs=azure-cli#access-your-cluster-from-a-client-device)

- [Azure CLI `connectedk8s` command reference](/cli/azure/connectedk8s)
