---
title: Manage emergency access to a bare metal machine using the `az networkcloud cluster baremetalmachinekeyset` command for Azure Operator Nexus
description: Step by step guide on using the `az networkcloud cluster baremetalmachinekeyset` command to manage emergency access to a bare metal machine.
author: DanCrank
ms.author: danielcrank
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 06/12/2024
ms.custom: template-how-to, devx-track-azurecli
---

# Manage emergency access to a bare metal machine using the `az networkcloud cluster baremetalmachinekeyset`

> [!CAUTION]
> Please note this process is used in emergency situations when all other troubleshooting options using Azure have been exhausted. Any write or edit actions executed on the BMM node(s) will require users to ['reimage'](./howto-baremetal-functions.md) in order to restore Microsoft support to the impacted BMM node(s).
Please note that SSH access to these bare metal machines is restricted to users managed via this method from the specified jump host list.

There are rare situations where a user needs to investigate & resolve issues with a bare metal machine and all other ways via Azure are exhausted. Azure Operator Nexus provides the `az networkcloud cluster baremetalmachinekeyset` command so users can manage SSH access to these bare metal machines. On keyset creation, users are validated against Microsoft Entra ID for proper authorization by cross referencing the User Principal Name provided for a user against the supplied Microsoft Entra Group ID `--azure-group-id <Entra Group ID>`.

Users in a keyset are validated every four hours, and also when any changes are made to any keyset. Each user's status is then set to "Active" or "Invalid." Invalid users remain in the keyset but their keys are removed from all hosts and they aren't allowed access. Reasons for a user being invalid are:
- The user's User Principal Name hasn't been specified
- The user's User Principal Name isn't a member of the given Entra group
- The given Entra group doesn't exist (in which case all users in the keyset are invalid)
- The keyset is expired (in which case all users in the keyset are invalid)

> [!NOTE]
>> The User Principal Name is now required for keysets as Microsoft Entra ID validation is enforced for all users. Current keysets that do not specify User Principal Names for all users will continue to work until the expiration date. If a keyset without User Principal Names expires, the keyset will need to be updated with User Principal Names, for all users, in order to become valid again. Keysets that have not been updated with the User Principal Names for all users prior to December 2024 are at-risk of being `Invalid`. Note that if any user fails to specify a User Principal Name this results in the entire keyset being invalidated.

The keyset and each individual user also have detailed status messages communicating other information:
- The keyset's detailedStatusMessage tells you whether the keyset is expired, and other information about problems encountered while updating the keyset across the cluster.
- The user's statusMessage tells you whether the user is active or invalid, and a list of machines that aren't yet updated to the user's latest active/invalid state. In each case, causes of problems are included if known.

When the command runs, it executes on each bare metal machine in the Cluster with an active Kubernetes node. There's a reconciliation process that runs periodically that retries the command on any bare metal machine that wasn't available at the time of the original command. Also, any bare metal machine that returns to the cluster via an `az networkcloud baremetalmachine reimage` or `az networkcloud baremetalmachine replace` command (see [BareMetal functions](./howto-baremetal-functions.md)) sends a signal causing any active keysets to be sent to the machine as soon as it returns to the cluster. Multiple commands execute in the order received.

> [!WARNING]
> Using an Entra Group ID with greater than 5,000 users isn't recommended. Reconciling a large number of users can result in timeouts, blocking access and causing login issues.

> [!CAUTION]
> Notes for jump host IP addresses

- The keyset create/update process adds the jump host IP addresses to the IP tables for each machine in the Cluster. The IP tables update restricts SSH access to be allowed only from those jump hosts.
- It's important to specify the Cluster facing IP addresses for the jump hosts. These IP addresses might be different than the public facing IP address used to access the jump host.
- While at least one keyset is defined, ssh access is allowed from any jump host in any keyset. For example, if keyset A specifies jump host A and keyset B specifies jump host B, users in either keyset can use either jump host A or B.
- While no keysets are defined, ssh access is allowed from any jump host that has network connectivity to the machines.

