---
title: Configure root squash settings for Azure Managed Lustre file systems
description: Learn how to configure root squash settings for Azure Managed Lustre file systems. 
ms.topic: how-to
ms.date: 05/03/2024
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: mayabishop

---

# Configure root squash settings for Azure Managed Lustre file systems

Root squash is a security feature that prevents a user with root privileges on a client from accessing files on the remote Managed Lustre file system. This functionality is achieved using the Lustre nodemap feature, and is an important part of protecting user data and system settings from manipulation by untrusted or compromised clients.

In this article, you learn how to configure root squash settings for Azure Managed Lustre file systems. You can configure root squash settings via REST API request during cluster creation, or for an existing cluster.

## Prerequisites

- An Azure subscription. If you don't have an Azure subscription, [create a free account](https://azure.microsoft.com/free/) before you begin.

## Root squash settings

The following table details the available parameters for the `rootSquashSettings` property, which is available for REST API version 2024-03-01 and later:

| Parameter | Values | Type | Description |
| --- | --- | --- | --- |
| `mode` | `RootOnly`, `All`, `None` | String | `RootOnly`: Affects only the **root** user on nontrusted systems. UID and GID on files are squashed to the provided `squashUID` and `squashGID`, respectively.</br>`All`: Affects **all** users on nontrusted systems. UID and GID on files are squashed to the provided `squashUID` and `squashGID`, respectively.</br>`None` (default): Disables the root squash feature so that no squashing of UID and GID is performed for any user on any system. |
| `noSquashNidLists` | | String | Network ID (NID) IP address lists added to the trusted systems. |
| `squashUID` | 1 - 4294967295 | Integer | Numeric value that the user ID (UID) is squashed to. |
| `squashGID` | 1 - 4294967295 | Integer | Numeric value that the group ID (GID) is squashed to. |
| `status` | | String | File system squash status. |

If you need to add noncontiguous IP addresses as trusted systems, you can provide a semicolon-separated list of IP addresses in the `noSquashNidLists` parameter, as shown in the following example:

```json
"noSquashNidLists": "10.0.2.4@tcp;10.0.2.[6-8]@tcp;10.0.2.10@tcp",
```

## Enable root squash during cluster creation

When you create an Azure Managed Lustre file system, you can enable root squash during cluster creation.

To enable root squash during cluster creation, follow these steps:

1. Decide on the root squash settings you want to use for your cluster. For more information, see [Root squash settings](#root-squash-settings).
1. Use a `PUT` request to create a cluster, and include the desired `rootSquashSettings` values in the `properties` section of the request body.

The following example shows how to create a cluster with root squash enabled:

**Request syntax**:

```http
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageCache/amlFilesystems/{filesystemName}?api-version={apiVersion}
```

**Request body**:

```json
"properties": {
    "rootSquashSettings": {
        "mode": "RootOnly",
        "noSquashNidLists": "10.0.2.4@tcp",
        "squashUID": 1000,
        "squashGID": 1000
    },
}
```

## View root squash settings for an existing cluster

You can view the root squash settings for an existing Azure Managed Lustre file system. To view the root squash settings for an existing cluster, follow these steps:

1. Use a `GET` request to return the configuration details for an existing cluster.

The following example shows how to return an existing cluster:

**Request syntax**:

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageCache/amlFilesystems/{filesystemName}?api-version={apiVersion}
```

In the response body, find the `rootSquashSettings` property to view the current root squash settings for the cluster.

## Change root squash settings for an existing cluster

You can change the root squash settings for an existing Azure Managed Lustre file system. To change the root squash settings for an existing cluster, follow these steps:

1. Decide on the root squash settings you want to change or enable for your existing cluster. For more information, see [Root squash settings](#root-squash-settings).
1. Use a `PATCH` request to modify the existing cluster, and include the desired `rootSquashSettings` values in the `properties` section of the request body. This action overwrites any existing root squash settings, so make sure all settings are provided with the `PATCH` request.

Let's say you need to add a new IP address range to the `noSquashNidLists` parameter. The following example shows how to update an existing cluster to add a new IP address range to the `noSquashNidLists` parameter:

**Request syntax**:

```http
PATCH https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageCache/amlFilesystems/{filesystemName}?api-version={apiVersion}
```

**Request body**:

```json
"properties": {
    "rootSquashSettings": {
        "mode": "RootOnly",
        "noSquashNidLists": "10.0.2.4@tcp;10.0.2.[6-8]@tcp",
        "squashUID": 1000,
        "squashGID": 1000
    },
}
```

In this example, even though the `mode`, `squashUID`, and `squashGID` parameters aren't changing, you must include them in the `PATCH` request body to avoid the values being overwritten.

## Disable root squash for an existing cluster

You can disable root squash for an existing Azure Managed Lustre file system. To disable root squash for an existing cluster, follow these steps:

1. Use a `PATCH` request to modify the existing cluster, and set the `mode` parameter to `None` in the `properties` section of the request body. No other parameters are required.

The following example shows how to disable root squash for an existing cluster:

**Request syntax**:

```http
PATCH https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageCache/amlFilesystems/{filesystemName}?api-version={apiVersion}
```

**Request body**:

```json
"properties": {
    "rootSquashSettings": {
        "mode": "None"
    },
}
```

## Next steps

To learn more about Azure Managed Lustre, see the following articles:

- [What is Azure Managed Lustre?](amlfs-overview.md)
- [Create an Azure Managed Lustre file system](create-file-system-portal.md)
