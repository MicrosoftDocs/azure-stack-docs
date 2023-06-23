---
title: Troubleshoot Software Defined Networking deployment via Windows Admin Center
description: Learn how to troubleshoot the deployment of Software Defined Networking (SDN) via Windows Admin Center.
ms.topic: how-to
ms.author: alkohli
author: alkohli
ms.date: 06/02/2023
---

# Troubleshoot Software Defined Networking deployment via Windows Admin Center

> Applies to: Azure Stack HCI, versions 22H2, 21H2, and 20H2; Windows Server 2022, Windows Server 2019

You can deploy Software Defined Networking (SDN) on Azure Stack HCI using [SDN Express PowerShell scripts](../manage/sdn-express.md) or using Windows Admin Center either [as part of the cluster creation workflow](../deploy/create-cluster.md#step-5-sdn-optional) or [after creating a cluster](../deploy/sdn-wizard.md).

This article provides guidance on how to troubleshoot issues that you may encounter while deploying the SDN components using Windows Admin Center. Use this guidance to troubleshoot the issues before creating a support ticket. This article also provides instructions on how to collect logs after successfully troubleshooting the issues to help diagnose the cause of deployment failure.

## Troubleshoot timeout error

If the deployment of virtual machines (VM) for the various SDN components, including Network Controller, Software Load Balancer, or Gateway times out, you see the following error:

*....is not ready after the 1800 second timeout.*

You may see this message in Windows Admin Center during the deployment of Network Controller, Software Load Balancer, or Gateway.

To identify and troubleshoot the cause of the failure in your SDN deployment through Windows Admin Center, perform the following checks:

- [Confirm that you've downloaded the correct VHDX file](#download-the-correct-vhdx-file).

- [Verify the connectivity of your management network VLAN](#verify-the-connectivity-of-your-management-network-vlan).

- [Ensure that Windows Defender and firewall policies permit WinRM connectivity from the Windows Admin Center VM to the Network Controller VMs](#ensure-that-windows-defender-and-firewall-policies-permit-winrm-connectivity).

- [Verify connectivity to the SDN URI or SDN cluster](#verify-connectivity-to-the-sdn-uri-or-sdn-cluster).

After you've completed these checks and resolved any identified issues through troubleshooting, proceed with deploying SDN again. We also recommend [collecting logs](#collect-logs-for-sdn-components) to determine why the deployment of an SDN VM had failed.

### Download the correct VHDX file

You must download a virtual hard disk of the Azure Stack HCI operating system to use for the SDN infrastructure VMs (Network Controller, Software Load Balancer, Gateway). For download instructions, see [Download the VHDX file](../deploy/sdn-wizard.md#download-the-vhdx-file).

### Verify the connectivity of your management network VLAN

If there's no connectivity between the management network VLAN and Azure Stack HCI, the VM deployment times out.

Follow these steps to verify connectivity of the management network VLAN:

1. Make sure you have access to an existing Azure Stack HCI cluster and management network VLAN.

1. In Windows Admin Center, [create a new VM](./vm.md#create-a-new-vm) on the Azure Stack HCI cluster with any supported operating system.

1. Assign the same IP address to the new VM that was assigned to the management network.

1. Configure the same VLAN for the new VM on the host where the VM is located.

1. To confirm the new VM is assigned the correct IP address and to rule out any duplicate address issues, run the `ipconfig /all` command on the new VM.

1. Verify the new VM can ping the Azure Stack HCI hosts and vice versa.

1. Check if the new VM can communicate with the DNS servers and the default gateway of the management network.

1. Join the new VM to the same domain using the same credentials provided during SDN VM deployment.

### Ensure that Windows Defender and firewall policies permit WinRM connectivity

You must enable Windows Remote Management (WinRM) and PowerShell remoting to start configuration on the Network Controller VMs that have been deployed. If this is not done, a timeout error occurs.

To verify or enable WinRM and PowerShell remoting, perform these steps:

1. In Windows Admin Center, establish a remote PowerShell with the Network Controller VM.
    
    ```powershell
    Enter-PSSession NCVMExample
    ```

    -  If you're able to enter the remote session, it indicates that the network policies are set by your domain administrator. To successfully deploy SDN via Windows Admin Center, review these policies and ensure that they allow WinRM and PowerShell remoting.
    
    - If you receive the following WinRM error message, proceed further in this section to resolve the error. Example error message:

       `Enter-PSSession : Connecting to remote server NCVMExample failed with the following error message : WinRM cannot complete the operation.  Verify that the specified computer name is valid, that the computer is accessible over the network, and that a firewall exception for the WinRM service is enabled and allows access from this computer.  By default, the WinRM firewall exception for public profiles limits access to remote computers within the same local subnet.`

1. Log into one of the Network Controller VMs either locally or using Remote Desktop Protocol (RDP) connection.

1. Run the following command to disable the Windows firewall:

    ```powershell
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
    ```

1. In Windows Admin Center, establish a remote PowerShell session again to the Network Controller VM:

    ```powershell
    Enter-PSSession NCVMExample
    ```

1. If you're able to enter the remote session, as a temporary measure, you can disable the firewall on the remaining Network Controller VMs to complete the SDN deployment. However, this configuration change may revert once Group Policy updates are applied.

### Verify connectivity to the SDN URI or SDN cluster

The SDN URI and cluster name are useful when Windows Admin Center connects for the first time to the SDN environment and when you run PowerShell cmdlets against Network Controller.

If you're unable to connect to the SDN URI or the cluster name, ensure that dynamic DNS is enabled. For information on how to enable dynamic DNS, see [Dynamic DNS updates](../concepts/network-controller.md#dynamic-dns-updates).

After enabling dynamic DNS, you may be able to move the `SDNAPI` microservice by completing the following steps for registration to take place:

1. In Windows Admin Center, establish a remote PowerShell with the Network Controller VM.

    ```powershell
    Enter-PSSession NCVMExample
    ```

1. Run the following command to establish connection to the Service Fabric Cluster on the Network Controller VM.

    ```powershell
    Connect-ServiceFabricCluster
    ```

1. Run the following command to move the `SDNAPI` microservice:

    ```powershell
    Move-ServiceFabricPrimaryReplica -ServiceName fabric:/NetworkController/ApiService
    ```

1. Wait for around five minutes and then ping the Network Controller URI name.

    ```powershell
    Ping nchci.contoso.com
    ```

## Collect logs for SDN components

After successfully troubleshooting the deployment issue, we recommend collecting logs to determine why the deployment of an SDN VM had failed.

Follow these steps to collect guest logs for the SDN VM:

1. Using Windows Admin Center or Hyper-V host, connect to the SDN VM for which you want to collect logs.

    > [!TIP]
    > If you don't see the "Hyper-V" screen after logging in to the VM using the Hyper-V host, press the Shift + F10 keys to open a command prompt.

1. Go to the C: drive and collect the answer file (**unattend.xml**).

1. To get VM deployment history details, go to the C:\Windows\Panther folder and collect the entire content of this folder.

1. To collect SDN logs on the server, connect to the first physical node of the Azure Stack HCI cluster. Find the SDN log file under **Tools** > **Files & file sharing** > **This PC** > **C:** > **Documents and Settings**.

## Next steps

- [Contact Microsoft Support](get-support.md)