> [!NOTE]
> The privilege level of a keyset can't be changed via the update command. If you need to change a keyset's privilege level, you must delete & recreate the keyset with the new privilege level.

## Prerequisites

- Install the latest version of the [appropriate CLI extensions](./howto-install-cli-extensions.md).
- The on-premises Cluster must have connectivity to Azure.
- Get the Resource Group name for the `Cluster` resource.
- The process applies keysets to all running bare metal machines.
- The added users must be part of a Microsoft Entra group. For more information, see [How to Manage Groups](/azure/active-directory/fundamentals/how-to-manage-groups).
- To restrict access for managing keysets, create a custom role. For more information, see [Azure Custom Roles](/azure/role-based-access-control/custom-roles). In this instance, add or exclude permissions for `Microsoft.NetworkCloud/clusters/bareMetalMachineKeySets`. The options are `/read`, `/write`, and `/delete`.

> [!NOTE]
> When bare metal machine access is created, modified, or deleted via the commands described in this
> article, a background process delivers those changes to the machines. This process is paused during
> Operator Nexus software upgrades. If an upgrade is known to be in progress, you can use the `--no-wait`
> option with the command to prevent the command prompt from waiting for the process to complete.

## Creating a bare metal machine keyset

The `baremetalmachinekeyset create` command creates SSH access to the bare metal machine in a Cluster for a group of users.

The command syntax is:

```azurecli
az networkcloud cluster baremetalmachinekeyset create \
  --name "<bare metal machine Keyset Name>" \
  --extended-location name="<Extended Location ARM ID>" \
    type="CustomLocation" \
  --location "<Azure Region>" \
  --azure-group-id "<Azure Group ID>" \
  --expiration "<Expiration Timestamp>" \
  --jump-hosts-allowed "<List of jump server IP addresses>" \
  --os-group-name "<Name of the Operating System Group>" \
  --privilege-level "<"Standard", "Superuser" or "Other">" \
  --user-list '[{"description":"<User List Description>","azureUserName":"<User Name>",\
    "sshPublicKey":{"keyData":"<SSH Public Key>"}, \
    "userPrincipalName":""}]', \
  --tags key1="<Key Value>" key2="<Key Value>" \
  --cluster-name "<Cluster Name>" \
  --resource-group "<cluster_RG>"
```

### Create Arguments

```azurecli
  --bare-metal-machine-key-set-name --name -n [Required] : The name of the bare metal machine key
                                                            set.
  --cluster-name                              [Required] : The name of the cluster.
  --resource-group -g                         [Required] : Name of resource group. You can
                                                            configure the default group using `az
                                                            configure --defaults group=<name>`.
  --if-match                                             : The ETag of the transformation. Omit
                                                            this value to always overwrite the
                                                            current resource. Specify the last-seen
                                                            ETag value to prevent accidentally
                                                            overwriting concurrent changes.
  --if-none-match                                        : Set to '*' to allow a new record set to
                                                            be created, but to prevent updating an
                                                            existing resource. Other values will
                                                            result in error from server as they are
                                                            not supported.
  --no-wait                                              : Do not wait for the long-running
                                                            operation to finish.  Allowed values:
                                                            0, 1, f, false, n, no, t, true, y, yes.
  --extended-location                         [Required] : The extended location of the cluster
                                                            associated with the resource.  Support
                                                            shorthand-syntax, json-file and yaml-
                                                            file. Try "??" to show more.
  --location -l                                          : The geo-location where the resource
                                                            lives  When not specified, the location
                                                            of the resource group will be used.
  --tags                                                 : Resource tags.  Support shorthand-
                                                            syntax, json-file and yaml-file. Try
                                                            "??" to show more.
  --azure-group-id                            [Required] : The object ID of Azure Active Directory
                                                            group that all users in the list must
                                                            be in for access to be granted. Users
                                                            that are not in the group will not have
                                                            access.
  --expiration                                [Required] : The date and time after which the users
                                                            in this key set will be removed from
                                                            the bare metal machines.
  --jump-hosts-allowed                        [Required] : The list of IP addresses of jump hosts
                                                            with management network access from
                                                            which a login will be allowed for the
                                                            users.  Support shorthand-syntax, json-
                                                            file and yaml-file. Try "??" to show
                                                            more.
  --privilege-level                           [Required] : The access level allowed for the users
                                                            in this key set.  Allowed values:
                                                            Other, Standard, Superuser.
  --user-list                                 [Required] : The unique list of permitted users.
                                                            Support shorthand-syntax, json-file and
                                                            yaml-file. Try "??" to show more.
  --os-group-name                                        : The name of the group that users will
                                                            be assigned to on the operating system
                                                            of the machines.
  --privilege-level-name                                 : The name of the access level to apply
                                                            when the privilege level is set to
                                                            Other.
```

