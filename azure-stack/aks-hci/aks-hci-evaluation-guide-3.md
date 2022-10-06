---
title: Explore the AKS on Azure Stack HCI environment
description: Step 3 of an overview of what's necessary to deploy AKS on Azure Stack HCI in an Azure Virtual Machine
author: sethmanheim
ms.topic: conceptual
ms.date: 08/29/2022
ms.author: sethm 
ms.lastreviewed: 08/29/2022
ms.reviewer: oadeniji
# Intent: As an IT Pro, I need to learn how to deploy AKS on Azure Stack HCI in an Azure Virtual Machine
# Keyword: Azure Virtual Machine deployment
---

# Step 3: Explore the AKS on Azure Stack HCI environment

With all key components deployed, including the management cluster, along with target clusters, you can now begin to explore some of the additional capabilities within AKS on Azure Stack HCI. This section describes some of the key elements, but for more information, see [the product documentation](/azure-stack/aks-hci/).

## Deploy a simple Linux application

To deploy a containerized application with your cluster up and running, the following steps describe key areas of deployment, testing, and scaling an application.

During the deployment of AKS on Azure Stack HCI, **kubectl** was configured on your Azure Virtual Machine Host. Kubectl provides a number of different ways to manage your Kubernetes clusters and applications.

As part of this guide, you'll deploy an [Azure vote application](https://github.com/Azure-Samples/azure-voting-app-redis). To deploy the application, you'll need a Kubernetes manifest file. A Kubernetes manifest file defines a desired state for the cluster, such as what container images to run. The manifest we'll use in this tutorial includes two Kubernetes deployments: one for the sample Azure Vote Python application, and the other for a Redis instance. Two Kubernetes services are also created: an internal service for the Redis instance, and an external service to access the Azure Vote application from the internet.

