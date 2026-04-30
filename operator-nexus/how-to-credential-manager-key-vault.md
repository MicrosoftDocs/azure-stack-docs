---
title: Set up customer provided Key Vault for Managed Credential rotation
description: Step by step guide on setting up a key vault for managing and rotating credentials used within Azure Operator Nexus Cluster resource.
author: lb4368
ms.author: lborgmeyer
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 04/21/2026
ms.custom: template-how-to, devx-track-azurecli
---

# Set up Key Vault for Managed Credential Rotation in Operator Nexus

> [!NOTE]
> If no key vault is configured for the Cluster resource, credential rotation will fail.

Azure Operator Nexus utilizes secrets and certificates to manage component security across the platform. The Operator Nexus platform handles the rotation of these secrets and certificates. By default, Operator Nexus stores the credentials in a managed Key Vault. To keep the rotated credentials in their own Key Vault, the user must configure their own Key Vault to receive rotated credentials. This configuration requires the user to configure the Key Vault for the Azure Operator Nexus instance. Once created, the user needs to add a role assignment on the Customer Key Vault to allow the Operator Nexus Platform to write updated credentials, and additionally link the Customer Key Vault to the Nexus Cluster Resource.

## Prerequisites

- Install the latest version of the
  [appropriate CLI extensions](./howto-install-cli-extensions.md)
- Get the _Subscription ID_ for the customer's subscription

> [!NOTE]
> A single Key Vault can be used for any number of clusters.

## Configure Key Vault Using Managed Identity for the Cluster

See [Azure Operator Nexus Cluster support for managed identities and user provided resources](./howto-cluster-managed-identity-user-provided-resources.md)

## Configure Network Security Perimeter for Key Vault with firewall enabled

> [!IMPORTANT]
> This configuration is required for Azure Operator Nexus clusters where the **EdgeCredentialManagement** feature is enabled.

If a firewall is enabled on the customer Key Vault, you must configure a Network Security Perimeter (NSP) so that the Operator Nexus cluster can write rotated credentials to the Key Vault. Without a properly configured NSP, Edge Credentials can't update Key Vault secrets and further credential rotations are blocked.

A network security perimeter creates a logical network boundary around Azure PaaS resources such as Azure Key Vault. Resources inside the perimeter can communicate freely, while all public traffic from outside the perimeter is denied by default unless explicit access rules are configured. For more information, see [What is a network security perimeter?](/azure/private-link/network-security-perimeter-concepts).

> [!NOTE]
> The **Allow trusted Microsoft services to bypass this firewall** exception on the Key Vault does **not** apply to Edge Credential writes. You must use a Network Security Perimeter or IP-based firewall rules to allow access.

> [!TIP]
> As an alternative to a Network Security Perimeter, you can add the Operator Nexus infrastructure firewall public IP address to the Key Vault's IP allowlist. Navigate to your Key Vault in the Azure portal, select **Networking** > **Firewalls and virtual networks**, and add the IP address under **Firewall**. See [Configure Azure Key Vault firewalls and virtual networks](/azure/key-vault/general/network-security) for details.

### Prerequisites

- An existing Key Vault with firewall enabled.
- The _Subscription ID_ of every subscription that contains an Operator Nexus cluster writing to this Key Vault.

### Step 1: Create a network security perimeter

Create a network security perimeter to define the trusted boundary for your Key Vault. For detailed portal steps, see [Quickstart: Create a network security perimeter - Azure portal](/azure/private-link/create-network-security-perimeter-portal).

1. In the Azure portal search box, enter **network security perimeters** and select the result.
1. Select **+ Create**.
1. On the **Basics** tab, provide the following information:

    | Setting          | Value                                                                  |
    | ---------------- | ---------------------------------------------------------------------- |
    | **Subscription** | Select the subscription that contains your Key Vault.                  |
    | **Resource group** | Select the resource group for the network security perimeter.        |
    | **Name**         | Enter a name for the perimeter, for example `nsp-keyvault-nexus`.      |
    | **Region**       | Select the same region as your Key Vault.                              |
    | **Profile name** | Enter a profile name, for example `nexus-cluster-profile`.             |

1. Select **Next** to proceed to the **Resources** tab.

### Step 2: Associate the Key Vault with the perimeter

1. On the **Resources** tab, select **+ Add**.
1. In the **Select resources** pane, check the Key Vault that receives rotated credentials and select **Select**.

### Step 3: Create an inbound access rule to allow cluster subscriptions

Inbound access rules allow traffic from specified subscriptions to reach the Key Vault through the firewall. You must add an inbound rule that permits connections from every subscription that contains an Operator Nexus cluster writing to this Key Vault.

1. Select the **Inbound access rules** tab and select **+ Add**.
1. In the **Add inbound access rule** pane, enter the following information:

    | Setting            | Value                                                                                      |
    | ------------------ | ------------------------------------------------------------------------------------------ |
    | **Rule name**      | Enter a descriptive name, for example `allow-nexus-cluster-subscriptions`.                  |
    | **Source type**    | Select **Subscriptions**.                                                                  |
    | **Allowed sources** | Select every subscription that contains an Operator Nexus cluster writing to this Key Vault. |

1. Select **Add**.
1. If your clusters reside in multiple subscriptions, repeat the previous steps to add each subscription or include them all in a single rule.

### Step 4: Review and create

1. Select **Review + create**.
1. Review the configuration and select **Create**.
1. After the deployment completes, select **Go to resource** to verify the perimeter, profile, resource association, and inbound access rules.

### Alternative: Configure using Azure CLI

You can perform all of the preceding steps using the Azure CLI instead of the Azure portal. For the full command reference, see:

- [az network perimeter create](/cli/azure/network/perimeter#az-network-perimeter-create) — Create a network security perimeter.
- [az network perimeter profile create](/cli/azure/network/perimeter/profile#az-network-perimeter-profile-create) — Create a profile in the perimeter.
- [az network perimeter association create](/cli/azure/network/perimeter/association#az-network-perimeter-association-create) — Associate a resource (Key Vault) with the perimeter.
- [az network perimeter profile access-rule create](/cli/azure/network/perimeter/profile/access-rule#az-network-perimeter-profile-access-rule-create) — Create an inbound access rule to allow cluster subscriptions.

### Verify the configuration

After the network security perimeter is created, confirm the following items:

- The Key Vault appears as an associated resource in the perimeter.
- The NSP profile contains the inbound access rule that lists the cluster subscriptions.
- The access mode for the profile is set to **Enforced** so that only explicitly permitted traffic reaches the Key Vault. For more information on access modes, see [Access modes in network security perimeter](/azure/private-link/network-security-perimeter-concepts#access-modes-in-network-security-perimeter).

> [!NOTE]
> When the access mode is set to **Transition** (the default), both the Key Vault firewall rules and the NSP access rules apply. Switch to **Enforced** mode so that only NSP rules govern access. For guidance on transitioning, see [Transitioning to a network security perimeter](/azure/private-link/network-security-perimeter-transition).

> [!CAUTION]
> Failure to configure the Network Security Perimeter as described prevents Edge Credentials from updating Key Vault secrets, which blocks all further credential rotations for the affected clusters.
