---
title: Troubleshooting guide for issues in AKS enabled by Azure Arc on VMware (preview)
description: Learn how to troubleshoot issues and errors in AKS enabled by Arc on VMware.
ms.topic: how-to
ms.custom: devx-track-azurecli
author: sethmanheim
ms.date: 03/20/2024
ms.author: sethm 
ms.lastreviewed: 03/20/2024
ms.reviewer: leslielin
---

# Troubleshooting guide for issues in AKS enabled by Azure Arc on VMware

[!INCLUDE [aks-applies-to-vmware](includes/aks-hci-applies-to-skus/aks-applies-to-vmware.md)]

This article outlines troubleshooting steps for known issues and errors that can occur when deploying the AKS enabled by Azure Arc on VMware preview. You can also [review the known issues here](aks-vmware-known-issues.md) or follow the [troubleshooting overview](aks-vmware-support-troubleshoot.md) to report bugs or provide product feedback.

This page is continually updated, so check back here for new information. As we identify critical problems that require workarounds, we add them. Please review this information carefully before deploying your AKS Arc on VMware preview.

## Arc Resource Bridge

### Azure Arc resource bridge issues

For Azure Arc resource bridge issues, see the [troubleshooting guide here](/azure/azure-arc/resource-bridge/troubleshoot-resource-bridge).

### Recover from failed deployments of Arc Resource Bridge

See the [troubleshooting guide here](/azure/azure-arc/vmware-vsphere/quick-start-connect-vcenter-to-arc-using-script#recovering-from-failed-deployments).

### vCenter connection to Azure

If there's an error message that states "The resource bridge \<resource bridge name\> associated with this vCenter is currently unavailable. Operations performed on this vCenter may fail as a result," it indicates that the resource bridge used to connect the vCenter is either down or deleted.

To resolve the issue, follow these steps:

- If the Arc Resource Bridge is deleted, deploy it again.
- If the Arc Resource Bridge is down (offline), perform the disaster recovery steps listed in [Perform disaster recovery operations - Azure Arc](/azure/azure-arc/vmware-vsphere/recover-from-resource-bridge-deletion).

## Collect logs

If you encounter issues, you can share the log files and CLI version with support engineers for debugging purposes.

### Issues before Arc Resource Bridge deployment

Retrieve the **kva.log** file from the system at **c:\programdata\kva\kva.log** for more verbose information.

### Issues during Arc Resource Bridge deployment

To collect the logs, execute the following commands from the machine you previously used to attempt the deployment of the Arc resource bridge. Starting with CLI version 1.0.0, you must first run the command `az arcappliance get-credentials`. This ensures that all required credentials for log collection are pulled onto the machine. For more information about this command, see [the CLI documentation](/cli/azure/arcappliance#az-arcappliance-get-credentials):

```azurecli
az arcappliance get-credentials –name <name of Arc Resource Bridge> --resource-group <name of resource group>
```

After you run the `az arcappliance get-credentials` command, you can proceed with log collection using the [`az arcappliance logs vmware` command](/cli/azure/arcappliance/logs#az-arcappliance-logs-vmware):

```azurecli
az arcappliance logs vmware --ip <Arc Resource Bridge VM control plane IP endpoint> --address <vCenter FQDN/IP address, same one used when creating config files> --username <vcenter username> --password <vcenter password>
```

If you haven't yet created an appliance VM, the `az arcappliance logs vmware` command is not useful, and the log key file isn't generated.

### Issues when Arc Resource Bridge is up and running

To collect the logs, run the [`az arcappliance logs vmware` command](/cli/azure/arcappliance/logs#az-arcappliance-logs-vmware) from the same machine you used to deploy Arc Resource Bridge:

- If you have the kubeconfig for your appliance and the appliance VM is running with a reachable API server, the following command collects logs from the appliance and outputs a .zip file in the current working directory:

  ```azurecli
  az arcappliance logs vmware --kubeconfig='<path to your kubeconfig>'
  ```

- If you don't have the kubeconfig or your API server is unreachable, the following command collects logs using the specified appliance VM IP address (check your virtualization fabric; for example, Hyper-V manager, to locate the appliance VM IP address). Note that the `kubeconfig` parameter is still required but can be passed as an empty string if an IP is also provided:

  ```azurecli
  az arcappliance logs vmware --kubeconfig='' --ip='<IP address of Arc Resource Bridge VM>'
  ```

#### Examples with populated values

```azurecli
az arcappliance logs vmware --kubeconfig .\resourcebridge\kubeconfig
az arcappliance logs vmware --kubeconfig='kubeconfig'
az arcappliance logs vmware --kubeconfig='' --ip=10.0.1.166
```

### Get CLI extension version

You can return the appliance CLI extension version by running the following command:

```azurecli
az extension show --name arcappliance -o table
```

You must have a recent version of [Az CLI](/cli/azure/install-azure-cli) installed on all nodes in your physical cluster.

- Verify that you have Az CLI by running `az -v`.
- Upgrade to the latest version by running `az upgrade`.

## Error messages and troubleshooting steps

This section provides a list of common error messages and their troubleshooting steps.

### Error: "AlreadyDeployedError"

- **Root cause**: this error occurs because the environment has not been cleaned up from the previous deployment before attempting to deploy again.
- **Resolution**: to resolve this issue, uninstall Arc Resource Bridge, and then try to deploy again.

### Error: x509: certificate has expired or is not yet valid: current time \<time1\> is before \<time2\>. Check Failed

- **Root cause**: this error occurs when certificates expire due to a time mismatch between the client machine and VM (or ESXi server). One of them is not NTP-enabled.
- **Resolution**:
  1. Check if the time on the VM matches the time on the machine you used for ARB deployment.
  1. Connect the ESXi server to an NTP server to synchronize its time and resolve the issue.

### Error: The term 'az' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again

- **Root cause**: Az CLI is not recognized because the previous PowerShell window was closed and didn't synchronize with the installation of Azure CLI.
- **Resolution**:
  1. Open a new PowerShell window and navigate to the folder where you stored the Arc Resource Bridge onboarding script.
  1. Execute `.temp\.env\Scripts\Activate.ps1` to install Python venv.

## Next steps

- [AKS on VMware known issues](aks-vmware-known-issues.md)
- [Troubleshooting overview](aks-vmware-support-troubleshoot.md)
