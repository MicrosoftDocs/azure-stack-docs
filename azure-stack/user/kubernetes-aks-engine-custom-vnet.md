---
title: Scale a Kubernetes cluster on Azure Stack Hub 
description: Learn how to scale a Kubernetes cluster on Azure Stack Hub.
author: mattbriggs

ms.topic: article
ms.date: 11/21/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 11/21/2019

# Intent: As an Azure Stack Hub user, I would like to deploy a Kubernetes cluster using the AKS engine on a custom virtual network so that I can deliver my service in an environment that extends my data center or in a hybrid cloud solution with my cluster in Azure Stack and Azure.
# Keywords: 
---

# Deploy a Kubernetes cluster on Azure Stack Hub with a custom virtual network

You can deploy a Kubernetes cluster using the AKS engine on a custom virtual network so that I can deliver your service in an environment that extends your data center or in a hybrid cloud solution extending Azure Stack to Azure.

> [!Note]  
> Custom virtual network for Kubernetes Windows cluster has a [known issue](https://github.com/Azure/aks-engine/issues/371).

The AKS engine supports deploying into an existing virtual network. You must specify the ARM path/id of Subnets for the `masterProfile` and  any `agentPoolProfiles`, as well as the first IP address to use for static IP allocation in `firstConsecutiveStaticIP`. In any Azure subnet, the first four and the last IP address is reserved and can not be used. Additionally, each pod now gets the IP address from the subnet. The value of `firstConsecutiveStaticIP` should be toward the end of the address space to avoid IP conflicts. You should also leave a buffer of 16 IP addresses. As a result, enough IP addresses (equal to `ipAddressCount` for each node) should be available beyond `firstConsecutiveStaticIP`. `firstConsecutiveStaticIP` only applies to the master pool. 

By default, the `ipAddressCount` has a value of 31, 1 for the node and 30 for pods, (note that the number of pods can be changed via `KubeletConfig["--max-pods"]`). `ipAddressCount` can be changed if desired. Furthermore, to prevent source address NAT'ing within the virtual network, we assign to the `vnetCidr` property in `masterProfile` the CIDR block that represents the usable address space in the existing virtual network. Therefore, it is recommended to use a large subnet size such as `/16`.

Depending upon the size of the virtual network address space, during deployment, it is possible to experience IP address assignment collision between the required Kubernetes static IPs (one each per master and one for the API server load balancer, if more than one masters) and Azure CNI-assigned dynamic IPs (one for each NIC on the agent nodes). In practice, the larger the virtual network the less likely this is to happen; some detail, and then a guideline.

First, the detail:

- Azure CNI assigns dynamic IP addresses from the "beginning" of the subnet IP address space (specifically, it looks for available addresses starting at ".4" ["10.0.0.4" in a "10.0.0.0/24" network])
- aks-engine will require a range of up to 16 unused IP addresses in multi-master scenarios (1 per master for up to 5 masters, and then the next 10 IP addresses immediately following the "last" master for headroom reservation, and finally 1 more for the load balancer immediately adjacent to the afore-described _n_ masters+10 sequence) to successfully scaffold the network stack for your cluster

A guideline that will remove the danger of IP address allocation collision during deployment:

- If possible, assign to the `firstConsecutiveStaticIP` configuration property an IP address that is near the "end" of the available IP address space in the desired  subnet.
  - For example, if the desired subnet is a `/24`, choose the "239" address in that network space

In larger subnets (for example, `/16`) it's not as practically useful to push static IP assignment to the very "end" of large subnet, but as long as it's not in the "first" `/24` (for example) your deployment will be resilient to this edge case behavior.

Before provisioning, modify the `masterProfile` and `agentPoolProfiles` to match the above requirements, with the below being a representative example:

```js
"masterProfile": {
  ...
  "vnetSubnetId": "/subscriptions/SUB_ID/resourceGroups/RG_NAME/providers/Microsoft.Network/virtualNetworks/VNET_NAME/subnets/MASTER_SUBNET_NAME",
  "firstConsecutiveStaticIP": "10.239.255.239",
  "vnetCidr": "10.239.0.0/16",
  ...
},
...
"agentPoolProfiles": [
  {
    ...
    "name": "agentpri",
    "vnetSubnetId": "/subscriptions/SUB_ID/resourceGroups/RG_NAME/providers/Microsoft.Network/virtualNetworks/VNET_NAME/subnets/AGENT_SUBNET_NAME",
    ...
  },
```

## virtualmachinescalesets masters custom virtual network

When using custom virtual network with `VirtualMachineScaleSets` MasterProfile, make sure to create two subnets within the vnet: `master` and `agent`.
Modify `masterProfile` in the api model, `vnetSubnetId`, `agentVnetSubnetId` should be set to the values of the `master` subnet and the `agent` subnet in the existing vnet respectively.
Modify `agentPoolProfiles`, `vnetSubnetId` should be set to the value of the `agent` subnet in the existing vnet.

> ![Note]
> The `firstConsecutiveStaticIP` configuration should be empty and will be derived from an offset and the first IP in the vnetCidr.*
For example, if `vnetCidr` is `10.239.0.0/16`, `master` subnet is `10.239.0.0/17`, `agent` subnet is `10.239.128.0/17`, then `firstConsecutiveStaticIP` will be `10.239.0.4`.

```js
"masterProfile": {
  ...
  "vnetSubnetId": "/subscriptions/SUB_ID/resourceGroups/RG_NAME/providers/Microsoft.Network/virtualNetworks/VNET_NAME/subnets/MASTER_SUBNET_NAME",
  "agentVnetSubnetId": "/subscriptions/SUB_ID/resourceGroups/RG_NAME/providers/Microsoft.Network/virtualNetworks/VNET_NAME/subnets/AGENT_SUBNET_NAME",
  "vnetCidr": "10.239.0.0/16",
  ...
},
...
"agentPoolProfiles": [
  {
    ...
    "name": "agentpri",
    "vnetSubnetId": "/subscriptions/SUB_ID/resourceGroups/RG_NAME/providers/Microsoft.Network/virtualNetworks/VNET_NAME/subnets/AGENT_SUBNET_NAME",
    ...
  },
```

## kubenet networking custom virtual network

If you're *not* using Azure CNI (for example, `"networkPlugin": "kubenet"` in the `kubernetesConfig` api model configuration object): After a custom virtual network-configured cluster finishes provisioning, fetch the id of the Route Table resource from `Microsoft.Network` provider in your new cluster's Resource Group.

The route table resource id is of the format: `/subscriptions/SUBSCRIPTIONID/resourceGroups/RESOURCEGROUPNAME/providers/Microsoft.Network/routeTables/ROUTETABLENAME`

Existing subnets will need to use the Kubernetes-based Route Table so that machines can route to Kubernetes-based workloads.

Update properties of all subnets in the existing virtual network route table resource by appending the following to subnet properties:

```json
"routeTable": {
        "id": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Network/routeTables/k8s-master-<SOMEID>-routetable>"
}
```

E.g.:

```js
"subnets": [
    {
      "name": "subnetname",
      "id": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Network/virtualNetworks/<VirtualNetworkName>/subnets/<SubnetName>",
      "properties": {
        "provisioningState": "Succeeded",
        "addressPrefix": "10.240.0.0/16",
        "routeTable": {
          "id": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Network/routeTables/k8s-master-<SOMEID>-routetable"
        }
      ...
      }
      ...
    }
]
```

After you have deployed the virtual network using kubenet, go to the subnet blade and set both the RouteTable and NSG.

For example:

```text  
SETUP
Master Count: 3
Worker Count: 9
firstConsecutiveStaticIP: 10.238.64.200

RESULT
k8s-linuxpool-16359400-nic-8             10.238.64.4
k8s-linuxpool-16359400-nic-1             10.238.64.5
k8s-linuxpool-16359400-nic-2             10.238.64.6
k8s-linuxpool-16359400-nic-5             10.238.64.7
k8s-linuxpool-16359400-nic-4             10.238.64.8
k8s-linuxpool-16359400-nic-6             10.238.64.9
k8s-linuxpool-16359400-nic-3             10.238.64.10
k8s-linuxpool-16359400-nic-0             10.238.64.11
k8s-linuxpool-16359400-nic-7             10.238.64.12
 
k8s-master-16359400-nic-0                10.238.64.200
k8s-master-16359400-nic-1                10.238.64.201
k8s-master-16359400-nic-2                10.238.64.202
```

## Next steps

- Read about the [The AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)  
- Read about [Azure Monitor for containers overview](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-overview)