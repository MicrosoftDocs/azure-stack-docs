---
title: 'Azure Operator Nexus: Network Fabric Option A and Option B'
description: Learn about Azure Operator Nexus - Network Fabric Option A and Option B.
author: jmmason70
ms.author: jeffreymason
ms.service: azure-operator-nexus
ms.topic: concept-article
ms.date: 02/12/2025
---

# Network Fabric Option A and Option B

Border Gateway Protocol (BGP) is a protocol used on the internet between routers to allow traffic to be routed between autonomous systems. Autonomous systems use BGP to advertise to their peers, which IPs they can route to, and which autonomous systems they go through to get there. For example, an internet service provider advertises traffic to enter their network via their ingress points. They advertise that they know how to route to the public IPs on their network, without having to share how they do that routing internally.

The edge routers in each autonomous system are manually configured with a set of BGP peers they trust. They accept traffic routed only from those peers.

Two peering standards are relevant to Azure Operator Nexus:

- **Option A**: This option is simpler but less scalable than Option B and supports only IPv4 in the standard. It can also support IPv6 and multicast, but implementation is dependent and isn't guaranteed.
- **Option B**: This option is more complex than Option A but supports IPv4, IPv6, and multicast in the standard. It's also more scalable than Option A. Azure Operator Nexus supports IPv4, IPv6, and multicast.

