---
title: Control access using Azure AD and Kubernetes RBAC Azure Kubernetes Service on Azure Stack HCI and Windows Server
description: Learn how to use Azure Active Directory group membership to restrict access to cluster resources using Kubernetes role-based access control (Kubernetes RBAC) in Azure Kubernetes Service on Azure Stack HCI or Windows Server
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 5/12/2022
ms.reviewer: abha
ms.topic: how-to
ms.date: 05/12/2022

# Intent: As an IT Pro, I need to learn how to enable Kubernetes role-based access control so that I can manage access to resources.
# Keyword: Kubernetes role-based access control 

---

# Control access using Azure AD and Kubernetes RBAC Azure Kubernetes Service on Azure Stack HCI and Windows Server

> Applies to: AKS on Azure Stack HCI, AKS runtime on Windows Server 2019 Datacenter and Windows Server 2022

Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server can be configured to use Azure Active Directory (Azure AD) for user authentication. In this configuration, you sign in to an AKS cluster using an Azure AD authentication token. Once authenticated, you can use the built-in Kubernetes role-based access control (Kubernetes RBAC) to manage access to namespaces and cluster resources based on a user's identity or group membership.

This article shows you how to control access using Kubernetes RBAC in an AKS cluster based on Azure AD group membership. You'll create a demo group and users in Azure AD. And then you'll create roles and RoleBindings in the AKS cluster to grant the appropriate permissions to create and view resources.

## Prerequisites

Before your setup Kubernetes RBAC using Azure AD identity, you'll need:

- **An AKS cluster with AKS on Azure Stack HCI and Windows Server**

    You'll need an AKS cluster with AKS on Azure Stack HCI and Windows Server. If you need to set up your cluster, you can find instructions for using [Windows Admin Center](setup.md) or [PowerShell](kubernetes-walkthrough-powershell.md) to deploy AKS on Azure Stack HCI or Windows Server.

- **Azure Arc connection**

    You'll need to have an Azure Arc connection to your AKS cluster on Azure Stack HCI or Windows Server. For instruction on enabling Azure Arc, see [Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc-enabled Kubernetes](connect-to-arc.md).

- You'll need access to the following command line tools:

    - **Azure CLI**

        The Azure command-line interface (Azure CLI) is a set of commands used to create and manage Azure resources. To check if you have the Azure CLI, open a command line tool, and type: `az -v`.
        
        For instructions on installing see, [How to install the Azure CLI](/cli/azure/install-azure-cli).
    
    - **Kubectl**

      The Kubernetes command-line tool, kubectl, allows you to run commands targeting your Kubernetes clusters. To check if you have the kubectl, open a command line tool, and type: `kubectl version --client`. Make sure your kubectl client version is at least` v1.24.0`.
      
      For instructions, see [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl).
    
    - **PowerShell and the AksHci PowerShell module**

        PowerShell is a cross-platform task automation solution made up of a command-line shell, a scripting language, and a configuration management framework. If you have installed AKS on Azure Stack HCI and Windows Server, then you'll have access to the AksHci PowerShell module.
## Optional first steps

If you don't already have an Azure AD group containing members, you may want to create a group and add some members to follow the instructions in this article.

To demonstrate working with Azure AD and Kubernetes RBAC, you can create an Azure AD group for application developers that can be used to show how Kubernetes RBAC and Azure AD control access to cluster resources. In production environments, you can use existing users and groups within an Azure AD tenant.

### Create a demo group in Azure AD