Before you start, make sure you [review the manifest file](https://github.com/Azure/aks-hci/blob/main/eval/yaml/azure-vote.yaml).

1. First, run the following command from an administrative PowerShell window to list your Kubernetes nodes

   ```powershell
   kubectl get nodes
   ```

   :::image type="content" source="media/aks-hci-evaluation-guide/get-nodes.png" alt-text="Output of kubectl get nodes":::

   > [!NOTE]
   > If you receive an error that "kubectl is not recognized as the name of a cmdlet, function, script file or operable program", you can either sign out of the Azure Virtual Machine, then sign back in, or run the following command from your PowerShell console: `choco install kubernetes-cli`, then close and re-open PowerShell.

   If you've followed the steps in this eval guide, your output should look similar, with 2 Linux worker nodes and 3 control plane nodes.

2. Next, from the same PowerShell console run the following command to deploy the application directly from GitHub:

   ```powershell
   kubectl apply -f https://raw.githubusercontent.com/Azure/aks-hci/main/eval/yaml/azure-vote.yaml
   ```

3. Next, run the following command to monitor the progress of the deployment (using the `--watch` parameter):

   ```powershell
   kubectl get service azure-vote-front --watch
   ```

   During deployment, you may see the **External-IP** showing as **Pending**. When this changes to an IP address, you can use **CTRL + C** to stop the watch process.

   In this case, you can see that the service has been allocated the **192.168.0.152** IP address.

4. Open Microsoft Edge and after accepting the defaults, you should be able to navigate to that IP address. Note that it may take a few minutes to start.

   :::image type="content" source="media/aks-hci-evaluation-guide/azure-vote-app.png" alt-text="Screenshot of Azure vote app in Edge":::

5. We have created a single replica of the Azure Vote front end and Redis instance. To see the number and state of pods in your cluster, use the **kubectl get** command as follows. The output should show one front end pod and one back-end pod:

   ```powershell
   kubectl get pods -n default
   ```

6. To change the number of pods in the azure-vote-front deployment, use the **kubectl scale** command. The following example increases the number of front end pods to 5:

   ```powershell
   kubectl scale --replicas=5 deployment/azure-vote-front
   ```

7. Run **kubectl get pods** again to verify that additional pods have been created. After a minute or so, the additional pods are available in your cluster:

   ```powershell
   kubectl get pods -n default
   ```

   You should now have 5 pods for this application.

## Expose a nested application to the internet

If you've followed all the steps in this guide, you'll have a running AKS-HCI infrastructure, including a target cluster that can run your containerized workloads. Additionally, if you've deployed the simple Linux application using the [previous section](#deploy-a-simple-linux-application), you'll now have an Azure Voting web application running in a container on your AKS-HCI infrastructure. This application will likely have been allocated an IP address from your internal NAT network, **192.168.0.0/16**, and opening your Edge browser within the Azure Virtual Machine allows you to access that web application using the 192.168.0.x IP address and optionally, its port number.

However, the Azure Voting web app and any other apps on the 192.168.0.0/16 internal network inside your Azure Virtual Machine cannot be reached from outside of the Azure Virtual Machine, unless you perform some additional configuration.

> [!NOTE]
> This is specific to the Azure Virtual Machine nested configuration, and would not be required in a production deployment on-premises.

### Add an inbound rule to your NSG

This example, using the [previously deployed simple Linux application](#deploy-a-simple-linux-application), exposes **port 80** to your Azure Virtual Machine internal NAT network, and then on to your Azure Voting app.

1. Visit the [Azure portal](https://portal.azure.com/), and sign in with the credentials you've been using for the evaluation.
2. Using the search box on the dashboard, enter "akshci" and when the results are returned, select your **AKSHCIHost** virtual machine.
3. On the overview blade for your VM, in the left-hand navigation select **Networking**.
4. The existing network security group rules are displayed. On the right-hand side, select **Add inbound port rule**.
5. In the **Add inbound security rule** blade, make any adjustments, including the **Protocol**, the **Destination port ranges**, and **Name**, then click **Add**.

   :::image type="content" source="media/aks-hci-evaluation-guide/new-security-rule.png" alt-text="Add inbound security rule in Azure":::

   > [!NOTE]
   > If you want to expose multiple ports, you can create additional rules, or specify a range of ports within the same rule. You can also be more specific about the source traffic type, source port, and destination traffic type.

6. With the network security group rule created, make a note of the NIC Public IP on the **Networking** blade. Then connect to your Azure Virtual Machine using your existing RDP information.

### Add a new NAT static mapping

With the network security group rule configured, there are some additional steps required to route the incoming traffic to the containerized application.

1. Inside the Azure Virtual Machine, in an administrative PowerShell console, you'll need to retrieve the external IP and port of your deployed application, by running the following command (in this case, the app front end name is "azure-vote-front"):

   ```powershell
   kubectl get service azure-vote-front
   ```

2. As you can see from the image, this particular app has been assigned the IP address **192.168.0.153** and is accessible on port **80**.
3. To create a new static NAT mapping, run the following PowerShell command:

   ```powershell
   Add-NetNatStaticMapping -NatName "AKSHCINAT" -Protocol TCP -ExternalIPAddress '0.0.0.0/24' -ExternalPort 80 `
       -InternalIPAddress '192.168.0.153' -InternalPort 80
   ```

4. The NAT static mapping should be successfully created, and you can now test the access of your application from outside of the Azure Virtual Machine. You should try to access the web application using the Azure Virtual Machine public IP address that you [noted previously](#add-an-inbound-rule-to-your-nsg).

This process creates a NAT static mapping that's specific to that external IP and the port of that specific Kubernetes service you have deployed in the environment. You must repeat the process for additional applications. For more information about PowerShell NetNat commands, [see the technical documentation](/powershell/module/netnat).

## Deploy hybrid end-to-end solutions on AKS-HCI

Now that you can interact with various aspects of AKS on Azure Stack HCI, it's a good time to build your knowledge by experimenting with more advanced hybrid solutions that run on AKS-HCI. These hybrid solutions use AKS on Azure Stack HCI capabilities in combination with other Azure Services to enable more complex hybrid use cases.

The following examples demonstrate how to quickly get started developing various hybrid solutions, using AKS on Azure Stack HCI and other Azure Services. Each sample solution is self-contained and may require extra Azure resources for its operations.

### AI Video Analytics at the Edge (Vision on Edge)

Vision on Edge (VoE) is an open-source end-to-end solution for AKS on Azure Stack HCI that simplifies the customer journey in creating and deploying vision-based AI analytics at the edge using a combination of various Azure services and open-source software. Vision on Edge takes advantage of:

* Azure Custom Vision
* Azure IoT Hub/Azure IoT Edge

To help you to:

* Go from zero to PoC by deploying our pre-built use-case scenarios such as defect detection and people counting in manufacturing and retail industries, respectively, on your own camera feeds
* Go from PoC to MVP by creating your very own custom AI model capable of detecting your desired objects from data gathered from your cameras easily through VoE UI
* Go from MVP to Production by deploying your custom AI solution/model, accelerated to 10+ cameras in parallel

   :::image type="content" source="media/aks-hci-evaluation-guide/voe-box.gif" alt-text="Screenshot of VOE box":::

#### Deployment steps

See [the instructions here](https://github.com/penorouzi/azure-intelligent-edge-patterns/blob/master/factory-ai-vision/Tutorial/K8s_helm_deploy.md) to install VoE on Kubernetes (AKS/AKS-HCI) using VoE Helm chart.

### Shutting down the environment

To save costs, you can shut down your AKS on Azure Stack HCI infrastructure, and the Hyper-V host. In order to do so, it's advisable to run the following commands, from the Hyper-V host, to cleanly power down the different components, before powering down the Azure Virtual Machine itself.

1. On your Hyper-V host, open **PowerShell as administrator** and run the following command:

   ```powershell
   # Power down VMs on your Hyper-V host
   Get-VM | Stop-VM -Force
   ```

2. Once all the VMs are switched off, you can then shut down your Hyper-V host. Visit the Azure portal, and sign in with your Azure credentials. Once logged in, using the search box on the dashboard, enter "akshci" and when the results are returned, select your **AKSHCIHost001** virtual machine.

3. On the overview blade for your VM, along the top navigation, select **Stop**, and then **OK**. Your VM is then deallocated and compute charges will cease.

You've reached the end of the evaluation guide. In this guide you have:

* Deployed/Configured a Windows Server 2019 or 2022 Hyper-V host in Azure to run your nested sandbox environment
* Deployed the AKS on Azure Stack HCI management cluster on your Windows Server Hyper-V environment
* Deployed a target cluster to run applications and services
* Optionally integrated with Azure Arc
* Set the foundation for further learning!

## Product improvements

If, while you work through this guide, you have an idea to make the product better, whether it's something in AKS on Azure Stack HCI, Windows Admin Center, or the Azure Arc integration and experience, let us know! We want to hear from you! [Head on over to our AKS on Azure Stack HCI GitHub page](https://github.com/Azure/aks-hci/issues "AKS on Azure Stack HCI GitHub"), where you can share your thoughts and ideas about making the technologies better.  If however, you have an issue that you'd like some help with, read on... 

## Raising issues

If you notice something is wrong with the evaluation guide, such as a step isn't working, or something just doesn't make sense - help us to make this guide better!  Raise an issue in GitHub, and we'll be sure to fix this as quickly as possible!

If however, you're having a problem with AKS on Azure Stack HCI outside of this evaluation guide, make sure you post to [our GitHub Issues page](https://github.com/Azure/aks-hci/issues "GitHub Issues"), where Microsoft experts and valuable members of the community will do their best to help you.

## Next steps

In addition to the scenarios covered, there are a number of other useful tutorials that you can follow to help grow your knowledge around Kubernetes, including tutorials that cover using GitOps, and Azure Policy.

* [Deploy configurations using GitOps on Azure Arc enabled Kubernetes cluster](/azure/azure-arc/kubernetes/tutorial-use-gitops-connected-cluster")
* [Use Azure Policy to apply cluster configurations at scale](/azure/azure-arc/kubernetes/use-azure-policy)
* [Enable monitoring of Azure Arc enabled Kubernetes cluster](/azure/azure-monitor/insights/container-insights-enable-arc-enabled-clusters)

In addition to these resources, it's certainly worth exploring additional scenarios around Azure Arc, on the [Azure Arc jumpstart website](https://azurearcjumpstart.io). Here, you can explore scenarios around [Azure Arc enabled Kubernetes](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_k8s/), and [Azure Arc enabled data services](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_data/).
