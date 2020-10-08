---
title: Use DISKSPD to test workload storage performance
description: This topic provides guidance on how to use DISKSPD to test workload storage performance.
author: jasonnyi
ms.author: jasonyi
ms.topic: how-to
ms.date: 10/08/2020
---

# Use DISKSPD to test workload storage performance

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

This topic provides guidance on how to use DISKSPD to test workload storage performance. You have an Azure Stack HCI Cluster set up, all ready to go. Great, but how do you know if you're getting the promised performance metrics, whether it be latency, throughput, or IOPS? This is when you may wish turn to DISKSPD. After reading this topic, you'll know how to run DISKSPD, understand a subset of parameters, interpret output, and gain a general understanding of the variables that affect workload storage performance.

## What is DISKSPD?
At its core, DISKSPD is an I/O generating, command-line tool for micro-benchmarking. Great, so what do all these terms mean? Anyone who sets up an Azure Cluster or physical server has a reason. It could be to set up a web hosting environment, or run virtual desktops for employees. Whatever the real-world use case may be, you likely want to simulate a test before deploying your actual application. However, testing your application in a real scenario is often difficult – this is where DISKSPD comes in.

DISKSPD is a tool that you can customize to create your own synthetic workloads, and test your application before deployment. The cool thing about the tool is that it gives you the freedom to configure and tweak the parameters to create a specific scenario that resembles the user’s real workload. DISKSPD can give you a glimpse into what your system is capable of before deployment. At its core, DISKSPD simply issues a bunch of read and write operations.

Now you know what DISKSPD is, but when should you use it? DISKSPD has a difficult time emulating complex workloads. But DISKSPD is great when your workload is not closely approximated by a single-threaded file copy, and you need a simple tool that produces acceptable baseline results.

## Quick start guide: from installation to running DISKSPD
Without further ado, let’s get started:

