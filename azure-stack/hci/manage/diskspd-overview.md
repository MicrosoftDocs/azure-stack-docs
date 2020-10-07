---
title: Use DISKSPD to test workload storage performance
description: This topic provides guidance on how to use DISKSPD to test workload storage performance.
author: jasonnyi
ms.author: jasonyi
ms.topic: how-to
ms.date: 10/07/2020
---

# Use DISKSPD to test workload storage performance

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

This topic provides guidance on how to use DISKSPD to test workload storage performance. You now have an Azure Stack HCI Cluster set up - all ready to go. Great, but how do you know if you are getting the promised performance metrics, whether it be latency, throughput, or IOPS? This is where you may wish turn to DISKSPD. After reading the article, we will have learned how to run DISKSPD, understand a subset of the parameters, interpret the output, and gain a general understanding of the variables that affect performance.

## What is DISKSPD?
At its core, DISKSPD is an I/O generating, command-line tool for micro-benchmarking. Great, so what do all these terms mean? Anyone who sets up an Azure Cluster, physical server, etc. has a reason. It could be that they wish to set up a web hosting environment, run virtual desktops for the employees, etc. Whatever the real-world use case may be, you likely want to simulate a test before deploying your actual application. However, testing your application in a real scenario is often difficult – this is where DISKSPD comes in. DISKSPD is a tool to customize and create your own synthetic workloads and test your application before deployment. The cool thing about the tool is that it gives the user the freedom to configure and tweak the parameters to create a specific scenario that resembles user’s real workload. By doing so, you can get a glimpse into what your system is capable of before deployment. At its core, DISKSPD simply issues a bunch of read and write operations.

Now we know what DISKSPD is, but when should we use it? DISKSPD will have a difficult time emulating complex workloads. As a result, DISKSPD is great when your workload is not closely approximated by single-threaded file copy but you need a simple tool that produces acceptable baseline results.

## Quick startup guide: from installation to running DISKSPD
Without further ado, let’s get started.

