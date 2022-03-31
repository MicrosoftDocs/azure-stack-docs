---
title: Deploy applications with Helm on Azure Kubernetes Service on Azure Stack HCI
description: Learn how to use Helm to deploy applications on Azure Kubernetes Service on Azure Stack HCI
author: mattbriggs
ms.topic: how-to
ms.date: 04/13/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: rbaziwane
#intent: As an IT Pro, I want to learn how to deploy applications with Helm on AKS
#keyword: Helm chart Helm deployment

---

# Deploy applications with Helm on Azure Kubernetes Service on Azure Stack HCI

[Helm](https://helm.sh/) is an open-source packaging tool that helps you install and manage the lifecycle of Kubernetes applications. Similar to Linux package managers, such as *APT* and *Yum*, Helm manages Kubernetes charts, which are packages of pre-configured Kubernetes resources.

In this topic, you'll learn how to use Helm to package and deploy an application on AKS on Azure Stack HCI. 

## Before you begin
Verify that you have the following requirements set up:

* An [AKS on Azure Stack HCI cluster](./setup.md) with at least one Windows or Linux worker node that's up and running.
* You have configured your local `kubectl` environment to point to your AKS on Azure Stack HCI cluster. You can use the [Get-AksHciCredential](./reference/ps/get-akshcicredential.md) PowerShell command to access your cluster using `kubectl`.
* [Helm v3](https://helm.sh/docs/intro/install/) command line and prerequisites installed.
* An available container registry, such as [DockerHub](https://hub.docker.com/) or [Azure Container Registry](https://azure.microsoft.com/services/container-registry/).

In this topic, an ASP.NET Core application is used as an example. You can download the sample application from this [GitHub repository](https://github.com/baziwane/MyMicroservice).

Since the application is deployed to Kubernetes, the following is a simple Dockerfile for the project:

```Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build
WORKDIR /src
COPY ["MyMicroservice.csproj", "./"]
RUN dotnet restore "MyMicroservice.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "MyMicroservice.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MyMicroservice.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyMicroservice.dll"]
```

## Build and push the sample application to a container registry
Navigate to the application folder and use the Dockerfile to build and push an image using the following command:

```Console
docker build -f Dockerfile -t acr.azurecr.io/mymicroservice:0.1.0 .
```

> [!NOTE]
> The period (.) at the end of the command sets the location of the Dockerfile (in this case, the current directory). 

This will create the image `mymicroservice:0.1.0` on the local machine. To verify that the image was successfully created, run `docker images` to confirm.

```output
REPOSITORY              TAG     IMAGE ID       CREATED            SIZE  
acr.azurecr.io/mymicroservice 0.1.0   5be713db571b   About a minute ago 107MB
....
```

Next, you need to push your image up to a container registry, such as [DockerHub](https://hub.docker.com/) or [Azure Container Registry](https://azure.microsoft.com/services/container-registry/). In this example, the container image is pushed to Azure Container Registry (ACR). To learn more, see [Pull images from an ACR to a Kubernetes cluster](/azure/container-registry/container-registry-auth-kubernetes).

```
docker push acr.azurecr.io/mymicroservice:0.1.0
```

## Create your Helm chart
Now that you have the sample application ready, the next step is to generate a Helm chart using the `helm create` command as shown below:

```Console
helm create mymicroserviceapp
```
Update *mymicroserviceapp/values.yaml* as follows:

- Change `image.repository` to `acr.azurecr.io/mymicroservice`
- Change `service.type` to `NodePort`

For example: 
```yml
# Default values for webfrontend.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 1

image:
  repository: acr.azurecr.io/mymicroservice
  pullPolicy: IfNotPresent
...
service:
  type: NodePort
  port: 80
...
```

Navigate to the *mymicroserviceapp/templates/deployment.yaml* file to configure health checks. Kubernetes uses health checks to manage your application deployments. Replace the path of both `liveness` and `readiness` probes to `path: /weatherforecast` as shown in the example below:
```yml
...
 livenessProbe:
    httpGet:
      path: /weatherforecast
      port: http
    initialDelaySeconds: 0
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 3
 readinessProbe:
    httpGet:
      path: /weatherforecast
      port: http
    successThreshold: 3
...
```

## Deploy your Helm chart to Kubernetes

Starting from the *charts\mymicroserviceapp* directory in the solution directory, run the following command:

```yml
helm upgrade --install mymicroserviceapp . --namespace=local --set mymicroserviceapp.image.tag="0.1.0" 
```
This command creates (or upgrades) an existing release using the name _mymicroserviceapp_ in the `local` namespace in the Kubernetes cluster and should produce an output similar to this:

```output
Release "mymicroserviceapp" does not exist. Installing it now.
NAME: mymicroserviceapp
LAST DEPLOYED: Fri Apr  2 08:47:24 2021
NAMESPACE: local
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export NODE_PORT=$(kubectl get --namespace local -o jsonpath="{.spec.ports[0].nodePort}" services mymicroserviceapp)
  export NODE_IP=$(kubectl get nodes --namespace local -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
```
After deploying the Helm chart, you can check that the resources were correctly deployed by running `kubectl get all -n local`. 

The output from running the command is shown below:

```output
NAME                                     READY   STATUS    RESTARTS   AGE
pod/mymicroserviceapp-7849f949df-fwgbn   1/1     Running   0          101s

NAME                        TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
service/mymicroserviceapp   NodePort   10.100.149.1   <none>        80:30501/TCP   101s

NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mymicroserviceapp   1/1     1            1           101s

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/mymicroserviceapp-7849f949df   1         1         1       101s
```

## Test your deployment
The application deploys with a service and a node port, so you can call the API from outside the cluster. To do this, send a request to: http://$NODE_IP:$NODE_PORT:

```console
curl http://10.193.2.103:30501/WeatherForeCast/
```

```output
StatusCode        : 200
StatusDescription : OK
Content           : [{"date":"2021-04-03T15:51:04.795216+00:00","temperatureC":45,"temperatureF":112,"summary":"Balmy"},{"date":"2021-04-04T15:51:04.
                    7952176+00:00","temperatureC":23,"temperatureF":73,"summary":"Cool"},{"...
RawContent        : HTTP/1.1 200 OK
                    Transfer-Encoding: chunked
                    Content-Type: application/json; charset=utf-8
                    Date: Fri, 02 Apr 2021 15:51:04 GMT
                    Server: Kestrel

                    [{"date":"2021-04-03T15:51:04.795216+00:00","tempera...
Forms             : {}
Headers           : {[Transfer-Encoding, chunked], [Content-Type, application/json; charset=utf-8], [Date, Fri, 02 Apr 2021 15:51:04 GMT], [Server,
                    Kestrel]}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 494

```

## Clean up the cluster
The final step is to clean up the cluster. To delete Kubernetes deployment resources, run the following command: 

```console
helm uninstall mymicroserviceapp -n local
```

You should get an output similar to the following:

```output
release "mymicroserviceapp" uninstalled
```
## Next steps
- [Connect your clusters to Azure Arc for Kubernetes](./connect-to-arc.md).