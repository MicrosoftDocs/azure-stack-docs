---
title: Single node deployment
description: Learn how to deploy AKS on a single machine.
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/07/2022
ms.custom: template-how-to
---

# Single machine deployment

You can deploy AKS on the light edge on either a single machine or on multiple machines. In a simple deployment, both the Kubernetes control node and worker node run on the same machine, which is your primary machine. This article describes how to create the Kubernetes control node on your machine on a private network.

## Prerequisites

Set up your primary machine as described in the [Setup article](aks-lite-howto-setup-machine.md).

## Create a single-node cluster

You can run the `New-AksLiteDeployment` cmdlet to deploy a single-machine AksIot cluster with a single Linux control-plane node. You can do so by providing your values in a JSON file. You can run the command `New-AksEdgeDeploymentConfig` to create a sample JSON `mydeplyconfig.json` with the default parameters and edit this file to provide your own values.

 ```powershell
    #create a deployconfig file with defaults
    $jsonString = New-AksEdgeDeploymentConfig -outFile .\mydeployconfig.json
```

You can edit mydeployconfig.json with the parameters you need and pass the json config for deployment. To get a **full list** of the parameters and their default values, run `Get-Help New-AksEdgeDeployment -full` in your PowerShell window. You can then use this file in your deployment.

```powershell
New-AksEdgeDeployment -JsonConfigFilePath .\mydeployconfig.json
```

Alternatively, you can programmatically edit the json object and pass it as a string

```powershell
$jsonString = New-AksEdgeDeploymentConfig -outFile .\mydeployconfig.json
$jsonObj = $jsonString | ConvertFrom-Json 
$jsonObj.EndUser.AcceptEula = $true
$jsonObj.EndUser.AcceptOptionalTelemetry = $true
$jsonObj.LinuxVm.CpuCount = 4
$jsonObj.LinuxVm.MemoryInMB = 4096
$jsonObj.Network.ServiceIpRangeSize = 10

New-AksEdgeDeployment -JsonConfigString ($jsonObj | ConvertTo-Json)
```