1. The first thing you need to do is log into the virtual machine that you will use for the DISKSPD test, with administrator rights. In our case, we will be running on the VM called, “node1.”
1. Once logged in, you can download the tool from the [repository](https://github.com/microsoft/diskspd). This link contains the open source code as well as a wiki page that details all the parameters and specifications. The only file we really care about is the executable that can be downloaded as a ZIP file. Within it, you will see 3 subfolders: amd64 (64-bit systems), x86 (32-bit systems), and ARM64 (ARM systems). This will help you run the tool in every Windows version, client, or server. We will be using the amd64 version.

    :::image type="content" source="media/diskspd/download-directory.png" alt-text="Directory to download the DISKSPD .zip file." lightbox="media/diskspd/download-directory.png":::

1.	Open PowerShell as an administrator.
<!---see Dan PW topic for example format for these steps.--->

1.	Go to where your DISKSPD file is located.

1.	Run DISKSPD with a single line command. The command line format is listed below. Simply replace everything inside the square brackets, including the brackets themselves with your appropriate settings.
    - .\[INSERT_DISKSPD_PATH] [INSERT_SET_OF_PARAMETERS]  [INSERT_CSV_PATH_FOR_TEST_FILE] > [INSERT_OUTPUT_FILE.txt]
    
    Here is an example command you can run:
    - .\diskspd -t2 -o32 -b4k -r4k -w0 -d120 -Sh -D -L -c5G C:\ClusterStorage\test01\targetfile\IO.dat > test04.txt

## Choosing key parameters
Well, that was simple right? Unfortunately, there is more to it than that - let’s unpack what we did. First, there are various parameters that you can tinker with and it can get pretty specific. However, today we used the following set of baseline parameters.

> [!NOTE]
> DISKSPD parameters are case sensitive.

**-t2** => This indicates the number of threads per target/test file. This number is often based on the number of CPU cores. In our case, we used 2 to stress all our CPU processors.

**-o32** => This indicates the number of outstanding I/O requests per target per thread. This is also known as the queue depth, and in our case, we used 32 to stress the CPU.

**-b4K** => This indicates the block size in bytes, KiB, MiB, or GiB. In our case, we used 4K block size to simulate a random I/O test.

**-r4K** => This indicates the random I/O aligned to the specified size in bytes, KiB, MiB, Gib, or blocks (Overrides the -s parameter). We used the common 4K byte size to properly align with our block size.

**-w0** => This specifies the percentage of operations that are write requests (-w0 is equivalent to 100% read). We used 0% writes for the purpose of a simple test.

**-d120** => This specifies the duration of the test, not including cool-down or warm-up. The default value is 10 seconds, but it is recommended that you use at least 60 seconds for any serious workload. We used 120 seconds in order to minimize any outliers. 

**-Suw** => Disables software and hardware write caching (equivalent to -Sh)

**-D** => Captures IOPS statistics such as standard deviation, in intervals of milliseconds (per-thread, per-target)

**-L** => Measures latency statistics

**-c** => Sets the sample file size that will be used in the test. Can be set in bytes, KiB, MiB, GiB, or blocks. We used a 5GB target file. 

For a complete list of parameters, refer to the [Github repository](https://github.com/Microsoft/diskspd/wiki/Command-line-and-parameters).

## Understanding the environment
The performance heavily depends on your environment. So, what is our environment? Our specification involves an Azure cluster with storage pool and Storage Spaces Direct (S2D). More specifically, we have a total of 5 virtual machines: DC, node1, node2, node3, and the mgmt node. The cluster itself is a three-node cluster with a three-way mirrored resiliency structure. Therefore, three data copies will be maintained. Each “node” in the cluster is a Standard_B2ms VM with a maximum IOPS limit of 1920. Within each node, there are four premium P30 SSD drives with a maximum IOPS limit of 5000. Finally, each SSD drive has 1 TB of memory.

We generate the test file under the unified namespace that the Cluster Shared Volume (CSV) provides (C:\ClusteredStorage) in order to utilize the entire pool of drives.

>[!NOTE]
> The current environment does *not* have Hyper-V or a nested virtualization structure.

As you’ll see, it is entirely possible to independently hit either the IOPS or bandwidth ceiling at the VM or disk limit. And so, it is important to understand your VM size and drive type as both have a maximum IOPS limit and a bandwidth ceiling. Having this knowledge will help you locate bottlenecks and understand your performance results. You can refer to the two links below to discover what size may be appropriate for your workload.

- [VM sizes](https://docs.microsoft.com/azure/virtual-machines/sizes-general?toc=/azure/virtual-machines/linux/toc.json&bc=/azure/virtual-machines/linux/breadcrumb/toc.json)
- [Disk types](https://azure.microsoft.com/pricing/details/managed-disks/)

Here is what our environment looks like. The green represents the IOPS limit on the VM and the red represents the IOPS limit on the hard drive.

:::image type="content" source="media/diskspd/environment.png" alt-text="The DISKSPD environment." lightbox="media/diskspd/environment.png":::

## Understanding the output
Armed with our understanding of the parameters and environment, let’s interpret the output. First, the goal of our test was to max out the IOPS with no regards to latency. This way, we can visually see whether we reach our artificial IOPS limit within Azure. If you wish to graphically visualize the total IOPS, you can refer to the Windows Admin Center or the task manager.

Here, we have a diagram of what the DISKSPD process looks like. It depicts an example of a 1MiB write operation from a non-coordinator node. The three-way resiliency structure along with the operation from a non-coordinator node leads to two network hops, decreasing the performance. If you are wondering what a coordinator is, don’t worry! We will talk about this in a later section.
<!---set up section ref to Things to consider section.--->

:::image type="content" source="media/diskspd/example-process.png" alt-text="Example diagram of the DISKSPD process that shows a 1MiB write operation from a non-coordinator node." lightbox="media/diskspd/example-process.png":::

Now that we have a visual understanding, let’s examine the four main sections of our txt file output.
1.	Input settings
   
       This section describes the command you ran, the input parameters, and additional details about the test run.

       :::image type="content" source="media/diskspd/command-input-parameters.png" alt-text="Example output shows command and input parameters." lightbox="media/diskspd/command-input-parameters.png":::

1.	CPU utilization details
   
       This section highlights information such as the test time, number of threads, number of available processors, and average utilization of every CPU core during the test. For example, in this case, we see our 2 CPU cores averaged around 4.67% usage.

       :::image type="content" source="media/diskspd/cpu-details.png" alt-text="Example CPU details." lightbox="media/diskspd/cpu-details.png":::

1.	Total I/O
   
       This section has three subsections. The first section highlights the overall performance data including both read and write operations. The second and third sections split the read and write operations into separate categories.

       In this example, we can see that the total I/O count was 234408 during the 120 seconds duration. Thus, IOPS = 234408 /120 = 1953.30. The average latency was 32.763 milliseconds, and the throughput was 7.63 MiB/s. From earlier, we know that the 1953.30 IOPS is near the 1920 IOPS limitation for our Standard_B2ms VM. Don’t believe it? If you were to re-run this test using different parameters such as increasing the queue depth, you will find that we are still capped at this number.

       In the last three columns, we see the standard deviation of IOPS at 17.72 (from -D parameter), the standard deviation of the latency at 20.994 milliseconds (from -L parameter), and the file path.

       :::image type="content" source="media/diskspd/total-io.png" alt-text="Example shows total overall I/O performance data." lightbox="media/diskspd/total-io.png":::

       From the results, you will quickly realize that our cluster configuration is actually terrible. If you examine our cluster below, you can see that we hit the VM limitation of 1920 before the SSD limitation of 5000. Furthermore, if you use a big enough test file, you will be able to take advantage of up to 20000 IOPS (4 drives * 5000) by spanning the test file across multiple drives. However, we because we hit that virtual machine limit first, we only see a total IOPS of around 1920.

       In the end, you will need to decide what values are acceptable for your specific workload. Here are some important relationships to help you consider the tradeoffs: 

       :::image type="content" source="media/diskspd/tradeoffs.png" alt-text="Figure shows workload relationships to help you consider tradeoffs." lightbox="media/diskspd/tradeoffs.png":::

       The second relationship is important, and sometimes referred to as Little’s Law. The law introduces the idea that there are three characteristics that govern process behavior and that you only need to change one to influence the other two, thus the entire process. And so, if you are unhappy with your system’s performance, you have three dimensions of freedom. In our case, IOPS is the throughput (Input output operations per second), latency is the queue time, and queue depth is the inventory.

1.	Latency percentile analysis
   
       This last section details the percentile latencies per operation type of storage performance from the minimum value to the maximum value.

       This section is important as it determines the “quality” of your IOPS. It reveals how many of the I/O operations were able to achieve a certain latency value. It is up to the user to decide the acceptable latency for that percentile. Moreover, the “nines” refer to the number of nines. For example, “3-nines” is equivalent to the 99th percentile. The number of nines will expose how many I/O operations were ran at that percentile. Eventually, you will reach a point where it no longer makes sense to take the latency values seriously. In our case, we can see that the latency values remain constant after “4-nines.” At this point, the latency value is based on only one I/O operation out of the ~230K.

       :::image type="content" source="media/diskspd/storage-performance.png" alt-text="Example shows percentile latencies per operation type of storage performance." lightbox="media/diskspd/storage-performance.png":::

## Batch test + extracting results into Excel
Great, now you know how to run DISKSPD and output the results into a text file. However, at the current rate, you will need to run a new command for every parameter change. Luckily, with the two scripts below, you will be able to collect your output metrics into an excel sheet to analyze. Here are the following steps:

1.	Download the following two scripts: “Batch-DiskSpd” and “Process-DiskSpd”
1.	The first script you will need to run is “Batch-DiskSpd”
    The parameters are as follows:
    - **$param** => A mandatory string parameter. You will need to specify the parameter you wish to vary.

        | Parameter to vary | String command  |
        | :---------------- | :-------------- |
        | Only Thread       | “t”             |
        | Only Queue        | “o”             |
        | Only Block        | “b”             |
        | Thread + Queue    | “to”            |
        | Thread + Block    | “tb”            |
        | Queue + Block     | “ob”            |
    
    - **$rw** => A mandatory int parameter. Specify what percentage of write you wish to test.
    - **$duration** => An optional int parameter. Specify the duration in seconds. Default is 120.
    - **$f_size** => An optional string parameter. Specify the test file size. Default is ‘1G’.
    - **$type** => An optional string parameter. If you wish to output into a text file, run “-Rtxt”. If you wish to collect the data, run “-Rxml”. The default is “Rxml”.
    - **$path** => An optional string parameter. Specify the directory where you will create your test file. The default is the current directory.

1.	At this point, you will have multiple xml output files. The next step is to run the “Process-DiskSpd” script. If your xml files are in the same directory as the current script, you can simply run it without any parameters. However, if the output files are in another directory, you will need to specify the path while running the script. Your output will be a tsv file.

1.	You should now have a tsv file that you can open within Excel. Here is an example output from varying only the thread values. If you wish to test your own thread values, you can change the values at the beginning of the Batch-DiskSpd script. Have fun!

    :::image type="content" source="media/diskspd/thread-value-output.png" alt-text="Example shows thread value output." lightbox="media/diskspd/thread-value-output.png":::

## Things to consider...
<!---High-level intro needed--->

### DISKSPD vs. real-world
DISKSPD’s artificial test gives you relatively comparable results for your real workload. However, you need to pay close attention to the parameters you set and whether they match your real scenario. Synthetic workloads will never perfectly represent your application’s real workload during deployment (Ex. does the application require a lot of “think” time or does it continuously pound away with I/O operations).

### Preparations
Before running a DISKSPD test, there are a couple recommended actions for you to perform. These include things such as verifying the health of the storage space, checking your resource usage so that another program does not interfere with the test, preparing performance manager if you wish to collect additional data, etc. However, because the goal of this article is to quickly get DISKSPD running, we will not dive into the specifics of these actions. To learn more, see [Test Storage Spaces Performance Using Synthetic Workloads in Windows Server](https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn894707(v=ws.11)).

### Variables that affect performance
Storage performance is a very delicate thing. Meaning, that there are many variables that can affect performance. And so, it is highly likely you may encounter a number that is inconsistent with your expectations. The list below highlights some of the variables that affect performance (this is not a comprehensive list).
- Network Bandwidth
- Resiliency Choice
- Storage Disk Configuration: NVME, SSD, HDD
- I/O buffer
- Cache
- RAID configuration
- Network hops
- Hard drive Spindle Speeds
- Etc.

### CSV ownership
A node is known as a volume owner or the **coordinator** node. Every standard volume is assigned a node and the other nodes can access this standard volume through network hops, which will result in slower performance (higher latency). 
Similarly, a Cluster Shared Volume will also have an “owner.” However, CSV is “dynamic” in the sense that it will hop around and change ownership every time you restart the system (RDP). As a result, it’s important you confirm that DISKSPD is ran from the coordinator node that owns the CSV. If not, you may need to manually change the CSV ownership. 
This can be done as follows:
1. Check ownership by running: Get-ClusterSharedVolume
1. If the ownership is incorrect (Ex. You are on Node1 but Node2 owns the CSV), then move the CSV to the correct node by running:
    Get-ClusterSharedVolume <INSERT_CSV_NAME> | Move-ClusterSharedVolume <INSERT _NODE_NAME>

### File Copy vs. DISKSPD
Some people believe that they can “test storage performance” by simply copying and pasting a gigantic file and measuring how long it takes. The main reason behind this approach is most likely because it is simple and fast. They are not wrong in the sense that they are testing a specific workload, but it is difficult to categorize that as “testing storage performance.”

If your real-world goal has to do with file copy performance, then this may be a perfectly valid reason to go ahead and test file copy performance. However, if your goal is to measure storage performance, it’s recommended that you do not use this method. You can think of file copy as using a different set of “parameters” (such as queue, parallelization, etc.) specific to file services.

Here is a short summary of why using file copy to measure storage performance may not be something you are looking for:
- “File copies may not be optimized.” There are two levels of parallelism that occurs, one internal and the other external. Internally, if the file copy is headed for a remote target, the CopyFileEx engine does apply some parallelization. Externally, there are different ways of invoking the CopyFileEx engine. For example, copies from file explorer is single threaded whereas Robocopy is multi-threaded.
- “Every copy has two sides.” When you simply copy and paste a file, you may be using two disks: the source and destination. If one is slower than the other, you essentially measure the performance of the slower disk. There are other cases where the communication between the source, destination, and the copy engine may affect the performance in unique ways.
    
    To learn more, see [Using file copy to measure storage performance](https://docs.microsoft.com/archive/blogs/josebda/using-file-copy-to-measure-storage-performance-why-its-not-a-good-idea-and-what-you-should-do-instead?ranMID=24542&ranEAID=je6NUbpObpQ&ranSiteID=je6NUbpObpQ-OaAFQvelcuupBvT5Qlis7Q&epi=je6NUbpObpQ-OaAFQvelcuupBvT5Qlis7Q&irgwc=1&OCID=AID2000142_aff_7593_1243925&tduid=%28ir__rcvu3tufjwkftzjukk0sohzizm2xiezdpnxvqy9i00%29%287593%29%281243925%29%28je6NUbpObpQ-OaAFQvelcuupBvT5Qlis7Q%29%28%29&irclickid=_rcvu3tufjwkftzjukk0sohzizm2xiezdpnxvqy9i00).

## Other common examples + experiments
TBD

### Online Transaction Processing (OLTP) workload
TBD

### Online Analytical Processing (OLAP) workload
TBD


## Next steps
For more information, see also:
<!---Placeholders for format examples. Replace all before initial topic review.--->

- [Azure Stack HCI overview](../overview.md)
- [Storage Spaces Direct hardware requirements](/windows-server/storage/storage-spaces/storage-spaces-direct-hardware-requirements)