First, create the group in Azure AD in your tenant for the application developers using the [az ad group create](/cli/azure/ad/group#az_ad_group_create) command. The following example has you sign into your Azure tenant and then creates a group named **appdev**:

```azurecli  
az login
az ad group create --display-name appdev --mail-nickname appdev
```

### Add users to your group

With the example group created in Azure AD for our application developers, let's add a user to the `appdev` group. To test the Kubernetes RBAC integration at the end of the article, you sign in to the AKS cluster with this user account.

Add a user to the **appdev** group created in the previous section using the [az ad group member add](/cli/azure/ad/group/member#az_ad_group_member_add) command. If you have quit your session, you'll need to reconnect to Azure using `az login`.

```azurecli  
$AKSDEV_ID = az ad user create --display-name <name> --password <strongpassword> --user-principal-name <name>@contoso.onmicrosoft.com
az ad group member add --group appdev --member-id $AKSDEV_ID
```

## Create a custom Kubernetes RBAC role binding on the AKS cluster resource for the Azure AD group

Configure the AKS cluster to allow your Azure AD group to access the AKS cluster. If you would like to add a group and users to follow the steps in this guide, see [Create demo groups in Azure AD](#create-a-demo-group-in-azure-ad).

1. Get the cluster admin credentials using the [Get-AksHciCredential](./reference/ps/get-akshcicredential.md) command. 

    ```powershell
    Get-AksHciCredential -name <name-of-your-cluster>
    ```

2. Create a namespace in the AKS cluster using the [kubectl create namespace](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#create) command. The following example creates a namespace name **dev**:

    ```bash  
    kubectl create namespace dev
    ```

    In Kubernetes, **Roles** define the permissions to grant, and **RoleBindings** apply the permissions to desired users or groups. These assignments can be applied to a given namespace, or across an entire cluster. For more information, see [Using Kubernetes RBAC authorization](/azure/aks/concepts-identity#kubernetes-rbac).
    
    Create a Role for the **dev** namespace. This role grants full permissions to the namespace. In production environments, you may want to specify more granular permissions for different users or groups.

3. Create a file named `role-dev-namespace.yaml` and paste the following YAML manifest:

    ```yaml
    kind: Role
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: dev-user-full-access
      namespace: dev
    rules:
    - apiGroups: ["", "extensions", "apps"]
      resources: ["*"]
      verbs: ["*"]
    - apiGroups: ["batch"]
      resources:
      - jobs
      - cronjobs
      verbs: ["*"]
    ```

4. Create the Role using the [kubectl apply](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply) command and specify the filename of your YAML manifest:

    ```bash  
    kubectl apply -f role-dev-namespace.yaml
    ```

5. Get the resource ID for the **appdev** group using the [az ad group show](/cli/azure/ad/group#az_ad_group_show) command. This group is set as the subject of a RoleBinding in the next step.

    ```azurecli  
    az ad group show --group appdev --query objectId -o tsv
    ```
    
    Az ad group will return the value you'll use as `groupObjectId`.

    ```output  
    38E5FA30-XXXX-4895-9A00-050712E3673A
    ```

6. Create a file named `rolebinding-dev-namespace.yaml` and paste the following YAML manifest. You're establishing the **RoleBinding** for the **appdev** group to use the `role-dev-namespace` role for namespace access. On the last line, replace `groupObjectId`  with the group object ID produced by the `az ad group show` command:

    ```yaml
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: dev-user-access
      namespace: dev
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: dev-user-full-access
    subjects:
    - kind: Group
      namespace: dev
      name: groupObjectId
    ```
    
    > [!TIP]  
    > If you want to create the **RoleBinding** for a single user, specify `kind: User` and replace `groupObjectId` with the user principal name (UPN) in the sample.

7. Create the **RoleBinding** using the [kubectl apply](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply) command and specify the filename of your YAML manifest:

    ```bash  
    kubectl apply -f rolebinding-dev-namespace.yaml
    ```
    
    ```output  
    rolebinding.rbac.authorization.k8s.io/dev-user-access created
    ```
## Use built-in Kubernetes RBAC roles for your AKS cluster resource

Kubernetes also provides built-in user-facing roles. These built-in roles include:

- Super-user roles (cluster-admin)
- Roles intended to be granted cluster-wide using ClusterRoleBindings
- Roles intended to be granted within particular namespaces using RoleBindings (admin, edit, view)

To learn more about built-in Kubernetes RBAC roles, visit [Kubernetes RBAC user facing roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#user-facing-roles)

### User-facing roles

| Default ClusterRole | Default ClusterRoleBinding | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
|---------------------|----------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| cluster-admin       | system:masters group       | Allows super-user access to perform any action on any resource. When used in a **ClusterRoleBinding**, it gives full control over every resource in the cluster and in all namespaces. When used in a **RoleBinding**, it gives full control over every resource in the role binding's namespace, including the namespace itself.                                                                                                                                                                                                  |
| admin               | None                       | Allows admin access, intended to be granted within a namespace using a **RoleBinding**. If used in a **RoleBinding**, allows read/write access to most resources in a namespace, including the ability to create roles and role bindings within the namespace. This role doesn't allow write access to resource quota or to the namespace itself. This role also doesn't allow write access to Endpoints in clusters created using Kubernetes v1.22+. More information is available in the [Write Access for Endpoints](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#write-access-for-endpoints) section. |
| edit                | None                       | Allows read/write access to most objects in a namespace. This role doesn't allow viewing or modifying roles or role bindings. However, this role allows accessing Secrets and running Pods as any ServiceAccount in the namespace, so it can be used to gain the API access levels of any ServiceAccount in the namespace. This role also doesn't allow write access to Endpoints in clusters created using Kubernetes v1.22+. More information is available in the [Write Access for Endpoints](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#write-access-for-endpoints) section.                |
| view                | None                       | Allows read-only access to see most objects in a namespace. It doesn't allow viewing roles or role bindings. This role doesn't allow viewing Secrets, since reading the contents of Secrets enables access to ServiceAccount credentials in the namespace, which would allow API access as any ServiceAccount in the namespace (a form of privilege escalation).                                                                                                                                                         |

### Use a built-in Kubernetes RBAC role with Azure AD

1. Apply the built-in `view` Kubernetes RBAC role to your Azure AD group:

    ```bash
    kubectl create clusterrolebinding <name of your cluster role binding> --clusterrole=view --group=<Azure AD group object ID>
    ```

2. Apply the built-in `view` Kubernetes RBAC role to each of your Azure AD users:

    ```bash
    kubectl create clusterrolebinding <name of your cluster role binding> --clusterrole=view --user=<Azure AD user object ID>
    ```

## Work with cluster resources using Azure AD identities

Test the expected permissions when you create and manage resources in an AKS cluster. In these examples, you'll schedule and view pods in the user's assigned namespace. Then, you'll try to schedule and view pods outside of the assigned namespace.

1. Sign in to the Azure using the `$AKSDEV_ID` user account you passed as an input to the `az ad group member add` command. Run the `az connectedk8s proxy` command to open a channel to the AKS cluster:

    ```cli
    az connectedk8s proxy -n <cluster-name> -g <resource-group>
    ```

2. After the proxy channel has been established, open another session and schedule an NGINX pod using the [kubectl run](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#run) command in the **dev** namespace:

    ```bash  
    kubectl run nginx-dev --image=mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine --namespace dev
    ```

    When NGINX has been successfully scheduled, you see the following the output:
    
    ```output  
    pod/nginx-dev created
    ```

3. Now use the [kubectl get pods](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get) command to view pods in the *dev* namespace.

    ```bash  
    kubectl get pods --namespace dev
    ```

    When NGINX has been successfully **Running**, you see the following the output:

    ```output  
    $ kubectl get pods --namespace dev
    
    NAME        READY   STATUS    RESTARTS   AGE
    nginx-dev   1/1     Running   0          4m
    ```

### Create and view cluster resources outside of the assigned namespace

Attempt to view pods outside of the **dev** namespace. Use the [kubectl get pods](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get) command to with the `--all-namespaces` flag.

```bash  
kubectl get pods --all-namespaces
```

The user's group membership doesn't have a Kubernetes role that allows this action. Without the permission, the command will throw an error.

```output  
Error from server (Forbidden): pods is forbidden: User cannot list resource "pods" in API group "" at the cluster scope
```

## Next steps

Learn more about the security with AKS on Azure Stack HCI and Windows Server, see [Security in AKS on Azure Stack HCI and Windows Server](concepts-security.md)