### Global Azure CLI arguments (applicable to all commands)

```azurecli
  --debug                                                : Increase logging verbosity to show all
                                                            debug logs.
  --help -h                                              : Show this help message and exit.
  --only-show-errors                                     : Only show errors, suppressing warnings.
  --output -o                                            : Output format.  Allowed values: json,
                                                            jsonc, none, table, tsv, yaml, yamlc.
                                                            Default: json.
  --query                                                : JMESPath query string. See
                                                            http://jmespath.org/ for more
                                                            information and examples.
  --subscription                                         : Name or ID of subscription. You can
                                                            configure the default subscription
                                                            using `az account set -s NAME_OR_ID`.
  --verbose                                              : Increase logging verbosity. Use --debug
                                                            for full debug logs.
```

This example creates a new keyset with two users that have standard access from two jump hosts.

```azurecli
az networkcloud cluster baremetalmachinekeyset create \
  --name "bareMetalMachineKeySetName" \
  --extended-location name="/subscriptions/subscriptionId/resourceGroups/cluster_RG/providers/Microsoft.ExtendedLocation/customLocations/clusterExtendedLocationName" \
    type="CustomLocation" \
  --location "eastus" \
  --azure-group-id "f110271b-XXXX-4163-9b99-214d91660f0e" \
  --expiration "2022-12-31T23:59:59.008Z" \
  --jump-hosts-allowed "192.0.2.1" "192.0.2.5" \
  --os-group-name "standardAccessGroup" \
  --privilege-level "Standard" \
  --user-list '[{"description":"Needs access for troubleshooting as a part of the support team","azureUserName":"userABC", "sshPublicKey":{"keyData":"ssh-rsa  AAtsE3njSONzDYRIZv/WLjVuMfrUSByHp+jfaaOLHTIIB4fJvo6dQUZxE20w2iDHV3tEkmnTo84eba97VMueQD6OzJPEyWZMRpz8UYWOd0IXeRqiFu1lawNblZhwNT/ojNZfpB3af/YDzwQCZgTcTRyNNhL4o/blKUmug0daSsSXISTRnIDpcf5qytjs1XoyYyJMvzLL59mhAyb3p/cD+Y3/s3WhAx+l0XOKpzXnblrv9d3q4c2tWmm/SyFqthaqd0= admin@vm"},"userPrincipalName":"example@contoso.com"},\
  {"description":"Needs access for troubleshooting as a part of the support team","azureUserName":"userXYZ","sshPublicKey":{"keyData":"ssh-rsa  AAtsE3njSONzDYRIZv/WLjVuMfrUSByHp+jfaaOLHTIIB4fJvo6dQUZxE20w2iDHV3tEkmnTo84eba97VMueQD6OzJPEyWZMRpz8UYWOd0IXeRqiFu1lawNblZhwNT/ojNZfpB3af/YDzwQCZgTcTRyNNhL4o/blKUmug0daSsSXTSTRnIDpcf5qytjs1XoyYyJMvzLL59mhAyb3p/cD+Y3/s3WhAx+l0XOKpzXnblrv9d3q4c2tWmm/SyFqthaqd0= admin@vm"}, "userPrincipalName":"example@contoso.com"}]' \
  --tags key1="myvalue1" key2="myvalue2" \
  --cluster-name "clusterName"
  --resource-group "cluster_RG"
```
This example creates a new keyset with two users that have Other access from two jump hosts. Privilege level "Other" requires the v20250701preview version of the Network Cloud API. 
```azurecli
az networkcloud cluster baremetalmachinekeyset create \
  --name "bareMetalMachineKeySetName" \
  --extended-location name="/subscriptions/subscriptionId/resourceGroups/cluster_RG/providers/Microsoft.ExtendedLocation/customLocations/clusterExtendedLocationName" \
    type="CustomLocation" \
  --location "eastus" \
  --azure-group-id "f110271b-XXXX-4163-9b99-214d91660f0e" \
  --expiration "2022-12-31T23:59:59.008Z" \
  --jump-hosts-allowed "192.0.2.1" "192.0.2.5" \
  --os-group-name "standardAccessGroup" \
  --privilege-level "Other" \
  --privilege-level-name "SecurityScanner" \
  --user-list '[{"description":"Needs access for troubleshooting as a part of the support team","azureUserName":"userABC", "sshPublicKey":{"keyData":"ssh-rsa  AAtsE3njSONzDYRIZv/WLjVuMfrUSByHp+jfaaOLHTIIB4fJvo6dQUZxE20w2iDHV3tEkmnTo84eba97VMueQD6OzJPEyWZMRpz8UYWOd0IXeRqiFu1lawNblZhwNT/ojNZfpB3af/YDzwQCZgTcTRyNNhL4o/blKUmug0daSsSXISTRnIDpcf5qytjs1XoyYyJMvzLL59mhAyb3p/cD+Y3/s3WhAx+l0XOKpzXnblrv9d3q4c2tWmm/SyFqthaqd0= admin@vm"},"userPrincipalName":"example@contoso.com"},\
  {"description":"Needs access for troubleshooting as a part of the support team","azureUserName":"userXYZ","sshPublicKey":{"keyData":"ssh-rsa  AAtsE3njSONzDYRIZv/WLjVuMfrUSByHp+jfaaOLHTIIB4fJvo6dQUZxE20w2iDHV3tEkmnTo84eba97VMueQD6OzJPEyWZMRpz8UYWOd0IXeRqiFu1lawNblZhwNT/ojNZfpB3af/YDzwQCZgTcTRyNNhL4o/blKUmug0daSsSXTSTRnIDpcf5qytjs1XoyYyJMvzLL59mhAyb3p/cD+Y3/s3WhAx+l0XOKpzXnblrv9d3q4c2tWmm/SyFqthaqd0= admin@vm"}, "userPrincipalName":"example@contoso.com"}]' \
  --tags key1="myvalue1" key2="myvalue2" \
  --cluster-name "clusterName"
  --resource-group "cluster_RG"
```

