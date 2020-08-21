# T1547.006 - Boot or Logon Autostart Execution: Kernel Modules and Extensions
Adversaries may modify the kernel to automatically execute programs on system boot. Loadable Kernel Modules (LKMs) are pieces of code that can be loaded and unloaded into the kernel upon demand. They extend the functionality of the kernel without the need to reboot the system. For example, one type of module is the device driver, which allows the kernel to access hardware connected to the system. (Citation: Linux Kernel Programming) 

When used maliciously, LKMs can be a type of kernel-mode [Rootkit](https://attack.mitre.org/techniques/T1014) that run with the highest operating system privilege (Ring 0). (Citation: Linux Kernel Module Programming Guide) Common features of LKM based rootkits include: hiding itself, selective hiding of files, processes and network activity, as well as log tampering, providing authenticated backdoors and enabling root access to non-privileged users. (Citation: iDefense Rootkit Overview)

Kernel extensions, also called kext, are used for macOS to load functionality onto a system similar to LKMs for Linux. They are loaded and unloaded through <code>kextload</code> and <code>kextunload</code> commands.

Adversaries can use LKMs and kexts to covertly persist on a system and elevate privileges. Examples have been found in the wild and there are some open source projects. (Citation: Volatility Phalanx2) (Citation: CrowdStrike Linux Rootkit) (Citation: GitHub Reptile) (Citation: GitHub Diamorphine)(Citation: RSAC 2015 San Francisco Patrick Wardle) (Citation: Synack Secure Kernel Extension Broken)(Citation: Securelist Ventir) (Citation: Trend Micro Skidmap)

## Atomic Tests

#Import the Module before running the tests.
Import-Module /Users/0x6c/AtomicRedTeam/atomics/invoke-atomicredteam/Invoke-AtomicRedTeam.psd1 - Force

### Atomic Test #1 - Linux - Load Kernel Module via insmod
This test uses the insmod command to load a kernel module for Linux.

**Supported Platforms:** linux
#### Attack Commands: Run with `bash`
```bash
sudo insmod #{module_path}
```

Invoke-AtomicTest T1547.006 -TestNumbers 1

## Detection
Loading, unloading, and manipulating modules on Linux systems can be detected by monitoring for the following commands:<code>modprobe</code>, <code>insmod</code>, <code>lsmod</code>, <code>rmmod</code>, or <code>modinfo</code> (Citation: Linux Loadable Kernel Module Insert and Remove LKMs) LKMs are typically loaded into <code>/lib/modules</code> and have had the extension .ko ("kernel object") since version 2.6 of the Linux kernel. (Citation: Wikipedia Loadable Kernel Module)

For macOS, monitor for execution of <code>kextload</code> commands and correlate with other unknown or suspicious activity.

Adversaries may run commands on the target system before loading a malicious module in order to ensure that it is properly compiled. (Citation: iDefense Rootkit Overview) Adversaries may also execute commands to identify the exact version of the running Linux kernel and/or download multiple versions of the same .ko (kernel object) files to use the one appropriate for the running system.(Citation: Trend Micro Skidmap) Many LKMs require Linux headers (specific to the target kernel) in order to compile properly. These are typically obtained through the operating systems package manager and installed like a normal package. On Ubuntu and Debian based systems this can be accomplished by running: <code>apt-get install linux-headers-$(uname -r)</code> On RHEL and CentOS based systems this can be accomplished by running: <code>yum install kernel-devel-$(uname -r)</code>