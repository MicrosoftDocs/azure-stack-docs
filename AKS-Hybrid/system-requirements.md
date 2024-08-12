---
title: System requirements for AKS enabled by Azure Arc on Azure Stack HCI 22H2
description: Learn about system requirements for Azure Kubernetes Service (AKS) enabled by Azure Arc on Azure Stack HCI 22H2.
ms.date: 02/13/2024
ms.topic: conceptual
author: sethmanheim
ms.author: sethm 

# Intent: As a system administrator, I want to understand the hardware and software needed so that I can run AKS in my datacenter.
# Keyword: AKS system requirements

---

# System requirements for AKS enabled by Azure Arc on Azure Stack HCI 22H2

> Applies to: Azure Stack HCI, versions 22H2; Windows Server 2022, Windows Server 2019

This article describes the requirements for setting up Azure Kubernetes Service (AKS) enabled by Azure Arc. For an overview of AKS enabled by Arc, see the [AKS overview](overview.md).

## Hardware requirements

Microsoft recommends purchasing a validated Azure Stack HCI hardware/software solution from our partners. These solutions are designed, assembled, and validated to run our reference architecture and to check compatibility and reliability so you get up and running quickly. You should check that the systems, components, devices, and drivers you're using are Windows Server Certified per the Windows Server Catalog. See the [Azure Stack HCI solutions](https://azure.microsoft.com/overview/azure-stack/hci) website for validated solutions.

> [!IMPORTANT]
> The host systems for production deployments must be physical hardware. Nested virtualization, characterized as deploying Azure Stack HCI or Windows Server in a virtual machine and installing AKS in that virtual machine, isn't supported.

### Maximum supported hardware specifications

AKS on Azure Stack HCI and Windows Server deployments that exceed the following specifications aren't supported:

| Resource                     | Maximum |
| ---------------------------- | --------|
| Physical servers per cluster | 8 (Azure Stack HCI version 22H2 and Windows Server)       |
| Total number of VMs          | 200     |

## Compute requirements

### Minimum memory requirements

You can set up your AKS cluster in the following way, to run AKS on a single node Windows Server with limited RAM:

| Cluster type  | Control plane VM size | Worker node | For update operations | Load balancer  |
| ------------- | ------------------ | ---------- | ----------| -------------|
| AKS host | Standard_A4_v2 VM size = 8GB |  N/A - AKS host doesn't have worker nodes.  |  8GB |  N/A - AKS host uses kubevip for load balancing.  |
| Workload cluster  |  Standard_A4_v2 VM size = 8GB | Standard_K8S3_v1 for 1 worker node = 6GB | Can re-use this reserved 8GB for workload cluster upgrade. | N/A if kubevip is used for load balancing (instead of the default HAProxy load balancer). |

Total minimum requirement: **30 GB RAM**.

This minimum requirement is for an AKS deployment with one worker node for running containerized applications. If you choose to add worker nodes or a HAProxy load balancer, the final RAM requirement changes accordingly.

### Recommended compute requirements

| Environment | CPU cores per server | RAM |
| --- | --- | --- |
| Azure Stack HCI | 32 | 256 GB |
| Windows Server failover cluster | 32 | 256 GB |
| Single node Windows Server | 16 | 128 GB

For a production environment, final sizing depends on the application and number of worker nodes you're planning to deploy on the Azure Stack HCI or Windows Server cluster. If you choose to run AKS on a single-node Windows Server, you don't get features like high availability that come with running AKS on an Azure Stack HCI or Windows Server cluster or Windows Server failover cluster.

