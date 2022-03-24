---
title: Deploy virtual machinges using command line
description: Learn how to deploy an SDN infrastructure using Windows Admin Center
author: ManikaDhiman
ms.topic: how-to
ms.date: 02/14/2022
ms.author: v-mandhiman
ms.reviewer: JasonGerend
---

In this quickstart, you will set up Arc Resource Bridge for Arc VM
Management on Azure Stack HCI using Windows Admin Center. You will also
create a Custom Location for the Azure Stack HCI cluster. Use this
[documentation to use command line for
deployment](https://docs.microsoft.com/azure-stack/hci/manage/azure-arc-enabled-virtual-machines#install-powershell-modules-and-update-extensions)
instead.

Set up involves the following tasks:

-   Setting up Windows Admin Center

-   Setting up Arc Resource Bridge on Azure Stack HCI cluster for Arc VM
    Management

-   Creation Custom Location

-   Projecting Virtual Network & Images

Before getting started, make sure you\'ve satisfied all the
prerequisites on the [system
requirements](https://docs.microsoft.com/en-us/azure-stack/aks-hci/system-requirements) page.

## Set up Windows Admin Center

The deployment for Arc Resource Bridge is natively available as part of
the Windows Admin Center MSI. You can install Windows Admin Center
either on a Windows 10 machine or on a server. If you have already
installed Windows Admin Center, make sure your version is 2110.2 or
later. You can check your Windows Admin Center version by clicking on
the question mark on the top right hand corner. Also ensure you have the
latest version of the following extensions:

1.  Azure Kubernetes Service

2.  Cluster Manager

![Graphical user interface, text Description automatically
generated](./media//media/image1.png){width="6.5in"
height="4.772916666666666in"}

These extensions come pre-installed with Windows Admin Center versions
2110.2 and later. You can check the version of your extensions in the
Installed extensions tab of the Extension manager. The Windows Admin
Center Extension manager can be found by navigating to the Extensions
tab in your Windows Admin Center gateway settings.

## Set up Arc Resource Bridge & create Custom Location

To check all the prerequisites that should be met to deploy Arc Resource
Bridge on an Azure Stack HCI Cluster, select **Settings** when connected
to a cluster & navigate to **Azure Arc VM setup for Azure Stack HCI**.
If an Arc Resource Bridge is not detected, it will provide a button to
Deploy Arc Resource Bridge.

![Text Description automatically
generated](./media//media/image2.png){width="5.427841207349081in"
height="4.031812117235345in"}

1.  Select **Deploy Resource Bridge** to launch the setup wizard.

2.  Review the prerequisites for the machine you\'re running Windows
    Admin Center on, the cluster you\'re connected to, and the network.
    Additionally, make sure you\'re signed into an Azure account on
    Windows Admin Center and that the Azure subscription you\'re
    planning on using is not expired. You must have the Owner role on
    the subscription you are planning on using. When you\'re finished,
    select Next.

> ** Warning**
>
> Make sure you have configured at least one external virtual switch
> before proceeding past this step, or you will not be able to
> successfully set up your Azure Kubernetes Service host.

3.  On the **System validation** page of the wizard, take required
    actions to connect Windows Admin Center gateway to the Azure Stack
    HCI cluster. As a result of validation, it will prompt you to
    Install the required modules for deploying Arc Resource Bridge.

4.  Ensure system connectivity through CredSSP in the Connectivity step.
    CredSSP lets Windows Admin Center delegate the user\'s credentials
    from the gateway to a target server for remote authentication.
    CredSSP needs to be enabled to set up Azure Kubernetes Service.
    After you\'ve enabled CredSSP, select Next.

5.  Provide the configuration details for Arc Resource Bridge. This step
    of the wizard asks you to configure the following details:

    -   **Host Details** such as name for the Resource Bridge and an
        image directory where VM images will be stored. The image
        directory must be on a Cluster Shared Volume available to all
        servers in the cluster.

    -   **VM Networking** information for deploying Arc Resource Bridge
        appliance. These settings include the fields for the internet
        connected virtual switch, virtual LAN identification enablement,
        Cloudagent IP & Control plane IP.

> The Controlplane IP address will be used for the load balancer in the
> Arc Resource Bridge. This IP address needs to be in the same subnet as
> the DHCP scope for virtual machines and must be excluded from the DHCP
> scope to avoid IP address conflicts.
>
> The Cloudagent IP address is required only for static IP
> configurations on the underlay network for the physical hosts.
>
> This section also provides an option to select the IP allocation
> method for the Arc Resource Bridge VM.

The following image represents an example of a DHCP networking
configuration:

> ![Graphical user interface, text, application Description
> automatically generated](./media//media/image3.png){width="6.5in"
> height="3.532638888888889in"}

6.  On the Azure Registration page of the wizard, provide details about
    the subscription, resource group, and region you wish to use for
    this service. Your resource group will need to be in the East US or
    West Europe region.

> When you\'re finished, select **Review Settings**.

7.  Review all of your selections in the **Review Settings** step. If
    you\'re satisfied with your selections, select, **Apply** to prepare
    the cluster hosts & after completion of that step, proceed to
    **Deployment**.

8.  On the **Deployment** page, you can watch the progress of the Arc
    Resource Bridge. At this point, you are welcome to open Windows
    Admin Center in a new tab and continue your management tasks. The
    deployment takes about 15-30 minutes to complete.

Upon successful deployment, the wizard will automatically navigate to
Arc Resource Bridge dashboard where you can see the details of the
Custom Location & Arc Resource Bridge.

## Projecting Virtual Network & Images

Now that the custom location is available, you can create or add virtual
networks and images for the custom location associated with the Azure
Stack HCI cluster.

You will access **Azure Arc VM setup for Azure Stack HCI** under cluster
**Settings** again. On this page, you can project vmswitch name that
will be used for network interfaces during VM provisioning. You will
also project OS gallery images that will be used for creating VMs
through Azure Arc.

## Known issues

After successful deployment of the Azure Arc Resource Bridge, Windows
Admin Center may be unable to detect the status of the Resource Bridge
and display an error instead of the dashboard. This error does not
indicate issues with your deployment and operations conducted through
the Azure Portal should work normally.

## Next steps

In this quickstart, you installed Windows Admin Center, configured Arc
Resource Bridge, created a Custom Location and projected virtual network
& images to Portal for your Azure Stack HCI cluster. You are now ready
to go ahead with [creating virtual machines from Azure
portal](https://docs.microsoft.com/azure-stack/hci/manage/azure-arc-enabled-virtual-machines#view-your-cluster-in-azure-portal--manage-virtual-machines).
