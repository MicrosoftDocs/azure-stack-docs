---
title: 'Network-to-Network Interconnect (NNI) in Azure Operator Nexus'
description: Learn about Network-to-Network Interconnect (NNI) in Azure Operator Nexus
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: concept-article
ms.date: 02/04/2026
---

# Network-to-Network Interconnect (NNI) in Azure Operator Nexus 
A Network‑to‑Network Interconnect (NNI) is a child resource within the Network Fabric that manages PE–CE connectivity between the Customer Edge (CE) devices in the Nexus fabric and the Provider Edge (PE) routers managed by the telecom carrier. It defines the physical and logical connection between the operator’s on‑premises network fabric and external networks. In the Azure ARM model, an NNI represents a fabric network‑to‑network interface that specifies Layer 2 (L2) and Layer 3 (L3) network configuration for the Nexus Network Fabric. A single fabric can support multiple NNIs to model different interconnect scenarios. 


## Purpose and Role of NNI 
The Network-to-Network Interconnect (NNI) provides essential external connectivity for the Nexus fabric. It's achieved by enabling CE–PE communication with provider edge or operator core networks using Option A or Option B. It also connects the fabric to management VPN or infrastructure networks when configured as a management-type NNI, and supports monitoring and observability needs by attaching to networks such as BMP log collectors or Network Packet Broker (NPB) targets. The NNI ensures correct routing and traffic flow between operator and carrier networks, enabling north–south traffic entering or leaving the fabric while supporting redundancy with carrier infrastructure. Because the network fabric and NNI must exist before provisioning, fabric provisioning can't proceed without it. Multiple Azure Operator Nexus instances managed by the Network Fabric Controller (NFC) rely on NNI for external connectivity across service, management, and monitoring scenarios. 


## NNI Types and Key Flags
 Several key attributes govern NNI behavior. The default NNI type is CE (Customer Edge), although other types can be used for specific scenarios such as Network Packet Broker integration. A management flag determines whether the NNI carries management‑plane connectivity or tenant and infrastructure traffic. The Option A / Option B setting defines how CE–PE routing is formed: Option A represents CE‑facing configuration on a per‑VRF or per‑service basis, while Option B enables an inter‑AS routing model that provides a more consolidated external connectivity approach. Together, these attributes shape how an NNI participates in service connectivity, management flows, and CE–PE routing behavior. 


## Azure CLI Examples for Network-to-Network Interconnect (NNI) Operations

### Example to Create a Network To Network Interconnect resource  

Command: 
```AzCLI
az networkfabric nni create \
  --resource-group "<resource-group-name>" \
  --fabric "<network-fabric-name>" \
  --resource-name "<nni-name>" \
  --nni-type "CE" \
  --is-management-type True \
  --use-option-b True \
  --layer2-configuration "{
      interfaces:[
        '/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/networkDevices/<network-device-name>/networkInterfaces/<network-interface-name>'
      ],
      mtu:1500
    }" \
  --option-b-layer3-configuration "{
      primaryIpv4Prefix:'10.0.0.12/30',
      primaryIpv6Prefix:'4FFE:FFFF:0:CD30::a8/127',
      secondaryIpv4Prefix:'40.0.0.14/30',
      secondaryIpv6Prefix:'6FFE:FFFF:0:CD30::ac/127',
      peerASN:61234,
      vlanId:1234,
      peLoopbackIpAddress:['10.0.0.1']
    }"
    ```

Expected Output:
``` Output
{
  "id": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/networkFabrics/<network-fabric-name>/networkToNetworkInterconnects/<nni-name>",
  "name": "<nni-name>",
  "type": "microsoft.managednetworkfabric/networkfabrics/networktonetworkinterconnects",
  "systemData": {
    "createdBy": "user@contoso.com",
    "createdByType": "User",
    "createdAt": "2023-06-09T04:51:41.251Z"
  },
  "properties": {
    "nniType": "CE",
    "isManagementType": "True",
    "useOptionB": "True",
    "layer2Configuration": {
      "mtu": 1500,
      "interfaces": [
        "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/networkDevices/<network-device-name>/networkInterfaces/<network-interface-name>"
      ]
    },
    "optionBLayer3Configuration": {
      "primaryIpv4Prefix": "10.0.0.12/30",
      "primaryIpv6Prefix": "4FFE:FFFF:0:CD30::a8/127",
      "secondaryIpv4Prefix": "40.0.0.14/30",
      "secondaryIpv6Prefix": "6FFE:FFFF:0:CD30::ac/127",
      "peerASN": 61234,
      "vlanId": 1234,
      "peLoopbackIpAddress": [
        "10.0.0.1"
      ]
    },
    "configurationState": "Succeeded",
    "provisioningState": "Accepted",
    "administrativeState": "Enabled"
  }
}
```