For more information on multiautonomous systems, see section 10 of [Request for comment 4364](https://www.ietf.org/rfc/rfc4364.txt).

For more information on the commands involved in creating and provisioning Network Fabric, see [Create and provision Network Fabric by using the Azure CLI](./howto-configure-network-fabric.md).

Option A and Option B are specified in the following steps for the `fabric create` operation and the network-to-network interface (NNI) `nni create` operation.

### Fabric create

Specified in the following property:

- `--managed-network-config [Required]`: Configuration required to set up the management network.

#### Examples

- The `fabric create` operation with Option A properties:
   
   ```azurecli
   
   az networkfabric fabric create \
   --resource-group "<NFResourceGroup>" \
   --location "<Location>" \
   --resource-name "<NFName>" \
   --nf-sku "<NFSKU>" \
   --fabric-version "x.x.x" \
   --nfc-id "/subscriptions/<subscription_id>/resourceGroups/<NFResourceGroup>/providers/Microsoft.ManagedNetworkFabric/networkFabricControllers/<NFCName>" \
   --fabric-asn 65048 \
   --ipv4-prefix x.x.x.x/19 \
   --rack-count 4 \
   --server-count-per-rack 8 \
   --ts-config "{primaryIpv4Prefix:'x.x.x.x/30',secondaryIpv4Prefix:'x.x.x.x/30',username:'****',password:'*****',serialNumber:<TS_SN>}" \
   --managed-network-config "{infrastructureVpnConfiguration:{networkToNetworkInterconnectId:'/subscriptions/xxxxx-xxxx-xxxx-xxxx-xxxxx/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/networkFabrics/example-fabric/networkToNetworkInterconnects/example-nni',peeringOption:OptionA,optionAProperties:{bfdConfiguration:{multiplier:5,intervalInMilliSeconds:300},mtu:1500,vlanId:520,peerASN:65133,primaryIpv4Prefix:'x.x.x.x/31',secondaryIpv4Prefix:'x.x.x.x/31'}},workloadVpnConfiguration:{networkToNetworkInterconnectId:'/subscriptions/xxxxx-xxxx-xxxx-xxxx-xxxxx/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/networkFabrics/example-fabric/networkToNetworkInterconnects/example-nni',peeringOption:OptionA,optionAProperties:{bfdConfiguration:{multiplier:5,intervalInMilliSeconds:300},mtu:1500,vlanId:520,peerASN:65133,primaryIpv4Prefix:'x.x.x.x/31',secondaryIpv4Prefix:'x.x.x.x/31',primaryIpv6Prefix:'xxxx:xxxx:xxxx:xxxx::xx/127',secondaryIpv6Prefix:'xxxx:xxxx:xxxx:xxxx::xx/127'}}}"
   
   ```

- The `fabric create` operation with Option B properties:

    ```azurecli
   
    az networkfabric fabric create \
    --resource-group "<NFResourceGroup>" \
    --location "<Location>" \
    --resource-name "<NFName>" \
    --nf-sku "<NFSKU>" \
    --fabric-version "x.x.x" \
    --nfc-id "/subscriptions/<subscription_id>/resourceGroups/<NFResourceGroup>/providers/Microsoft.ManagedNetworkFabric/networkFabricControllers/<NFCName>" \
    --fabric-asn 65048 \
    --ipv4-prefix "x.x.x.x/19" \
    --ipv6-prefix "xxxx:xxxx:xxxx:xxxx::xx/59" \
    --rack-count 8 \
    --server-count-per-rack 16 \
    --ts-config '{"primaryIpv4Prefix": "x.x.x.x/30", "secondaryIpv4Prefix": "x.x.x.x/30", "username": "'$TS_USER'", "password": "'$TS_PASSWORD'", "serialNumber": "<TS_SN>",    "primaryIpv6Prefix": "xxxx:xxxx:xxxx:xxxx::xx/64", "secondaryIpv6Prefix": "xxxx:xxxx:xxxx:xxxx::xx/64"}' \
    --managed-network-config '{"infrastructureVpnConfiguration": {"peeringOption": "OptionB", "optionBProperties": {"routeTargets": {"exportIpv4RouteTargets": ["13979:2928504", "13979:106948"], "exportIpv6RouteTargets": ["13979:2928504", "13979:106948"], "importIpv4RouteTargets": ["13979:2928504", "13979:106947"], "importIpv6RouteTargets": ["13979:2928504", "13979:106947"]}}}, "workloadVpnConfiguration": {"peeringOption": "OptionB", "optionBProperties": {"routeTargets": {"exportIpv4RouteTargets": ["13979:2928516"], "exportIpv6RouteTargets": ["13979:2928516"], "importIpv4RouteTargets": ["13979:2928516"], "importIpv6RouteTargets": ["13979:2928516"]}}}}'
   
    ```

### NNI create

The NNI is created after the `fabric create` operation but before network device update and fabric provision.

Specified in the following properties:

- `--use-option-b  [Required]`: Selection of Option B for NNI. Allowed values: `False` and `True`.

   - For Option A, set to `False`.
   - For Option B, set to `True`.

- `--option-b-layer3-configuration`: Common properties for Option B `Layer3Configuration`.

#### Examples

- The `nni create` operation with Option A properties:
    
    ```azurecli
    
    az networkfabric nni create \
    --resource-group "<NFResourceGroup>" \
    --fabric "<NFFabric>" \
    --resource-name "<NFNNIName>" \
    --nni-type "CE" \
    --is-management-type "True" \
    --use-option-b "False" \
    --layer2-configuration "{interfaces:['/subscriptions/xxxxx-xxxx-xxxx-xxxx-xxxxx/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/networkDevices/example-networkDevice/networkInterfaces/example-interface'],mtu:1500}" \
    --layer3-configuration '{"peerASN": 65048, "vlanId": 501, "primaryIpv4Prefix": "x.x.x.x/30", "secondaryIpv4Prefix": "x.x.x.x/30", "primaryIpv6Prefix": "xxxx:xxxx:xxxx:xxxx::xx/127", "secondaryIpv6Prefix": "xxxx:xxxx:xxxx:xxxx::xx/127"}' \
    --ingress-acl-id "/subscriptions/xxxxx-xxxx-xxxx-xxxx-xxxxx/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/accesscontrollists/example-Ipv4ingressACL" \
    --egress-acl-id "/subscriptions/xxxxx-xxxx-xxxx-xxxx-xxxxx/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/accesscontrollists/example-Ipv4egressACL"
    
    
    ````

- The `nni create` operation with Option B properties:

    ```azurecli
    
    az networkfabric nni create \
    --resource-group "<NFResourceGroup>" \
    --fabric "<NFFabric>" \
    --resource-name "<NFNNIName>" \
    --nni-type "CE" \
    --is-management-type "True" \
    --use-option-b "True" \
    --layer2-configuration "{interfaces:['/subscriptions/xxxxx-xxxx-xxxx-xxxx-xxxxx/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/networkDevices/example-networkDevice/networkInterfaces/example-interface'],mtu:1500}" \
    --option-b-layer3-configuration "{peerASN:28,vlanId:501,primaryIpv4Prefix:'x.x.x.x/30',secondaryIpv4Prefix:'x.x.x.x/30',primaryIpv6Prefix:'xxxx:xxxx:xxxx:xxxx::xx/127',secondaryIpv6Prefix:'xxxx:xxxx:xxxx:xxxx::xx/127'}" \
    --ingress-acl-id "/subscriptions/xxxxx-xxxx-xxxx-xxxx-xxxxx/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/accesscontrollists/example-Ipv4ingressACL" \
    --egress-acl-id "/subscriptions/xxxxx-xxxx-xxxx-xxxx-xxxxx/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/accesscontrollists/example-Ipv4egressACL"
    
    ````