For assistance in creating the `--user-list` structure, see [Azure CLI Shorthand](https://github.com/Azure/azure-cli/blob/dev/doc/shorthand_syntax.md).

## Adding the same user to multiple keysets with different SSH keys

Azure Operator Nexus supports adding the same user to multiple bare metal machine keysets, each with a different SSH public key. When a user appears in multiple keysets, the system automatically consolidates all SSH keys from all keysets and adds them to the user's `authorized_keys` file on all bare metal machines in the cluster.

### How it works

When multiple keysets contain the same user (identified by `azureUserName`), the system:

1. **Consolidates SSH keys**: All unique SSH public keys from all keysets are collected and merged into a single list for that user
2. **Merges group memberships**: The user is added to all groups associated with the keysets they belong to
3. **Maintains single user account**: The user receives a single UID across all keysets, but can belong to multiple groups
4. **Tracks keyset membership**: The system maintains a mapping of which keysets each user belongs to

### Use cases

This feature is useful in scenarios such as:

- **Multiple jump hosts**: A user needs to access bare metal machines from different jump hosts, each with its own SSH key
- **Key rotation**: Gradually rotating SSH keys by adding a new key in a new keyset while keeping the old key active in another keyset
- **Team access management**: Different teams can manage their own keysets, and a user can be included in multiple teams with different keys
- **Temporary access**: Providing temporary access via a separate keyset with a different key, which can be easily revoked by deleting that keyset

### Example: Adding a user to two keysets with different SSH keys

This example creates two keysets for the same user with different SSH keys:

**Keyset 1: Production Access**

```azurecli
az networkcloud cluster baremetalmachinekeyset create \
  --name "production-keyset" \
  --extended-location name="/subscriptions/subscriptionId/resourceGroups/cluster_RG/providers/Microsoft.ExtendedLocation/customLocations/clusterExtendedLocationName" \
    type="CustomLocation" \
  --location "eastus" \
  --azure-group-id "f110271b-XXXX-4163-9b99-214d91660f0e" \
  --expiration "2025-12-31T23:59:59.008Z" \
  --jump-hosts-allowed "192.0.2.1" \
  --os-group-name "prod-group" \
  --privilege-level "Standard" \
  --user-list '[{
    "description": "Production access for user",
    "azureUserName": "john.doe",
    "sshPublicKey": {"keyData": "from=\"192.0.2.1\" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... keyset1-key"},
    "userPrincipalName": "john.doe@contoso.com"
  }]' \
  --cluster-name "clusterName" \
  --resource-group "cluster_RG"
```

**Keyset 2: Production Secondary Access (Same User, Different Key)**

```azurecli
az networkcloud cluster baremetalmachinekeyset create \
  --name "production-secondary-keyset" \
  --extended-location name="/subscriptions/subscriptionId/resourceGroups/cluster_RG/providers/Microsoft.ExtendedLocation/customLocations/clusterExtendedLocationName" \
    type="CustomLocation" \
  --location "eastus" \
  --azure-group-id "f110271b-XXXX-4163-9b99-214d91660f0e" \
  --expiration "2025-12-31T23:59:59.008Z" \
  --jump-hosts-allowed "192.0.2.5" \
  --os-group-name "prod-secondary-group" \
  --privilege-level "Standard" \
  --user-list '[{
    "description": "Production secondary access for user",
    "azureUserName": "john.doe",
    "sshPublicKey": {"keyData": "from=\"192.0.2.5\" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD... keyset2-key"},
    "userPrincipalName": "john.doe@contoso.com"
  }]' \
  --cluster-name "clusterName" \
  --resource-group "cluster_RG"
```

After both keysets are created and reconciled:

- The user `john.doe` will have **both SSH keys** in their `authorized_keys` file
- The user will belong to **both groups**: `prod-group` and `prod-secondary-group`
- The user can authenticate using **either SSH key** from the related jump host defined in the keyset
- Both keysets will show the user as "Active" in their status

### Important considerations

#### User Principal Name (UPN) consistency

The same `userPrincipalName` must be used across all keysets for the same user. The system validates users against the Azure AD group specified in each keyset's `azureGroupId`. All keysets must reference Azure AD groups that contain the user's UPN.

#### SSH key uniqueness

- **Within a keyset**: Each user can only have one SSH key per keyset
- **Across keysets**: The same user can have different SSH keys in different keysets

#### Group membership

When a user is in multiple keysets:

- The user is added to all groups associated with those keysets
- Each keyset can have a different `osGroupName` and `privilegeLevel`
- The user's effective permissions are the union of all groups they belong to

#### Keyset expiration

- If one keyset expires, the user's SSH keys from that keyset are removed
- Keys from other active keysets remain valid
- The user remains active as long as at least one keyset containing them is active

#### Keyset deletion

- Deleting a keyset removes the SSH keys associated with that keyset for all users
- If a user is in multiple keysets, they retain access via keys from other active keysets
- The user account itself is not deleted unless they are removed from all keysets

### Adding a new SSH key for an existing user

To add a new SSH key for a user already in another keyset, create a new keyset or update an existing one:

```azurecli
az networkcloud cluster baremetalmachinekeyset update \
  --name "production-keyset" \
  --user-list '[{
    "description": "Production access for user",
    "azureUserName": "john.doe",
    "sshPublicKey": {"keyData": "from=\"192.0.2.1\" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQE... new-key"},
    "userPrincipalName": "john.doe@contoso.com"
  }]' \
  --cluster-name "clusterName" \
  --resource-group "cluster_RG"
```

> [!NOTE]
> When updating a keyset, you must provide the complete user list. The update replaces the existing user list for that keyset, not merges with it.

### Removing a user from one keyset

To remove a user from a specific keyset while keeping them in others, update the keyset to remove that user from the `--user-list`:

```azurecli
az networkcloud cluster baremetalmachinekeyset update \
  --name "production-secondary-keyset" \
  --user-list '[{
    "description": "Another user",
    "azureUserName": "jane.smith",
    "sshPublicKey": {"keyData": "from=\"192.0.2.5\" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQF..."},
    "userPrincipalName": "jane.smith@contoso.com"
  }]' \
  --cluster-name "clusterName" \
  --resource-group "cluster_RG"
```

This removes `john.doe` from the production-secondary-keyset keyset but keeps them in the production keyset.

### Verifying user status across keysets

Use the `show` command to verify a user's status in each keyset:

```azurecli
# Check production primary keyset
az networkcloud cluster baremetalmachinekeyset show \
  --name "production-primary-keyset" \
  --cluster-name "clusterName" \
  --resource-group "cluster_RG"

# Check production secondary keyset
az networkcloud cluster baremetalmachinekeyset show \
  --name "production-secondary-keyset" \
  --cluster-name "clusterName" \
  --resource-group "cluster_RG"
```

The status output will show:

- `userListStatus`: Array showing each user's status (Active/Invalid)
- `statusMessage`: Details about the user's status, including which nodes they're active on

### Verifying SSH keys on bare metal machine

After reconciliation completes, you can verify that both keys are present by checking the user's `authorized_keys` file on a bare metal machine:

```bash
# SSH into the bare metal machine (from an allowed jump host)
ssh user@bare-metal-machine

# Check authorized_keys (as the user)
cat ~/.ssh/authorized_keys
```

You should see both SSH keys listed in the file.

### Best practices

1. **Use descriptive keyset names**: Name keysets to reflect their purpose (e.g., "production-operations-primary", "production-operations-secondary")

2. **Document key sources**: Use the `description` field in user entries to document which device or purpose each key serves

3. **Manage expiration dates**: Set appropriate expiration dates for each keyset based on its purpose and security requirements

4. **Monitor keyset status**: Regularly check keyset status to ensure users remain active and valid

5. **Key rotation strategy**: When rotating keys, create a new keyset with the new key, verify access works, then remove the old keyset

## Deleting a bare metal machine keyset

The `baremetalmachinekeyset delete` command removes SSH access to the bare metal machine for a group of users. All members of the group no longer have SSH access to any of the bare metal machines in the Cluster.

The command syntax is:

```azurecli
az networkcloud cluster baremetalmachinekeyset delete \
  --name "<bare metal machine Keyset Name>" \
  --cluster-name "<Cluster Name>" \
  --resource-group "<cluster_RG>"
```

### Delete Arguments

```azurecli
  --if-match                                  : The ETag of the transformation. Omit this value to
                                                always overwrite the current resource. Specify the
                                                last-seen ETag value to prevent accidentally
                                                overwriting concurrent changes.
  --if-none-match                             : Set to '*' to allow a new record set to be
                                                created, but to prevent updating an existing
                                                resource. Other values will result in error from
                                                server as they are not supported.
  --no-wait                                   : Do not wait for the long-running operation to
                                                finish.  Allowed values: 0, 1, f, false, n, no, t,
                                                true, y, yes.
  --yes -y                                    : Do not prompt for confirmation.

  --bare-metal-machine-key-set-name --name -n : The name of the bare metal machine key set.
  --cluster-name                              : The name of the cluster.
  --ids                                       : One or more resource IDs (space-delimited). It
                                                should be a complete resource ID containing all
                                                information of 'Resource Id' arguments. You should
                                                provide either --ids or other 'Resource Id'
                                                arguments.
  --resource-group -g                         : Name of resource group. You can configure the
                                                default group using `az configure --defaults
                                                group=<name>`.
  --subscription                              : Name or ID of subscription. You can configure the
                                                default subscription using `az account set -s
                                                NAME_OR_ID`.

```

This example removes the "bareMetalMachineKeysetName" keyset group in the "clusterName" Cluster.

```azurecli
az networkcloud cluster baremetalmachinekeyset delete \
  --name "bareMetalMachineKeySetName" \
  --cluster-name "clusterName" \
  --resource-group "cluster_RG"
```

## Updating a Bare Metal Machine Keyset

The `baremetalmachinekeyset update` command allows users to make changes to an existing keyset group.

The command syntax is:

```azurecli
az networkcloud cluster baremetalmachinekeyset update \
  --name "<bare metal machine Keyset Name>" \
  --jump-hosts-allowed "<List of jump server IP addresses>" \
  --expiration "2022-12-31T23:59:59.008Z" \
  --user-list '[{"description":"<User List Description>","azureUserName":"<User Name>",\
   "sshPublicKey":{"keyData":"<SSH Public Key>"}, \
   "userPrincipalName":""}]', \
  --tags key1="<Key Value>" key2="<Key Value> "\
  --cluster-name "<Cluster Name>" \
  --resource-group "<cluster_RG>"
```

### Update Arguments

```azurecli
  --if-match                                  : The ETag of the transformation. Omit this value to
                                                always overwrite the current resource. Specify the
                                                last-seen ETag value to prevent accidentally
                                                overwriting concurrent changes.
  --if-none-match                             : Set to '*' to allow a new record set to be
                                                created, but to prevent updating an existing
                                                resource. Other values will result in error from
                                                server as they are not supported.
  --no-wait                                   : Do not wait for the long-running operation to
                                                finish.  Allowed values: 0, 1, f, false, n, no, t,
                                                true, y, yes.
  --tags                                      : The Azure resource tags that will replace the
                                                existing ones.  Support shorthand-syntax, json-
                                                file and yaml-file. Try "??" to show more.
  --bare-metal-machine-key-set-name --name -n : The name of the bare metal machine key set.
  --cluster-name                              : The name of the cluster.
  --ids                                       : One or more resource IDs (space-delimited). It
                                                should be a complete resource ID containing all
                                                information of 'Resource Id' arguments. You should
                                                provide either --ids or other 'Resource Id'
                                                arguments.
  --resource-group -g                         : Name of resource group. You can configure the
                                                default group using `az configure --defaults
                                                group=<name>`.
  --subscription                              : Name or ID of subscription. You can configure the
                                                default subscription using `az account set -s
                                                NAME_OR_ID`.
  --expiration                                : The date and time after which the users in this
                                                key set will be removed from the bare metal
                                                machines.
  --jump-hosts-allowed                        : The list of IP addresses of jump hosts with
                                                management network access from which a login will
                                                be allowed for the users.  Support shorthand-
                                                syntax, json-file and yaml-file. Try "??" to show
                                                more.
  --user-list                                 : The unique list of permitted users.  Support
                                                shorthand-syntax, json-file and yaml-file. Try
                                                "??" to show more.
```

This example adds two new users to the "baremetalMachineKeySetName" group and changes the expiry time for the group.

```azurecli
az networkcloud cluster baremetalmachinekeyset update \
  --name "bareMetalMachineKeySetName" \
  --expiration "2023-12-31T23:59:59.008Z" \
  --jump-hosts-allowed "192.0.2.1" "192.0.2.5"
  --user-list '[{"description":"Needs access for troubleshooting as a part of the support team",\
  "azureUserName":"userABC", \
  "sshPublicKey":{"keyData":"ssh-rsa  AAtsE3njSONzDYRIZv/WLjVuMfrUSByHp+jfaaOLHTIIB4fJvo6dQUZxE20w2iDHV3tEkmnTo84eba97VMueQD6OzJPEyWZMRpz8UYWOd0IXeRqiFu1lawNblZhwNT/ojNZfpB3af/YDzwQCZgTcTRyNNhL4o/blKUmug0daSsSXISTRnIDpcf5qytjs1XoyYyJMvzLL59mhAyb3p/cD+Y3/s3WhAx+l0XOKpzXnblrv9d3q4c2tWmm/SyFqthaqd0= admin@vm"}, \
  "userPrincipalName":"example@contoso.com"},\
  {"description":"Needs access for troubleshooting as a part of the support team",\
    "azureUserName":"userXYZ", \
    "sshPublicKey":{"keyData":"ssh-rsa  AAtsE3njSONzDYRIZv/WLjVuMfrUSByHp+jfaaOLHTIIB4fJvo6dQUZxE20w2iDHV3tEkmnTo84eba97VMueQD6OzJPEyWZMRpz8UYWOd0IXeRqiFu1lawNblZhwNT/ojNZfpB3af/YDzwQCZgTcTRyNNhL4o/blKUmug0daSsSXTSTRnIDpcf5qytjs1XoyYyJMvzLL59mhAyb3p/cD+Y3/s3WhAx+l0XOKpzXnblrv9d3q4c2tWmm/SyFqthaqd0= admin@vm"}, \
    "userPrincipalName":"example@contoso.com"}]' \
   --cluster-name "clusterName" \
  --resource-group "cluster_RG"
```

> [!NOTE]
> When you remove a user from a Bare Metal Machine Keyset via an update command, the command response might still show the deleted user. This behavior occurs because the command runs asynchronously and the user delete on the backend might still be in progress. Subsequent gets, lists, or shows on the keyset should have the correct list of users.

## Listing Bare Metal Machine Keysets

The `baremetalmachinekeyset list` command allows users to see the existing keyset groups in a Cluster.

The command syntax is:

```azurecli
az networkcloud cluster baremetalmachinekeyset list \
  --cluster-name "<Cluster Name>" \
  --resource-group "<cluster_RG>"
```

### List Arguments

```azurecli
  --cluster-name                              [Required] : The name of the cluster.
  --resource-group -g                         [Required] : Name of cluster resource group. Optional if
                                                           configuring the default group using `az
                                                           configure --defaults group=<name>`.
```

## Show Bare Metal Machine Keyset Details

The `baremetalmachinekeyset show` command allows users to see the details of an existing keyset group in a Cluster.

The command syntax is:

```azurecli
az networkcloud cluster baremetalmachinekeyset show \
  --cluster-name "<Cluster Name>" \
  --resource-group "<cluster_RG>"
```

### Show Arguments

```azurecli
  --bare-metal-machine-key-set-name --name -n [Required] : The name of the bare metal machine key
                                                           set.
  --cluster-name                              [Required] : The name of the cluster.
  --resource-group -g                         [Required] : Name of cluster resource group. You can
                                                           configure the default group using `az
                                                           configure --defaults group=<name>`.
```

### Troubleshooting

#### User shows as invalid in one keyset

If a user shows as "Invalid" in one keyset but "Active" in another:

- Verify the user's `userPrincipalName` is a member of the Azure AD group specified in that keyset's `azureGroupId`
- Check that the keyset hasn't expired
- Review the `statusMessage` in the keyset status for specific error details

#### SSH key not working

If an SSH key from one keyset doesn't work:

- Verify the keyset status shows the user as "Active"
- Check that the keyset hasn't expired
- Ensure the key was correctly added to the keyset (check for typos in the key data)
- Verify the user can authenticate with keys from other keysets (to confirm the user account itself is working)

#### User removed from all keysets

If a user is accidentally removed from all keysets:

- The user account and their SSH keys will be removed from all bare metal machines
- To restore access, add the user back to at least one active keyset
- The user will receive a new UID when re-added (the system doesn't preserve UIDs for deleted users)
