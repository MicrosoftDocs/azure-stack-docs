---
title: Start and stop
titleSuffix: Azure Stack Hub
description: Learn how to start and stop Azure Stack Hub.
author: mattbriggs

ms.service: azure-stack
pms.tgt_pltfrm: na
ms.topic: article
ms.date: 10/02/2019
ms.author: mabrigg
ms.reviewer: misainat
ms.lastreviewed: 10/15/2018
---

# Start and stop Azure Stack Hub

Follow the procedures in this article to properly shut down and restart Azure Stack Hub services. *Stop* will physically shut down and power off the entire Azure Stack Hub environment. *Start* powers on all infrastructure roles and returns tenant resources to the power state they were in before shutdown.

## Stop Azure Stack Hub

Stop or shut down Azure Stack Hub with the following steps:

1. Prepare all workloads running on your Azure Stack Hub environment's tenant resources for the upcoming shutdown.

2. Open a privileged endpoint session (PEP) from a machine with network access to the Azure Stack Hub ERCS VMs. For instructions, see [Using the privileged endpoint in Azure Stack Hub](azure-stack-privileged-endpoint.md).

3. From the PEP, run:

    ```powershell
      Stop-AzureStack
    ```

4. Wait for all physical Azure Stack Hub nodes to power off.

> [!Note]
> You can verify the power status of a physical node by following the instructions from the original equipment manufacturer (OEM) who supplied your Azure Stack Hub hardware.

## Start Azure Stack Hub

Start Azure Stack Hub with the following steps. Follow these steps regardless of how Azure Stack Hub stopped.

1. Power on each of the physical nodes in your Azure Stack Hub environment. Verify the power on instructions for the physical nodes by following the instructions from the OEM who supplied the hardware for your Azure Stack Hub.

2. Wait until the Azure Stack Hub infrastructure services starts. Azure Stack Hub infrastructure services can require two hours to finish the start process. You can verify the start status of Azure Stack Hub with the [**Get-ActionStatus** cmdlet](#get-the-startup-status-for-azure-stack-hub).

3. Ensure that all of your tenant resources have returned to the state they were in before shutdown. Workloads running on tenant resources may need to be reconfigured after startup by the workload manager.

## Get the startup status for Azure Stack Hub

Get the startup for the Azure Stack Hub startup routine with the following steps:

1. Open a privileged endpoint session from a machine with network access to the Azure Stack Hub ERCS VMs.

2. From the PEP, run:

    ```powershell
      Get-ActionStatus Start-AzureStack
    ```

## Troubleshoot startup and shutdown of Azure Stack Hub

Take the following steps if the infrastructure and tenant services don't successfully start two hours after you power on your Azure Stack Hub environment.

1. Open a privileged endpoint session from a machine with network access to the Azure Stack Hub ERCS VMs.

2. Run:

    ```powershell
      Test-AzureStack
      ```

3. Review the output and resolve any health errors. For more information, see [Run a validation test of Azure Stack Hub](azure-stack-diagnostic-test.md).

4. Run:

    ```powershell
      Start-AzureStack
    ```

5. If running **Start-AzureStack** results in a failure, contact Microsoft Support.

## Next steps

Learn more about [Azure Stack Hub diagnostic tools](azure-stack-configure-on-demand-diagnostic-log-collection.md#use-the-privileged-endpoint-pep-to-collect-diagnostic-logs)