Other compute requirements for AKS on Azure Stack HCI and Windows Server are in line with Azure Stack HCI requirements. See [Azure Stack HCI system requirements](/azure-stack/hci/concepts/system-requirements#server-requirements) for more information about Azure Stack HCI server requirements.

You must install the same operating system on each server in the cluster. If you're using Azure Stack HCI, the same OS and version must be on same on each server in the cluster. If you're using Windows Server Datacenter, the same OS and version must be the same on each server in the cluster. Each OS must use the **en-us** region and language selections. You can't change these settings after installation.

## Storage requirements

AKS on Azure Stack HCI and Windows Server supports the following storage implementations:

|  Name                         | Storage type | Required capacity |
| ---------------------------- | ------------ | ----------------- |
| Azure Stack HCI cluster          | Cluster shared volumes          | 1 TB              |
| Windows Server Datacenter failover cluster          | Cluster shared volumes          | 1 TB              |
| Single-node Windows Server Datacenter | Direct attached storage | 500 GB|

For an Azure Stack HCI or Windows Server cluster, there are two supported storage configurations for running virtual machine workloads:

- **Hybrid storage** balances performance and capacity using flash storage and hard disk drives (HDDs).
- **All-flash storage** maximizes performance using solid-state drives (SSDs) or NVMe.

Systems that only have HDD-based storage aren't supported by Azure Stack HCI, and thus aren't recommended for running AKS on Azure Stack HCI and Windows Server. For more information about the recommended drive configurations, see the [Azure Stack HCI documentation](/azure-stack/hci/concepts/choose-drives). All systems that are validated in the [Azure Stack HCI catalog](https://hcicatalog.azurewebsites.net/#/) fall into one of these two supported storage configurations.

Kubernetes uses *etcd* to store the state of the clusters. Etcd stores the configuration, specifications, and status of running pods. In addition, Kubernetes uses the store for service discovery. As a coordinating component to the operation of Kubernetes and the workloads it supports, latency and throughput to etcd are critical. You must run AKS on an SSD. For more information, see [Performance](https://etcd.io/docs/v3.2/op-guide/performance/) at etcd.io.

For a Windows Server Datacenter-based cluster, you can either deploy with local storage or SAN-based storage. For local storage, it's recommended that you use the built-in [Storage Spaces Direct](/windows-server/storage/storage-spaces/storage-spaces-direct-overview), or an equivalent certified virtual SAN solution to create a hyperconverged infrastructure that presents Cluster Shared Volumes for use by workloads. For Storage Spaces Direct, it's required that your storage either be hybrid (flash + HDD) that balances performance and capacity, or all-flash (SSD, NVMe) that maximizes performance. If you choose to deploy with SAN-based storage, ensure that your SAN storage can deliver enough performance to run several virtual machine workloads. Older HDD-based SAN storage might not deliver the required levels of performance to run multiple virtual machine workloads, and you might see performance issues and timeouts.

For single-node Windows Server deployments using local storage, the use of all-flash storage (SSD, NVMe) is highly recommended to deliver the required performance to host multiple virtual machines on a single physical host. Without flash storage, the lower levels of performance on HDDs might cause deployment issues and timeouts.

## Network requirements

The following requirements apply to an Azure Stack HCI 22H2 cluster and a Windows Server Datacenter cluster. For networking requirements on Azure Stack HCI 23H2, see [Networking requirements](aks-hci-network-system-requirements.md).

- For Azure Stack HCI 22H2 and Windows Server, verify that you have an existing, external virtual switch configured if you're using Windows Admin Center. For HCI or Windows Server clusters, this switch and its name must be the same across all cluster nodes. For HCI 23H2, see the [network system requirements](aks-hci-network-system-requirements.md).
- Verify that you have disabled IPv6 on all network adapters.
- For a successful deployment, the Azure Stack HCI or Windows Server cluster nodes and the Kubernetes cluster VMs must have external internet connectivity.
- Make sure all subnets you define for the cluster are routable between each other and to the internet.
- Make sure that there's network connectivity between Azure Stack HCI hosts and the tenant VMs.
- DNS name resolution is required for all nodes to be able to communicate with each other.
- (Recommended) Enable dynamic DNS updates in your DNS environment to allow AKS to register the cloud agent generic cluster name in the DNS system for discovery.

### IP address assignment  

In AKS enabled by Arc, virtual networks are used to allocate IP addresses to the Kubernetes resources that require them, as previously listed. There are two networking models to choose from, depending on your desired AKS networking architecture.

> [!NOTE]
> The virtual networking architecture defined here for your AKS deployments is different from the underlying physical networking architecture in your data center.

- **Static IP networking**: The virtual network allocates static IP addresses to the Kubernetes cluster API server, Kubernetes nodes, underlying VMs, load balancers and any Kubernetes services you run on top of your cluster.
- **DHCP networking**: The virtual network allocates dynamic IP addresses to the Kubernetes nodes, underlying VMs and load balancers using a DHCP server. The Kubernetes cluster API server and any Kubernetes services you run on top of your cluster are still allocated static IP addresses.

### Minimum IP address reservation

At a minimum, you should reserve the following number of IP addresses for your deployment:

| Cluster type  | Control plane node | Worker node | For update operations | Load balancer  |
| ------------- | ------------------ | ---------- | ----------| -------------|
| AKS Host |  1 IP |  NA  |  2 IP |  NA  |
| Workload cluster  |  1 IP per node  | 1 IP per node |  5 IP  |  1 IP |

Additionally, you should reserve the following number of IP addresses for your VIP pool:

| Resource type  | Number of IP addresses |
| ------------- | ------------------ |
| Cluster API server |  1 per cluster |
| Kubernetes services  |  1 per service |

As you can see, the number of required IP addresses is variable depending on the AKS architecture and the number of services you run on your Kubernetes cluster. We recommend reserving a total of 256 IP addresses (/24 subnet) for your deployment.

For more information about networking requirements, see [node networking concepts in AKS](./concepts-node-networking.md) and [container networking concepts in AKS](./concepts-container-networking.md).

### Network port and URL requirements

#### AKS enabled by Arc requirements

When creating a Kubernetes cluster on Azure Stack HCI, the following firewall ports are automatically opened on each server in the cluster.

If the Azure Stack HCI physical cluster nodes and the Azure Kubernetes cluster VMs are on two isolated vlans, these ports must be opened at the firewall between them:

| Port   | Source                               | Description                                        | Firewall Notes                                                                               |
|-------|--------------------------------------|----------------------------------------------------|----------------------------------------------------------------------------------------------|
| 22    | AKS VMs                              | Required to collect logs when using `Get-AksHciLogs`. | If using separate VLANs, the physical Hyper-V Hosts must access the AKS VMs on this port. |
| 6443  | AKS VMs                              | Required to communicate with Kubernetes APIs.       | If using separate VLANs, the physical Hyper-V Hosts must access the AKS VMs on this port. |
| 45000 | Physical Hyper-V Hosts               | wssdAgent gRPC server.                              | No cross-VLAN rules are needed.                                                              |
| 45001 | Physical Hyper-V Hosts               | wssdAgent gRPC authentication.                      | No cross-VLAN rules are needed.                                                              |
| 46000 | AKS VMs                              | wssdCloudAgent to lbagent.                          | If using separate VLANs, the physical Hyper-V Hosts must access the AKS VMs on this port. |
| 55000 | Cluster resource (-CloudServiceCIDR) | Cloud Agent gRPC server.                            | If using separate VLANs, the AKS VMs must access the cluster resource's IP on this port.  |
| 65000 | Cluster resource (-CloudServiceCIDR) | Cloud Agent gRPC authentication.                    | If using separate VLANs, the AKS VMs must access the cluster resource's IP on this port.  |

If your network requires the use of a proxy server to connect to the internet, see [Use proxy server settings on AKS](set-proxy-settings.md).

### [Table](#tab/allow-table)

The following URLs must be added to your allowlist:

[!INCLUDE [URL allow table](includes/data-allow-table.md)]

### [Json](#tab/allow-json)

You can cut and paste the allowlist for firewall URL exceptions:

:::code language="json" source="~/../modules/aks-hci/config/allow-list-end-points.json":::

Download the [URL allowlist (json)](https://raw.githubusercontent.com/MicrosoftDocs/edge-modules/main/aks-hci/config/allow-list-end-points.json).

---

> [!NOTE]
> AKS enabled by Arc stores and processes customer data. By default, customer data stays within the region in which the customer deploys the service instance. This data is stored within regional Microsoft-operated datacenters. For regions with data residency requirements, customer data is always kept within the same region.

#### Additional URL requirements for Azure Arc features

The previous URL list covers the minimum required URLs for you to connect your AKS service to Azure for billing. You must allow additional URLs if you want to use cluster connect, custom locations, Azure RBAC, and other Azure services like Azure Monitor, etc., on your AKS workload cluster. For a complete list of Arc URLs, see [Azure Arc-enabled Kubernetes network requirements](/azure/azure-arc/kubernetes/network-requirements).

You should also review [Azure Stack HCI URLs](/azure-stack/hci/concepts/firewall-requirements). Since Arc for server agents is now installed by default on Azure Stack HCI nodes from Azure Stack HCI 21H2 and above, you should also review the [Arc for server agents URLs](/azure/azure-arc/servers/network-requirements).

#### Stretched clusters in AKS

As outlined in the [Stretched clusters overview](/azure-stack/hci/concepts/stretched-clusters), deploying AKS on Azure Stack HCI and Windows Server using Windows stretched clusters isn't supported. We recommend that you use a backup and disaster recovery approach for your datacenter operational continuity. For more information, see [Perform workload cluster backup or restore using Velero and Azure Blob storage on Azure Stack HCI and Windows Server](backup-workload-cluster.md), and [Deploy configurations on AksHci using GitOps with Flux v2](https://techcommunity.microsoft.com/t5/azure-stack-blog/deploy-configurations-on-akshci-using-gitops-with-flux-v2/ba-p/3610596) for application continuity.

## Windows Admin Center requirements

Windows Admin Center is the user interface for creating and managing AKS enabled by Azure Arc. To use Windows Admin Center with AKS on Azure Stack HCI and Windows Server, you must meet all the criteria in the following list.

These are the requirements for the machine running the Windows Admin Center gateway:

- Windows 10 or Windows Server.
- [Registered with Azure](/windows-server/manage/windows-admin-center/azure/azure-integration).
- In the same domain as the Azure Stack HCI or Windows Server Datacenter cluster.
- An Azure subscription on which you have Owner rights. You can check your access level by navigating to your subscription and selecting **Access control (IAM)** on the left-hand side of the Azure portal and then selecting **View my access**.

## Azure requirements

You must connect to your Azure account.

### Azure account and subscription

If you don't already have an Azure account, [create one](https://azure.microsoft.com). You can use an existing subscription of any type:

- Free account with Azure credits for [students](https://azure.microsoft.com/free/students/) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/).
- [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card.
- Subscription obtained through an Enterprise Agreement (EA).
- Subscription obtained through the Cloud Solution Provider (CSP) program.

<a name='azure-ad-permissions-role-and-access-level'></a>

### Microsoft Entra permissions, role and access level

You must have sufficient permissions to register an application with your Microsoft Entra tenant.

To check that you have sufficient permissions, follow the information below:

- Go to the Azure portal and select [Roles and administrators](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RolesAndAdministrators) under **Microsoft Entra ID** to check your role.
- If your role is **User**, you must make sure that non-administrators can register applications.
- To check if you can register applications, go to [User settings](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/UserSettings) under the Microsoft Entra service to check if you have permission to register an application.

If the app registrations setting is set to **No**, only users with an administrator role can register these types of applications. To learn about the available administrator roles and the specific permissions in Microsoft Entra ID that are given to each role, see [Microsoft Entra built-in roles](/azure/active-directory/roles/permissions-reference#all-roles). If your account is assigned the **User** role, but the app registration setting is limited to admin users, ask your administrator either to assign you one of the administrator roles that can create and manage all aspects of app registrations, or to enable users to register apps.

If you don't have enough permissions to register an application and your admin can't give you these permissions, the easiest way to deploy AKS is to ask your Azure admin to create a service principal with the right permissions. Admins can check the following section to learn how to create a service principal.

### Azure subscription role and access level

To check your access level, navigate to your subscription, select **Access control (IAM)** on the left-hand side of the Azure portal, and then select **View my access**.

- If you're using Windows Admin Center to deploy an AKS host or an AKS workload cluster, you must have an Azure subscription on which you're an **Owner**.
- If you're using PowerShell to deploy an AKS host or an AKS workload cluster, the user registering the cluster must have at least one of the following:
  - A user account with the built-in **Owner** role.
  - A service principal with one of the following access levels:
    - The built-in [Contributor](/azure/role-based-access-control/built-in-roles#contributor) role.
    - The built-in [Owner](/azure/role-based-access-control/built-in-roles#owner) role.

If your Azure subscription is through an EA or CSP, the easiest way to deploy AKS is to ask your Azure admin to create a service principal with the right permissions. Admins can check the following section on how to create a service principal.

### Optional: create a new service principal

Run the following steps to create a new service principal with the built-in **Owner** role. Only subscription owners can create service principals with the right role assignment. You can check your access level by navigating to your subscription, selecting **Access control (IAM)** on the left-hand side of the Azure portal, and then selecting on **View my access**.

Set the following PowerShell variables in a PowerShell admin window. Verify that the subscription and tenant are what you want to use to register your AKS host for billing:

```powershell
$subscriptionID = "<Your Azure subscrption ID>"
$tenantID = "<Your Azure tenant ID>"
```

Install and import the AKS PowerShell module:

```powershell
Install-Module -Name AksHci
```

Sign in to Azure using the [Connect-AzAccount](/powershell/module/az.accounts/connect-azaccount) PowerShell command:

```powershell
Connect-AzAccount -tenant $tenantID
```

Set the subscription you want to use to register your AKS host for billing as the default subscription by running the [Set-AzContext](/powershell/module/az.accounts/set-azcontext) command:

```powershell
Set-AzContext -Subscription $subscriptionID
```

Verify that your sign-in context is correct by running the [Get-AzContext](/powershell/module/az.accounts/get-azcontext) PowerShell command. Verify that the subscription, tenant and account are what you want to use to register your AKS host for billing:

```powershell
Get-AzContext
```

```output
Name                                     Account                      SubscriptionName             Environment                  TenantId
----                                     -------                      ----------------             -----------                  --------
myAzureSubscription (92391anf-...        user@contoso.com             myAzureSubscription          AzureCloud                   xxxxxx-xxxx-xxxx-xxxxxx
```

Create a service principal by running the [New-AzADServicePrincipal](/powershell/module/az.resources/new-azadserviceprincipal) PowerShell command. This command creates a service principal with the **Owner** role and sets the scope at a subscription level. For more information about creating service principals, see [create an Azure service principal with Azure PowerShell](/powershell/azure/create-azure-service-principal-azureps?view=azps-5.9.0&preserve-view=true).

```powershell
$sp = New-AzADServicePrincipal -role "Owner" -scope /subscriptions/$subscriptionID
```

Retrieve the password for the service principal by running the following command. Note that this command only works for Az.Accounts 2.6.0 or below. We automatically download Az.Accounts 2.6.0 module when you install the AksHci PowerShell module:

```powershell
$secret = $sp.PasswordCredentials[0].SecretText
Write-Host "Application ID: $($sp.ApplicationId)"
Write-Host "App Secret: $secret"
```

From the previous output, you now have the **application ID** and the **secret** available when deploying AKS. You should make a note of these items and store them safely. With that created, in the Azure portal, under **Subscriptions**, **Access Control**, and then **Role Assignments**, you should see your new service principal.

### Azure resource group

You must have an Azure resource group in the Australia East, East US, Southeast Asia, or West Europe Azure region available before registration.

### Azure regions

> [!WARNING]
> AKS Arc currently supports cluster creation exclusively within the following specified Azure regions. If you attempt to deploy in a region outside of this list, a deployment failure occurs.

The AKS Arc service is used for registration, billing, and management. It is currently supported in the following regions:

- East US
- South Central US
- West Europe

## Active Directory requirements

For an AKS failover cluster with 2 or more physical nodes to function optimally in an Active Directory environment, ensure the following requirements are met:

> [!NOTE]
> Active Directory is not required for single node Azure Stack HCI or Windows Server deployments.

- Set up time synchronization so that the divergence isn't greater than 2 minutes across all cluster nodes and the domain controller. For information about setting time synchronization, see [Windows time service](/windows-server/networking/windows-time-service/windows-time-service-top).
- Make sure the user account(s) used to add update, and manage AKS or Windows Server Datacenter clusters has the correct permissions in Active Directory. If you're using Organizational Units (OUs) to manage group policies for servers and services, the user account(s) require list, read, modify, and delete permissions on all objects in the OU.
- Use a separate organizational unit (OU) for the servers and services by your AKS or Windows Server Datacenter clusters. Using a separate OU allows you to control access and permissions with more granularity.
- If you're using GPO templates on containers in Active Directory, ensure deploying AKS on Azure Stack HCI and Windows Server is exempt from the policy.

## Next steps

After you've satisfied all of the prerequisites above, you can set up an AKS host on Azure Stack HCI using:

- [Windows Admin Center](setup.md)
- [PowerShell](kubernetes-walkthrough-powershell.md)