1. The first thing to do is log on to the virtual machine (VM) as an administrator that you'll use for the DISKSPD test. In our case, we're running a VM called “node1.”
1. After logging on, download the tool from the [repository](https://github.com/microsoft/diskspd). This link contains the open source code, as well as a wiki page that details all the parameters and specifications.

    The only file that you really need is the executable that you can download as a ZIP file. Within it, you'll see 3 subfolders: amd64 (64-bit systems), x86 (32-bit systems), and ARM64 (ARM systems). This will help you run the tool in every Windows client or server version. In this example, we're using the amd64 version.

    :::image type="content" source="media/diskspd/download-directory.png" alt-text="Directory to download the DISKSPD .zip file." lightbox="media/diskspd/download-directory.png":::

1.	Open PowerShell as an administrator, and then go to where your DISKSPD file is located.

1.	Run DISKSPD with a single line command, using the following command-line format. Simply replace everything inside the square brackets, including the brackets themselves with your appropriate settings.

    ```powershell
     .\[INSERT_DISKSPD_PATH] [INSERT_SET_OF_PARAMETERS]  [INSERT_CSV_PATH_FOR_TEST_FILE] > [INSERT_OUTPUT_FILE.txt]
    ```
    
    Here is an example command that you can run:

    ```powershell
     .\diskspd -t2 -o32 -b4k -r4k -w0 -d120 -Sh -D -L -c5G C:\ClusterStorage\test01\targetfile\IO.dat > test04.txt
    ```
## Choosing key parameters
Well, that was simple right? Unfortunately, there is more to it than that. Let’s unpack what we did. First, there are various parameters that you can tinker with and it can get pretty specific. However, we used the following set of baseline parameters:

> [!NOTE]
> DISKSPD parameters are case sensitive.

**-t2** => This indicates the number of threads per target/test file. This number is often based on the number of CPU cores. In this case, 2 threads were used to stress all of the CPU processors.

**-o32** => This indicates the number of outstanding I/O requests per target per thread. This is also known as the queue depth, and in this case, 32 were used to stress the CPU.

**-b4K** => This indicates the block size in bytes, KiB, MiB, or GiB. In this case, 4K block size was used to simulate a random I/O test.

**-r4K** => This indicates the random I/O aligned to the specified size in bytes, KiB, MiB, Gib, or blocks (Overrides the **-s** parameter). The common 4K byte size was used to properly align with the block size.

**-w0** => This specifies the percentage of operations that are write requests (-w0 is equivalent to 100% read). In this case, 0% writes were used for the purpose of a simple test.

**-d120** => This specifies the duration of the test, not including cool-down or warm-up. The default value is 10 seconds, but we recommend using at least 60 seconds for any serious workload. In this case, 120 seconds were used to minimize any outliers.

**-Suw** => Disables software and hardware write caching (equivalent to **-Sh**).

**-D** => Captures IOPS statistics, such as standard deviation, in intervals of milliseconds (per-thread, per-target).

**-L** => Measures latency statistics.

**-c** => Sets the sample file size used in the test. It can be set in bytes, KiB, MiB, GiB, or blocks. In this case, a 5 GB target file was used.

For a complete list of parameters, refer to the [Github repository](https://github.com/Microsoft/diskspd/wiki/Command-line-and-parameters).

## Understanding the environment
Performance heavily depends on your environment. So, what is our environment? Our specification involves an Azure Cluster with storage pool and Storage Spaces Direct (S2D). More specifically, there are 5 VMs: DC, node1, node2, node3, and the management node. The cluster itself is a three-node cluster with a three-way mirrored resiliency structure. Therefore, three data copies are maintained. Each “node” in the cluster is a Standard_B2ms VM with a maximum IOPS limit of 1920. Within each node, there are four premium P30 SSD drives with a maximum IOPS limit of 5000. Finally, each SSD drive has 1 TB of memory.

You generate the test file under the unified namespace that the Cluster Shared Volume (CSV) provides (C:\ClusteredStorage) to use the entire pool of drives.

>[!NOTE]
> The current environment does *not* have Hyper-V or a nested virtualization structure.

As you’ll see, it is entirely possible to independently hit either the IOPS or bandwidth ceiling at the VM or disk limit. And so, it is important to understand your VM size and drive type, because both have a maximum IOPS limit and a bandwidth ceiling. This knowledge helps to locate bottlenecks and understand your performance results. To learn more about what size may be appropriate for your workload, see the following resources:

- [VM sizes](https://docs.microsoft.com/azure/virtual-machines/sizes-general?toc=/azure/virtual-machines/linux/toc.json&bc=/azure/virtual-machines/linux/breadcrumb/toc.json)
- [Disk types](https://azure.microsoft.com/pricing/details/managed-disks/)

The following figure shows what our environment looks like. The green represents the IOPS limit on the VMs and the red represents the IOPS limit on the hard drives.

:::image type="content" source="media/diskspd/environment.png" alt-text="The sample environment used to test performance with DISKSPD." lightbox="media/diskspd/environment.png":::

## Understanding the output
Armed with your understanding of the parameters and environment, you're ready to interpret the output. First, the goal of the test is to max out the IOPS with no regard to latency. This way, you can visually see whether you reach the artificial IOPS limit within Azure. If you want to graphically visualize the total IOPS, use either Windows Admin Center or Task Manager.

The following diagram shows what the DISKSPD process looks like. It depicts an example of a 1 MiB write operation from a non-coordinator node. The three-way resiliency structure, along with the operation from a non-coordinator node, leads to two network hops, decreasing performance. If you're wondering what a coordinator node is, don’t worry! You'll learn about it in the [Things to consider](#things-to-consider) section.

:::image type="content" source="media/diskspd/example-process.png" alt-text="Example diagram of the DISKSPD process that shows a 1 MiB write operation from a non-coordinator node." lightbox="media/diskspd/example-process.png":::

Now that you've got a visual understanding, let’s examine the four main sections of the .txt file output:
1.	Input settings
   
       This section describes the command you ran, the input parameters, and additional details about the test run.

       :::image type="content" source="media/diskspd/command-input-parameters.png" alt-text="Example output shows command and input parameters." lightbox="media/diskspd/command-input-parameters.png":::

1.	CPU utilization details
   
       This section highlights information such as the test time, number of threads, number of available processors, and the average utilization of every CPU core during the test. In this case, there are 2 CPU cores that averaged around 4.67% usage.

       :::image type="content" source="media/diskspd/cpu-details.png" alt-text="Example CPU details." lightbox="media/diskspd/cpu-details.png":::

1.	Total I/O
   
       This section has three subsections. The first section highlights the overall performance data including both read and write operations. The second and third sections split the read and write operations into separate categories.

       In this example, you can see that the total I/O count was 234408 during the 120 seconds duration. Thus, IOPS = 234408 /120 = 1953.30. The average latency was 32.763 milliseconds, and the throughput was 7.63 MiB/s. From earlier information, we know that the 1953.30 IOPS is near the 1920 IOPS limitation for our Standard_B2ms VM. Don’t believe it? If you rerun this test using different parameters, such as increasing the queue depth, you'll find that the results are still capped at this number.

       The last three columns show the standard deviation of IOPS at 17.72 (from -D parameter), the standard deviation of the latency at 20.994 milliseconds (from -L parameter), and the file path.

       :::image type="content" source="media/diskspd/total-io.png" alt-text="Example shows total overall I/O performance data." lightbox="media/diskspd/total-io.png":::

       From the results, you can quickly determine that the cluster configuration is actually terrible.  You can see that it hit the VM limitation of 1920 before the SSD limitation of 5000. Furthermore, if you use a big enough test file, you can take advantage of up to 20000 IOPS (4 drives * 5000) by spanning the test file across multiple drives. However, because it hit that VM limit first, you only see a total IOPS of around 1920.

       In the end, you need to decide what values are acceptable for your specific workload. The following figure shows some important relationships to help you consider the tradeoffs:

       :::image type="content" source="media/diskspd/tradeoffs.png" alt-text="Figure shows workload relationship tradeoffs." lightbox="media/diskspd/tradeoffs.png":::

       The second relationship in the figure is important, and it is sometimes referred to as Little’s Law. The law introduces the idea that there are three characteristics that govern process behavior and that you only need to change one to influence the other two, and thus the entire process. And so, if you're unhappy with your system’s performance, you have three dimensions of freedom to influence it. In this case, IOPS is the throughput (Input output operations per second), latency is the queue time, and queue depth is the inventory.

1.	Latency percentile analysis
   
       This last section details the percentile latencies per operation type of storage performance from the minimum value to the maximum value.

       This section is important because it determines the “quality” of your IOPS. It reveals how many of the I/O operations were able to achieve a certain latency value. It is up to you to decide the acceptable latency for that percentile. Moreover, the “nines” refer to the number of nines. For example, “3-nines” is equivalent to the 99th percentile. The number of nines exposes how many I/O operations ran at that percentile. Eventually, you'll reach a point where it no longer makes sense to take the latency values seriously. In this case, you can see that the latency values remain constant after “4-nines.” At this point, the latency value is based on only one I/O operation out of the ~230K.

       :::image type="content" source="media/diskspd/storage-performance.png" alt-text="Example shows percentile latencies per operation type of storage performance." lightbox="media/diskspd/storage-performance.png":::

## Batch test + extracting results into Excel
Great, so now you know how to run DISKSPD and output the results into a text file. However, at the current rate, you'll need to run a new command for every parameter change. Luckily, you can use the two scripts in this section to collect your output metrics into an Excel spreadsheet to analyze them.

To use the scripts:

1.	Download the following two scripts: “Batch-DiskSpd” and “Process-DiskSpd”
1.	The first script to run is “Batch-DiskSpd”
    The parameters are as follows:
    - **$param** => A mandatory string parameter. You need to specify the parameter that you want to vary.

        | Parameter to vary | String command  |
        | :---------------- | :-------------- |
        | Only Thread       | “t”             |
        | Only Queue        | “o”             |
        | Only Block        | “b”             |
        | Thread + Queue    | “to”            |
        | Thread + Block    | “tb”            |
        | Queue + Block     | “ob”            |
    
    - **$rw** => A mandatory int parameter. Specify what percentage of write that you want to test.
    - **$duration** => An optional int parameter. Specify the duration in seconds. Default is 120.
    - **$f_size** => An optional string parameter. Specify the test file size. Default is ‘1G’.
    - **$type** => An optional string parameter. If you want to output into a text file, run “-Rtxt”. If you want to collect the data, run “-Rxml”. The default is “Rxml”.
    - **$path** => An optional string parameter. Specify the directory in which to create your test file. The default is the current directory.

1.	At this point, you'll have multiple xml output files. The next step is to run the “Process-DiskSpd” script. If your xml files are in the same directory as the current script, you can simply run it without any parameters. However, if the output files are in another directory, you need to specify the path while running the script. Your output will be a tsv file.

1.	You should now have a tsv file that you can open in Excel. Here is an example output from varying only the thread values. If you want to test your own thread values, you can change the values at the beginning of the Batch-DiskSpd script. Have fun!

    :::image type="content" source="media/diskspd/thread-value-output.png" alt-text="Example shows thread value output." lightbox="media/diskspd/thread-value-output.png":::

## Things to consider
<!---High-level intro needed--->

### DISKSPD vs. real-world
DISKSPD’s artificial test gives you relatively comparable results for your real workload. However, you need to pay close attention to the parameters you set and whether they match your real scenario. Synthetic workloads will never perfectly represent your application’s real workload during deployment (Ex. does the application require a lot of “think” time or does it continuously pound away with I/O operations).

### Preparation
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
<!---High-level intro needed--->

### Confirming the Coordinator Node
As mentioned previously, if the VM you are currently testing on does not own the CSV, you will see a performance drop (IOPS, throughput, and latency) as opposed to testing it when the node owns the CSV. The reason being that every time you issue an I/O operation, the system needs to perform a network hop to the coordinator node in order to perform that operation. For a three-node, three-way mirrored situation, write operations will always make a network hop since it needs to store data on all three nodes. Therefore, write operations will need to make a network hop regardless. However, if you use a different resiliency structure, this could change. 

Here is an example experiment:
- **Running on local node:** .\DiskSpd-2.0.21a\amd64\diskspd.exe -t4 -o32 -b4k -r4k -w0 -Sh -D -L C:\ClusterStorage\test01\targetfile\IO.dat
- **Running on nonlocal node:** .\DiskSpd-2.0.21a\amd64\diskspd.exe -t4 -o32 -b4k -r4k -w0 -Sh -D -L C:\ClusterStorage\test01\targetfile\IO.dat

From this example, you can clearly see in the following example that latency decreased, IOPS increased, and throughput increased when the coordinator node owns the CSV.

:::image type="content" source="media/diskspd/coordinator-node-data.png" alt-text="Example shows coordinator node data output." lightbox="media/diskspd/coordinator-node-data.png":::

### Online Transaction Processing (OLTP) workload
OLTP queries (Update, Insert, Delete) focus on transaction-oriented tasks. Compared to OLAP, OLTP is storage latency dependent. Because each operation issues little I/O, what we care about is how many operations per second we can sustain.

An OLTP workload test can be designed with a focus on random, small I/O performance. For these tests, you should focus on how far you can push the throughput while maintaining acceptable latencies.

The basic design choice should at minimum include:
- 8KB block size => resembles the page size that SQL Server uses for its data files
- 70% Read, 30% Write => resembles a typical OLTP behavior

### Online Analytical Processing (OLAP) workload
OLAP workloads focus on data retrieval and analysis, allowing users to perform complex queries to extract multidimensional data. Contrary to OLTP, these workloads are not storage latency sensitive. They emphasize queueing many operations without caring much about bandwidth. As a result, they often result in longer processing times.

An OLAP workload test can be designed with a focus on sequential, large I/O performance. For these tests, you should focus on the volume of data processed per second rather than the number of IOPS. Latency requirements are also less important, but this is subjective.

The basic design choice should at minimum include:
- 512 KB block size => resembles the I/O size when the SQL Server loads a batch of 64 data pages for a table scan by using the read-ahead technique. 
- 1 thread per file => currently, you need to limit your testing to 1 thread per file as problems may arise in DISKSPD when testing multiple sequential threads.
    If you use more than one thread, say 2, and the -s parameter, the threads will begin to non-deterministically issue IO operations on top of each other within the same location. This is because they each track their own sequential offset. There are two “solutions” to resolve this issue.

    The first solution involves using the -si parameter. With this, both threads share a single interlocked offset so that “the threads cooperatively issue a single sequential pattern of access to the target file. This allows no one point in the file to be operated on more than once. However, because they still do race each other to issue their IO operation to the queue, the operations may arrive out of order.

- This solution works well if one thread becomes CPU limited. You may wish to engage a second thread on a second CPU core to deliver more storage IO to the CPU system in order to further saturate it.

    The second solution involves using the -T<offset>. This allows you to specify the offset size (inter-I/O gap) between IO operations performed on the same target file by different threads. For example, threads normally start at offset 0, but this specification allows you to distance the two threads so that they will not overlap each other. In any multithreaded environment, the threads will likely be on different portions of the working target and this is a way of simulating that situation.

## Next steps
For more information and detailed examples on optimizing your resiliency settings, see also:
- [OLTP and OLAP](https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn894707(v=ws.11))
- [Resiliency choice](https://techcommunity.microsoft.com/t5/storage-at-microsoft/volume-resiliency-and-efficiency-in-storage-spaces-direct/ba-p/425831)