Some of the common parameters and their default values as follows:

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| WorkloadType | `Linux` or `LinuxAndWindows` | `Linux` creates the Linux control plane. You cannot specify `Windows` because the control plane node needs to be Linux. Read more about [AKS edge workload types](/docs/AKS-Edge-Concepts.md#aks-iot-workload-types) *(Note: In order to deploy Windows worker node, you need to opt the Windows VHDX into your MSI installer. Learn how to do this [here](/docs/set-up-machines.md).)* | `Linux` |
| NetworkPlugin | `calico` or `flannel` | CNI plugin choice for the Kubernetes network model. | `flannel` |
| LinuxVm.CpuCount | `number` | Number of CPU cores reserved for Linux VM/VMs. | `2` |
| LinuxVm.MemoryInMB | `number` | RAM in MBs reserved for Linux VM/VMs. | `2048` |
| LinuxVm.DataSizeInGB | `number` | Size of the data partition. For large applications, we recommend  | `10` |
| ServiceIPRangeSize | `number` | Define a service IP range for your workloads. We recommend you reserve some IP range (ServiceIPRangeSize > 0) for your Kubernetes services.| `0` |

**Example deployment options:**

* **Create a simple cluster without a load balancer** You could also create a very simple cluster with no service IPs. You cannot create a LoadBalancer service in this approach.

    ```powershell
    New-AksEdgeDeployment -JsonConfigString (New-AksEdgeDeploymentConfig)
    ```

* **Allocate resources to your nodes** To connect to Arc and deploy your apps with GitOps, please allocate **four CPUs** or more for the `LinuxVm.CpuCount` (processing power), **4GB** or more**for `LinuxVm.MemoryinMB` (RAM) and to**assign a number > 0** to the `ServiceIpRangeSize`. Here, we simply allocate 10 IP addresses for your Kubernetes services.

    ```json
        "DeployOptions": {
            "NetworkPlugin": "flannel",
            "SingleMachineCluster": true,
            "WorkloadType": "Linux"
        },
        "EndUser": {
            "AcceptEula": true,
            "AcceptOptionalTelemetry": true
        },
        "LinuxVm": {
            "CpuCount": 4,
            "MemoryInMB": 4096
        },
        "Network": {
            "ServiceIPRangeRange": 10
        }
    ```

    ```powershell
    #create a deployconfig file with defaults
    $jsonString = New-AksEdgeDeploymentConfig -outFile .\mydeployconfig.json
    #Edit mydeployconfig.json with the parameters you need and pass the json config for deployment
    New-AksEdgeDeployment -JsonConfigFilePath .\mydeployconfig.json
    ```

    Alternatively, you can programmatically edit the json object and pass it as a string

    ```powershell
    $jsonString = New-AksEdgeDeploymentConfig -outFile .\mydeployconfig.json
    $jsonObj = $jsonString | ConvertFrom-Json 
    $jsonObj.EndUser.AcceptEula = $true
    $jsonObj.EndUser.AcceptOptionalTelemetry = $true
    $jsonObj.LinuxVm.CpuCount = 4
    $jsonObj.LinuxVm.MemoryInMB = 4096
    $jsonObj.Network.ServiceIpRangeSize = 10

    New-AksEdgeDeployment -JsonConfigString ($jsonObj | ConvertTo-Json)
    ```

> **NOTE**:
> We will carve out IP addresses from your internal switch to run your Kubernetes services if you specified a ServiceIPRangeSize.

* **Create a mixed workload cluster**  - You can also deploy mixed-workloads clusters. Here we show you bring up both Linux and Windows workloads at the same time.

    ```json
        "DeployOptions": {
            "NetworkPlugin": "flannel",
            "SingleMachineCluster": true,
            "WorkloadType": "LinuxAndWindows"
        },
        "EndUser": {
            "AcceptEula": true,
            "AcceptOptionalTelemetry": true
        },
        "LinuxVm": {
            "CpuCount": 4,
            "MemoryInMB": 4096
        },
        "WindowsVm": {
            "CpuCount": 2,
            "MemoryInMB": 4096
        },
        "Network": {
            "ServiceIPRangeRange": 10
        }
    ```

    ```powershell
    $jsonString = New-AksEdgeDeploymentConfig .\mydeployconfig.json
    $jsonObj = $jsonString | ConvertFrom-Json 
    $jsonObj.EndUser.AcceptEula = $true
    $jsonObj.EndUser.AcceptOptionalTelemetry = $true
    $jsonObj.DeployOptions.WorkloadType = "LinuxAndWindows"
    $jsonObj.LinuxVm.CpuCount = 4
    $jsonObj.LinuxVm.MemoryInMB = 4096
    $jsonObj.WindowsVm.CpuCount = 2
    $jsonObj.WindowsVm.MemoryInMB = 4096
    $jsonObj.Network.ServiceIpRangeSize = 10

    New-AksEdgeDeployment -JsonConfigString ($jsonObj | ConvertTo-Json)

    ```

## Validate your cluster

Confirm that the deployment was successful by running:

```powershell
kubectl get nodes -o wide
kubectl get pods -A -o wide
```

![Screenshot showing all pods running](./media/aks-lite/all-pods-running.png)

> [!NOTE]
This screenshot is for a k3s cluster so the pods will look different for k8s.

## Optionally, add a Windows node

If you would like to add Windows workloads to an existing Linux only single machine cluster, you can run:

```powershell
Add-AksEdgeNode -WorkloadType Windows
```

You can also specify parameters like `CpuCount` and/or `MemoryInMB` for your Windows VM here.

## Alternate option : AksEdgeDeploy(Aide)

We have also included AksEdgeDeploy(Aide) module to help you automate the installation, deployment and provisioning of AKS edge with the json specification. We have included a sample json for quick deployment as well as a template json that you can fill out to specify your own parameters. This is designed to support **remote deployment** scenarios. Learn more about [GitHub repo](https://github.com/Azure/AKS-IoT-preview/blob/main/docs).

## Next steps

* [Deploy your application](./aks-lite-howto-deploy-app.md).
* [Overview](./aks-lite-overview.md)
* [Uninstall AKS cluster](./aks-lite-howto-uninstall.md)
