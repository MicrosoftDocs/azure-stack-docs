---
title: 'Azure Operator Nexus: Apply ACLs to Resources'
description: Learn how to apply access control lists (ACLs) to network-to-network interconnects (NNIs), layer 3 External Networks, and Network Fabrics within Azure Operator Nexus Network Fabric.
author: rbhupatiraju
ms.author: rbhupatiraju
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 04/07/2026
ms.custom: template-how-to, devx-track-azurecli
---

# Access control list (ACL) management for NNI

In Azure Operator Nexus Network Fabric, maintaining network security is paramount for ensuring a robust and secure infrastructure. Access control lists (ACLs) are crucial tools for enforcing network security policies. This article leads you through the process of applying ACLs to network-to-network interconnects (NNIs), layer 3 isolation domain external networks, and network fabric resources within Azure Operator Nexus Network Fabric.

## Apply ACLs to resources in Azure Operator Nexus Network Fabric

To maintain network security and regulate traffic flow within your Azure Operator Nexus Network Fabric network, applying ACLs to NNIs, L3 external networks, and network fabrics is essential. This article delineates the steps for effectively applying ACLs to these resources.


#### View ACL details

To view the specifics of a particular ACL, run the following command:

```azurecli
az networkfabric acl show --name "<acl-ingress-name>" --resource-group "<resource-group-name>"
```

This command furnishes detailed information regarding the ACL's configuration, administrative state, default action, and matching conditions.

#### List ACLs in a resource group

To list all ACLs within a resource group, use the following command:

```azurecli
az networkfabric acl list --resource-group "<resource-group-name>"
```

> [!NOTE]
> - ACLs applied to network fabrics must be of type "ControlPlaneTrafficPolicy"
> - ACLs applied to L3 external networks must be of type "Tenant" or have no type defined.
> - ACLs applied to NNIs must be of type "Management" or have no type defined.

This command presents a comprehensive list of ACLs along with their configuration states and other pertinent details.



#### Apply a control plane ACL to a network fabric
Use the following command to apply an ACL to a network fabric.

```azurecli
az networkfabric fabric update  --resource-group "<resource-group-name>" --resource-name "<fabric-name> --control-plane-acls "<acl-resource-id>"
```
| Parameter        | Description                                    |
|------------------|------------------------------------------------|
|`--control-plane-acls` | Apply a control plane ACL by specifying its resource ID. This parameter only applies to ACLs applied to the network fabric. |

#### Apply ingress and egress ACLs to an NNI or L3 external network
Use the following command to apply both an ingress ACL and an egress ACL to an NNI:

```azurecli
az networkfabric nni update --resource-group "example-rg" --resource-name "<nni-name>" --fabric "<fabric-name>" --ingress-acl-id "<ingress-acl-resource-id>" --egress-acl-id "<egress-acl-resource-id>"
```
Use the following command to apply both an ingress ACL and an egress ACL to an L3 external network:

```azurecli
az networkfabric externalnetwork update --resource-group "<resource-group-name>" --resource-name "<externalNetwork-name>" --l3domain "<l3domain-name>"  --peering-option "OptionA" --option-a-properties ingress-acl-id="<ingress-acl-resource-id>" egress-acl-id="<egress-acl-resource-id>"
```

| Parameter         | Description                                                                                                    |
|-------------------|----------------------------------------------------------------------------------------------------------------|
| `--ingress-acl-id`, `--egress-acl-id` | To apply both ingress and egress ACLs simultaneously, create two new ACLs and include their respective resource IDs. |



#### Apply only an ingress ACL to an NNI or L3 external network
Use the following command to apply an ingress ACL to an NNI:

```azurecli
az networkfabric nni update --resource-group "<resource-group-name>" --resource-name "<nni-name>" --fabric "<fabric-name>" --ingress-acl-id "<ingress-acl-resource-id>"
```
Use the following command to apply an ingress ACL to an L3 external network:

```azurecli
az networkfabric externalnetwork update --resource-group "<resource-group-name>" --resource-name "<externalNetwork-name>" --l3domain "<l3domain-name>"  --peering-option "OptionA" --option-a-properties ingress-acl-id="<ingress-acl-resource-id>"
```

| Parameter         | Description                                      |
|-------------------|--------------------------------------------------|
| `--ingress-acl-id` | Apply the ACL as ingress by specifying its resource ID.  |

#### Apply only an egress ACL to an NNI or L3 external network
Use the following command to apply an ingress ACL to an NNI:

```azurecli
az networkfabric nni update --resource-group "example-rg" --resource-name "<nni-name>" --fabric "<fabric-name>" --egress-acl-id "<egress-acl-resource-id>"
```
Use the following command to apply an egress ACL to an L3 external network:
```azurecli
az networkfabric externalnetwork update --resource-group "<resource-group-name>" --resource-name "<externalNetwork-name>" --l3domain "<l3domain-name>"  --peering-option "OptionA" --option-a-properties egress-acl-id="<egress-acl-resource-id>"
```

| Parameter        | Description                                    |
|------------------|------------------------------------------------|
|`--egress-acl-id` | Apply the ACL as egress by specifying its resource ID. |




## Related content

- [Update ACLs on NNIs, L3 external networks, and network fabrics](howto-update-access-control-list.md)