### Example to update the Network To Network Interconnect

Command:
```AzCLI
az networkfabric nni update \
  --resource-group "<resource-group-name>" \
  --fabric "<network-fabric-name>" \
  --resource-name "<nni-name>" \
  --layer2-configuration "{
      interfaces:[
        '/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/networkDevices/<network-device-name>/networkInterfaces/<network-interface-name>'
      ],
      mtu:1500
    }" \
  --option-b-layer3-configuration "{
      primaryIpv4Prefix:'20.0.0.12/29',
      primaryIpv6Prefix:'4FFE:FFFF:0:CD30::a8/127',
      secondaryIpv4Prefix:'20.0.0.14/29',
      secondaryIpv6Prefix:'6FFE:FFFF:0:CD30::ac/127',
      peerASN:2345,
      vlanId:1235,
      peLoopbackIpAddress:['10.0.0.1'],
      bmpConfiguration:{configurationState:'Enabled'},
      prefixLimits:[{maximumRoutes:1}]
    }" \
  --import-route-policy "{
      importIpv4RoutePolicyId:'/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/routePolicies/<route-policy-name>',
      importIpv6RoutePolicyId:'/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/routePolicies/<route-policy-name>'
    }" \
  --export-route-policy "{
      exportIpv4RoutePolicyId:'/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/routePolicies/<route-policy-name>',
      exportIpv6RoutePolicyId:'/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/routePolicies/<route-policy-name>'
    }" \
  --ingress-acl-id "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/accessControlLists/<ingress-acl-name>" \
  --egress-acl-id "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/accessControlLists/<egress-acl-name>" \
  --micro-bfd-state "Enabled"
  ```

Expected Output:
```Output
{
  "id": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/networkFabrics/<network-fabric-name>/networkToNetworkInterconnects/<nni-name>",
  "name": "<nni-name>",
  "type": "microsoft.managednetworkfabric/networkfabrics/networktonetworkinterconnects",
  "systemData": {
    "createdBy": "user@contoso.com",
    "createdByType": "User",
    "createdAt": "2023-06-09T04:51:41.251Z",
    "lastModifiedBy": "user@contoso.com",
    "lastModifiedByType": "User",
    "lastModifiedAt": "2023-06-09T04:55:12.000Z"
  },
  "properties": {
    "nniType": "CE",
    "isManagementType": "True",
    "useOptionB": "True",
    "layer2Configuration": {
      "mtu": 1500,
      "interfaces": [
        "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/networkDevices/<network-device-name>/networkInterfaces/<network-interface-name>"
      ]
    },
    "optionBLayer3Configuration": {
      "primaryIpv4Prefix": "20.0.0.12/29",
      "primaryIpv6Prefix": "4FFE:FFFF:0:CD30::a8/127",
      "secondaryIpv4Prefix": "20.0.0.14/29",
      "secondaryIpv6Prefix": "6FFE:FFFF:0:CD30::ac/127",
      "peerASN": 2345,
      "vlanId": 1235,
      "fabricASN": 17,
      "peLoopbackIpAddress": [
        "10.0.0.1"
      ],
      "bmpConfiguration": {
        "configurationState": "Enabled"
      },
      "prefixLimits": [
        {
          "maximumRoutes": 1
        }
      ]
    },
    "importRoutePolicy": {
      "importIpv4RoutePolicyId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/routePolicies/<route-policy-name>",
      "importIpv6RoutePolicyId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/routePolicies/<route-policy-name>"
    },
    "exportRoutePolicy": {
      "exportIpv4RoutePolicyId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/routePolicies/<route-policy-name>",
      "exportIpv6RoutePolicyId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/routePolicies/<route-policy-name>"
    },
    "ingressAclId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/accessControlLists/<ingress-acl-name>",
    "egressAclId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedNetworkFabric/accessControlLists/<egress-acl-name>",
    "microBfdState": "Enabled",
    "configurationState": "Succeeded",
    "provisioningState": "Accepted",
    "administrativeState": "Enabled"
  }
}
```

### Example to delete the Network To Network Interconnect resource

Command:
```AzCLI
az networkfabric nni delete \
  --resource-group "<resource-group-name>" \
  --fabric "<network-fabric-name>" \
  --resource-name "<nni-name>"
```
Expected behavior:
- The service first returns 202 Accepted with a Location header that points to the operation status URL.
- When the delete finishes, the service returns 204 No Content with no response body, so the Azure CLI completes without printing any output.
