# Persistence
The adversary is trying to maintain their foothold.

Persistence consists of techniques that adversaries use to keep access to systems across restarts, changed credentials, and other interruptions that could cut off their access. Techniques used for persistence include any access, action, or configuration changes that let them maintain their foothold on systems, such as replacing or hijacking legitimate code or adding startup code. 
## Techniques
| ID      | Name | Description |
| :--------: | :---------: | :---------: |
T1205.001 | Port Knocking | Adversaries may use port knocking to hide open ports used for persistence or command and control. To enable a port, an adversary sends a series of attempted connections to a predefined sequence of closed ports. After the sequence is completed, opening a port is often accomplished by the host based firewall, but could also be implemented by custom software.

This technique has been observed to both for the dynamic opening of a listening port as well as the initiating of a connection to a listening server on a different system.

The observation of the signal packets to trigger the communication can be conducted through different methods. One means, originally implemented by Cd00r (Citation: Hartrell cd00r 2002), is to use the libpcap libraries to sniff for the packets in question. Another method leverages raw sockets, which enables the malware to use ports that are already open for use by other programs.
T1574.012 | COR_PROFILER | Adversaries may leverage the COR_PROFILER environment variable to hijack the execution flow of programs that load the .NET CLR. The COR_PROFILER is a .NET Framework feature which allows developers to specify an unmanaged (or external of .NET) profiling DLL to be loaded into each .NET process that loads the Common Language Runtime (CLR). These profiliers are designed to monitor, troubleshoot, and debug managed code executed by the .NET CLR.(Citation: Microsoft Profiling Mar 2017)(Citation: Microsoft COR_PROFILER Feb 2013)

The COR_PROFILER environment variable can be set at various scopes (system, user, or process) resulting in different levels of influence. System and user-wide environment variable scopes are specified in the Registry, where a [Component Object Model](https://attack.mitre.org/techniques/T1559/001) (COM) object can be registered as a profiler DLL. A process scope COR_PROFILER can also be created in-memory without modifying the Registry. Starting with .NET Framework 4, the profiling DLL does not need to be registered as long as the location of the DLL is specified in the COR_PROFILER_PATH environment variable.(Citation: Microsoft COR_PROFILER Feb 2013)

Adversaries may abuse COR_PROFILER to establish persistence that executes a malicious DLL in the context of all .NET processes every time the CLR is invoked. The COR_PROFILER can also be used to elevate privileges (ex: [Bypass User Access Control](https://attack.mitre.org/techniques/T1548/002)) if the victim .NET process executes at a higher permission level, as well as to hook and [Impair Defenses](https://attack.mitre.org/techniques/T1562) provided by .NET processes.(Citation: RedCanary Mockingbird May 2020)(Citation: Red Canary COR_PROFILER May 2020)(Citation: Almond COR_PROFILER Apr 2019)(Citation: GitHub OmerYa Invisi-Shell)(Citation: subTee .NET Profilers May 2017)
T1098.004 | SSH Authorized Keys | Adversaries may modify the SSH <code>authorized_keys</code> file to maintain persistence on a victim host. Linux distributions and macOS commonly use key-based authentication to secure the authentication process of SSH sessions for remote management. The <code>authorized_keys</code> file in SSH specifies the SSH keys that can be used for logging into the user account for which the file is configured. This file is usually found in the user's home directory under <code>&lt;user-home&gt;/.ssh/authorized_keys</code>.(Citation: SSH Authorized Keys) Users may edit the system’s SSH config file to modify the directives PubkeyAuthentication and RSAAuthentication to the value “yes” to ensure public key and RSA authentication are enabled. The SSH config file is usually located under <code>/etc/ssh/sshd_config</code>.

Adversaries may modify SSH <code>authorized_keys</code> files directly with scripts or shell commands to add their own adversary-supplied public keys. This ensures that an adversary possessing the corresponding private key may log in as an existing user via SSH.(Citation: Venafi SSH Key Abuse) (Citation: Cybereason Linux Exim Worm)
T1574.004 | Dylib Hijacking | Adversaries may execute their own malicious payloads by hijacking ambiguous paths  used to load libraries. Adversaries may plant trojan dynamic libraries, in a directory that will be searched by the operating system before the legitimate library specified by the victim program, so that their malicious library will be loaded into the victim program instead.  MacOS and OS X use a common method to look for required dynamic libraries (dylib) to load into a program based on search paths.

A common method is to see what dylibs an application uses, then plant a malicious version with the same name higher up in the search path. This typically results in the dylib being in the same folder as the application itself. (Citation: Writing Bad Malware for OSX) (Citation: Malware Persistence on OS X)

If the program is configured to run at a higher privilege level than the current user, then when the dylib is loaded into the application, the dylib will also run at that elevated level.
T1546.015 | Component Object Model Hijacking | Adversaries may establish persistence by executing malicious content triggered by hijacked references to Component Object Model (COM) objects. COM is a system within Windows to enable interaction between software components through the operating system.(Citation: Microsoft Component Object Model)  References to various COM objects are stored in the Registry. 

Adversaries can use the COM system to insert malicious code that can be executed in place of legitimate software through hijacking the COM references and relationships as a means for persistence. Hijacking a COM object requires a change in the Registry to replace a reference to a legitimate system component which may cause that component to not work when executed. When that system component is executed through normal system operation the adversary's code will be executed instead.(Citation: GDATA COM Hijacking) An adversary is likely to hijack objects that are used frequently enough to maintain a consistent level of persistence, but are unlikely to break noticeable functionality within the system as to avoid system instability that could lead to detection. 
T1078.004 | Cloud Accounts | Adversaries may obtain and abuse credentials of a cloud account as a means of gaining Initial Access, Persistence, Privilege Escalation, or Defense Evasion. Cloud accounts are those created and configured by an organization for use by users, remote support, services, or for administration of resources within a cloud service provider or SaaS application. In some cases, cloud accounts may be federated with traditional identity management system, such as Window Active Directory.(Citation: AWS Identity Federation)(Citation: Google Federating GC)(Citation: Microsoft Deploying AD Federation)

Compromised credentials for cloud accounts can be used to harvest sensitive data from online storage accounts and databases. Access to cloud accounts can also be abused to gain Initial Access to a network by abusing a [Trusted Relationship](https://attack.mitre.org/techniques/T1199). Similar to [Domain Accounts](https://attack.mitre.org/techniques/T1078/002), compromise of federated cloud accounts may allow adversaries to more easily move laterally within an environment.
T1078.003 | Local Accounts | Adversaries may obtain and abuse credentials of a local account as a means of gaining Initial Access, Persistence, Privilege Escalation, or Defense Evasion. Local accounts are those configured by an organization for use by users, remote support, services, or for administration on a single system or service.

Local Accounts may also be abused to elevate privileges and harvest credentials through [OS Credential Dumping](https://attack.mitre.org/techniques/T1003). Password reuse may allow the abuse of local accounts across a set of machines on a network for the purposes of Privilege Escalation and Lateral Movement. 
T1078.002 | Domain Accounts | Adversaries may obtain and abuse credentials of a domain account as a means of gaining Initial Access, Persistence, Privilege Escalation, or Defense Evasion. (Citation: TechNet Credential Theft) Domain accounts are those managed by Active Directory Domain Services where access and permissions are configured across systems and services that are part of that domain. Domain accounts can cover users, administrators, and services.(Citation: Microsoft AD Accounts)

Adversaries may compromise domain accounts, some with a high level of privileges, through various means such as [OS Credential Dumping](https://attack.mitre.org/techniques/T1003) or password reuse, allowing access to privileged resources of the domain.
T1078.001 | Default Accounts | Adversaries may obtain and abuse credentials of a default account as a means of gaining Initial Access, Persistence, Privilege Escalation, or Defense Evasion. Default accounts are those that are built-into an OS, such as the Guest or Administrator accounts on Windows systems or default factory/provider set accounts on other types of systems, software, or devices.(Citation: Microsoft Local Accounts Feb 2019)

Default accounts are not limited to client machines, rather also include accounts that are preset for equipment such as network devices and computer applications whether they are internal, open source, or commercial. Appliances that come preset with a username and password combination pose a serious threat to organizations that do not change it post installation, as they are easy targets for an adversary. Similarly, adversaries may also utilize publicly disclosed or stolen [Private Keys](https://attack.mitre.org/techniques/T1552/004) or credential materials to legitimately connect to remote environments via [Remote Services](https://attack.mitre.org/techniques/T1021).(Citation: Metasploit SSH Module)
T1574.006 | LD_PRELOAD | Adversaries may execute their own malicious payloads by hijacking the dynamic linker used to load libraries. The dynamic linker is used to load shared library dependencies needed by an executing program. The dynamic linker will typically check provided absolute paths and common directories for these dependencies, but can be overridden by shared objects specified by LD_PRELOAD to be loaded before all others.(Citation: Man LD.SO)(Citation: TLDP Shared Libraries)

Adversaries may set LD_PRELOAD to point to malicious libraries that match the name of legitimate libraries which are requested by a victim program, causing the operating system to load the adversary's malicious code upon execution of the victim program. LD_PRELOAD can be set via the environment variable or <code>/etc/ld.so.preload</code> file.(Citation: Man LD.SO)(Citation: TLDP Shared Libraries) Libraries specified by LD_PRELOAD with be loaded and mapped into memory by <code>dlopen()</code> and <code>mmap()</code> respectively.(Citation: Code Injection on Linux and macOS) (Citation: Uninformed Needle) (Citation: Phrack halfdead 1997)

LD_PRELOAD hijacking may grant access to the victim process's memory, system/network resources, and possibly elevated privileges. Execution via LD_PRELOAD hijacking may also evade detection from security products since the execution is masked under a legitimate process.
T1574.002 | DLL Side-Loading | Adversaries may execute their own malicious payloads by hijacking the library manifest used to load DLLs. Adversaries may take advantage of vague references in the library manifest of a program by replacing a legitimate library with a malicious one, causing the operating system to load their malicious library when it is called for by the victim program.

Programs may specify DLLs that are loaded at runtime. Programs that improperly or vaguely specify a required DLL may be open to a vulnerability in which an unintended DLL is loaded. Side-loading vulnerabilities specifically occur when Windows Side-by-Side (WinSxS) manifests (Citation: About Side by Side Assemblies) are not explicit enough about characteristics of the DLL to be loaded. Adversaries may take advantage of a legitimate program that is vulnerable by replacing the legitimate DLL with a malicious one.  (Citation: FireEye DLL Side-Loading)

Adversaries likely use this technique as a means of masking actions they perform under a legitimate, trusted system or software process.
T1574.001 | DLL Search Order Hijacking | Adversaries may execute their own malicious payloads by hijacking the search order used to load DLLs. Windows systems use a common method to look for required DLLs to load into a program. (Citation: Microsoft Dynamic Link Library Search Order) Hijacking DLL loads may be for the purpose of establishing persistence as well as elevating privileges and/or evading restrictions on file execution.

There are many ways an adversary can hijack DLL loads. Adversaries may plant trojan dynamic-link library files (DLLs) in a directory that will be searched before the location of a legitimate library that will be requested by a program, causing Windows to load their malicious library when it is called for by the victim program. Adversaries may also perform DLL preloading, also called binary planting attacks, (Citation: OWASP Binary Planting) by placing a malicious DLL with the same name as an ambiguously specified DLL in a location that Windows searches before the legitimate DLL. Often this location is the current working directory of the program. Remote DLL preloading attacks occur when a program sets its current directory to a remote location such as a Web share before loading a DLL. (Citation: Microsoft Security Advisory 2269637)

Adversaries may also directly modify the way a program loads DLLs by replacing an existing DLL or modifying a .manifest or .local redirection file, directory, or junction to cause the program to load a different DLL. (Citation: Microsoft Dynamic-Link Library Redirection) (Citation: Microsoft Manifests) (Citation: FireEye DLL Search Order Hijacking)

If a search order-vulnerable program is configured to run at a higher privilege level, then the adversary-controlled DLL that is loaded will also be executed at the higher level. In this case, the technique could be used for privilege escalation from user to administrator or SYSTEM or from administrator to SYSTEM, depending on the program.
Programs that fall victim to path hijacking may appear to behave normally because malicious DLLs may be configured to also load the legitimate DLLs they were meant to replace.
T1574.008 | Path Interception by Search Order Hijacking | Adversaries may execute their own malicious payloads by hijacking the search order used to load other programs. Because some programs do not call other programs using the full path, adversaries may place their own file in the directory where the calling program is located, causing the operating system to launch their malicious software at the request of the calling program.

Search order hijacking occurs when an adversary abuses the order in which Windows searches for programs that are not given a path. Unlike [DLL Search Order Hijacking](https://attack.mitre.org/techniques/T1574/001), the search order differs depending on the method that is used to execute the program. (Citation: Microsoft CreateProcess) (Citation: Windows NT Command Shell) (Citation: Microsoft WinExec) However, it is common for Windows to search in the directory of the initiating program before searching through the Windows system directory. An adversary who finds a program vulnerable to search order hijacking (i.e., a program that does not specify the path to an executable) may take advantage of this vulnerability by creating a program named after the improperly specified program and placing it within the initiating program's directory.

For example, "example.exe" runs "cmd.exe" with the command-line argument <code>net user</code>. An adversary may place a program called "net.exe" within the same directory as example.exe, "net.exe" will be run instead of the Windows system utility net. In addition, if an adversary places a program called "net.com" in the same directory as "net.exe", then <code>cmd.exe /C net user</code> will execute "net.com" instead of "net.exe" due to the order of executable extensions defined under PATHEXT. (Citation: Microsoft Environment Property)

Search order hijacking is also a common practice for hijacking DLL loads and is covered in [DLL Search Order Hijacking](https://attack.mitre.org/techniques/T1574/001).
T1574.007 | Path Interception by PATH Environment Variable | Adversaries may execute their own malicious payloads by hijacking environment variables used to load libraries. Adversaries may place a program in an earlier entry in the list of directories stored in the PATH environment variable, which Windows will then execute when it searches sequentially through that PATH listing in search of the binary that was called from a script or the command line.

The PATH environment variable contains a list of directories. Certain methods of executing a program (namely using cmd.exe or the command-line) rely solely on the PATH environment variable to determine the locations that are searched for a program when the path for the program is not given. If any directories are listed in the PATH environment variable before the Windows directory, <code>%SystemRoot%\system32</code> (e.g., <code>C:\Windows\system32</code>), a program may be placed in the preceding directory that is named the same as a Windows program (such as cmd, PowerShell, or Python), which will be executed when that command is executed from a script or command-line.

For example, if <code>C:\example path</code> precedes </code>C:\Windows\system32</code> is in the PATH environment variable, a program that is named net.exe and placed in <code>C:\example path</code> will be called instead of the Windows system "net" when "net" is executed from the command-line.
T1574.009 | Path Interception by Unquoted Path | Adversaries may execute their own malicious payloads by hijacking vulnerable file path references. Adversaries can take advantage of paths that lack surrounding quotations by placing an executable in a higher level directory within the path, so that Windows will choose the adversary's executable to launch.

Service paths (Citation: Microsoft CurrentControlSet Services) and shortcut paths may also be vulnerable to path interception if the path has one or more spaces and is not surrounded by quotation marks (e.g., <code>C:\unsafe path with space\program.exe</code> vs. <code>"C:\safe path with space\program.exe"</code>). (Citation: Help eliminate unquoted path) (stored in Windows Registry keys) An adversary can place an executable in a higher level directory of the path, and Windows will resolve that executable instead of the intended executable. For example, if the path in a shortcut is <code>C:\program files\myapp.exe</code>, an adversary may create a program at <code>C:\program.exe</code> that will be run instead of the intended program. (Citation: Windows Unquoted Services) (Citation: Windows Privilege Escalation Guide)

This technique can be used for persistence if executables are called on a regular basis, as well as privilege escalation if intercepted executables are started by a higher privileged process.
T1574.011 | Services Registry Permissions Weakness | Adversaries may execute their own malicious payloads by hijacking the Registry entries used by services. Adversaries may use flaws in the permissions for registry to redirect from the originally specified executable to one that they control, in order to launch their own code at Service start.  Windows stores local service configuration information in the Registry under <code>HKLM\SYSTEM\CurrentControlSet\Services</code>. The information stored under a service's Registry keys can be manipulated to modify a service's execution parameters through tools such as the service controller, sc.exe,  [PowerShell](https://attack.mitre.org/techniques/T1059/001), or [Reg](https://attack.mitre.org/software/S0075). Access to Registry keys is controlled through Access Control Lists and permissions. (Citation: Registry Key Security)

If the permissions for users and groups are not properly set and allow access to the Registry keys for a service, then adversaries can change the service binPath/ImagePath to point to a different executable under their control. When the service starts or is restarted, then the adversary-controlled program will execute, allowing the adversary to gain persistence and/or privilege escalation to the account context the service is set to execute under (local/domain account, SYSTEM, LocalService, or NetworkService).

Adversaries may also alter Registry keys associated with service failure parameters (such as <code>FailureCommand</code>) that may be executed in an elevated context anytime the service fails or is intentionally corrupted.(Citation: Kansa Service related collectors)(Citation: Tweet Registry Perms Weakness) 
T1574.005 | Executable Installer File Permissions Weakness | Adversaries may execute their own malicious payloads by hijacking the binaries used by an installer. These processes may automatically execute specific binaries as part of their functionality or to perform other actions. If the permissions on the file system directory containing a target binary, or permissions on the binary itself, are improperly set, then the target binary may be overwritten with another binary using user-level permissions and executed by the original process. If the original process and thread are running under a higher permissions level, then the replaced binary will also execute under higher-level permissions, which could include SYSTEM.

Another variation of this technique can be performed by taking advantage of a weakness that is common in executable, self-extracting installers. During the installation process, it is common for installers to use a subdirectory within the <code>%TEMP%</code> directory to unpack binaries such as DLLs, EXEs, or other payloads. When installers create subdirectories and files they often do not set appropriate permissions to restrict write access, which allows for execution of untrusted code placed in the subdirectories or overwriting of binaries used in the installation process. This behavior is related to and may take advantage of [DLL Search Order Hijacking](https://attack.mitre.org/techniques/T1574/001).

Adversaries may use this technique to replace legitimate binaries with malicious ones as a means of executing code at a higher permissions level. Some installers may also require elevated privileges that will result in privilege escalation when executing adversary controlled code. This behavior is related to [Bypass User Access Control](https://attack.mitre.org/techniques/T1548/002). Several examples of this weakness in existing common installers have been reported to software vendors.(Citation: mozilla_sec_adv_2012)  (Citation: Executable Installers are Vulnerable) If the executing process is set to run at a specific time or during a certain event (e.g., system bootup) then this technique can also be used for persistence.
T1574.010 | Services File Permissions Weakness | Adversaries may execute their own malicious payloads by hijacking the binaries used by services. Adversaries may use flaws in the permissions of Windows services to replace the binary that is executed upon service start. These service processes may automatically execute specific binaries as part of their functionality or to perform other actions. If the permissions on the file system directory containing a target binary, or permissions on the binary itself are improperly set, then the target binary may be overwritten with another binary using user-level permissions and executed by the original process. If the original process and thread are running under a higher permissions level, then the replaced binary will also execute under higher-level permissions, which could include SYSTEM.

Adversaries may use this technique to replace legitimate binaries with malicious ones as a means of executing code at a higher permissions level. If the executing process is set to run at a specific time or during a certain event (e.g., system bootup) then this technique can also be used for persistence.
T1574 | Hijack Execution Flow | Adversaries may execute their own malicious payloads by hijacking the way operating systems run programs. Hijacking execution flow can be for the purposes of persistence, since this hijacked execution may reoccur over time. Adversaries may also use these mechanisms to elevate privileges or evade defenses, such as application control or other restrictions on execution.

There are many ways an adversary may hijack the flow of execution, including by manipulating how the operating system locates programs to be executed. How the operating system locates libraries to be used by a program can also be intercepted. Locations where the operating system looks for programs/resources, such as file directories and in the case of Windows the Registry, could also be poisoned to include malicious payloads.
T1554 | Compromise Client Software Binary | Adversaries may modify client software binaries to establish persistent access to systems. Client software enables users to access services provided by a server. Common client software types are SSH clients, FTP clients, email clients, and web browsers.

Adversaries may make modifications to client software binaries to carry out malicious tasks when those applications are in use. For example, an adversary may copy source code for the client software, add a backdoor, compile for the target, and replace the legitimate application binary (or support files) with the backdoored one. Since these applications may be routinely executed by the user, the adversary can leverage this for persistent access to the host.
T1136.003 | Cloud Account | Adversaries may create a cloud account to maintain access to victim systems. With a sufficient level of access, such accounts may be used to establish secondary credentialed access that does not require persistent remote access tools to be deployed on the system.(Citation: Microsoft O365 Admin Roles)(Citation: Microsoft Support O365 Add Another Admin, October 2019)(Citation: AWS Create IAM User)(Citation: GCP Create Cloud Identity Users)(Citation: Microsoft Azure AD Users)

Adversaries may create accounts that only have access to specific cloud services, which can reduce the chance of detection.
T1136.002 | Domain Account | Adversaries may create a domain account to maintain access to victim systems. Domain accounts are those managed by Active Directory Domain Services where access and permissions are configured across systems and services that are part of that domain. Domain accounts can cover user, administrator, and service accounts. With a sufficient level of access, the <code>net user /add /domain</code> command can be used to create a domain account.

Such accounts may be used to establish secondary credentialed access that do not require persistent remote access tools to be deployed on the system.
T1136.001 | Local Account | Adversaries may create a local account to maintain access to victim systems. Local accounts are those configured by an organization for use by users, remote support, services, or for administration on a single system or service. With a sufficient level of access, the <code>net user /add</code> command can be used to create a local account.

Such accounts may be used to establish secondary credentialed access that do not require persistent remote access tools to be deployed on the system.
T1547.011 | Plist Modification | Adversaries may modify plist files to run a program during system boot or user login. Property list (plist) files contain all of the information that macOS and OS X uses to configure applications and services. These files are UTF-8 encoded and formatted like XML documents via a series of keys surrounded by < >. They detail when programs should execute, file paths to the executables, program arguments, required OS permissions, and many others. plists are located in certain locations depending on their purpose such as <code>/Library/Preferences</code> (which execute with elevated privileges) and <code>~/Library/Preferences</code> (which execute with a user's privileges). 

Adversaries can modify plist files to execute their code as part of establishing persistence. plists may also be used to elevate privileges since they may execute in the context of another user.(Citation: Sofacy Komplex Trojan) 

A specific plist used for execution at login is <code>com.apple.loginitems.plist</code>.(Citation: Methods of Mac Malware Persistence) Applications under this plist run under the logged in user's context, and will be started every time the user logs in. Login items installed using the Service Management Framework are not visible in the System Preferences and can only be removed by the application that created them.(Citation: Adding Login Items) Users have direct control over login items installed using a shared file list which are also visible in System Preferences (Citation: Adding Login Items). Some of these applications can open visible dialogs to the user, but they don’t all have to since there is an option to "hide" the window. If an adversary can register their own login item or modified an existing one, then they can use it to execute their code for a persistence mechanism each time the user logs in (Citation: Malware Persistence on OS X) (Citation: OSX.Dok Malware). The API method <code> SMLoginItemSetEnabled</code> can be used to set Login Items, but scripting languages like [AppleScript](https://attack.mitre.org/techniques/T1059/002) can do this as well. (Citation: Adding Login Items)
T1547.010 | Port Monitors | Adversaries may use port monitors to run an attacker supplied DLL during system boot for persistence or privilege escalation. A port monitor can be set through the <code>AddMonitor</code> API call to set a DLL to be loaded at startup. (Citation: AddMonitor) This DLL can be located in <code>C:\Windows\System32</code> and will be loaded by the print spooler service, spoolsv.exe, on boot. The spoolsv.exe process also runs under SYSTEM level permissions. (Citation: Bloxham) Alternatively, an arbitrary DLL can be loaded if permissions allow writing a fully-qualified pathname for that DLL to <code>HKLM\SYSTEM\CurrentControlSet\Control\Print\Monitors</code>. 

The Registry key contains entries for the following:

* Local Port
* Standard TCP/IP Port
* USB Monitor
* WSD Port

Adversaries can use this technique to load malicious code at startup that will persist on system reboot and execute as SYSTEM.
T1547.009 | Shortcut Modification | Adversaries may create or edit shortcuts to run a program during system boot or user login. Shortcuts or symbolic links are ways of referencing other files or programs that will be opened or executed when the shortcut is clicked or executed by a system startup process.

Adversaries could use shortcuts to execute their tools for persistence. They may create a new shortcut as a means of indirection that may use [Masquerading](https://attack.mitre.org/techniques/T1036) to look like a legitimate program. Adversaries could also edit the target path or entirely replace an existing shortcut so their tools will be executed instead of the intended legitimate program.
T1547.008 | LSASS Driver | Adversaries may modify or add LSASS drivers to obtain persistence on compromised systems. The Windows security subsystem is a set of components that manage and enforce the security policy for a computer or domain. The Local Security Authority (LSA) is the main component responsible for local security policy and user authentication. The LSA includes multiple dynamic link libraries (DLLs) associated with various other security functions, all of which run in the context of the LSA Subsystem Service (LSASS) lsass.exe process. (Citation: Microsoft Security Subsystem)

Adversaries may target LSASS drivers to obtain persistence. By either replacing or adding illegitimate drivers (e.g., [Hijack Execution Flow](https://attack.mitre.org/techniques/T1574)), an adversary can use LSA operations to continuously execute malicious payloads.
T1547.007 | Re-opened Applications | Adversaries may modify plist files to automatically run an application when a user logs in. Starting in Mac OS X 10.7 (Lion), users can specify certain applications to be re-opened when a user logs into their machine after reboot. While this is usually done via a Graphical User Interface (GUI) on an app-by-app basis, there are property list files (plist) that contain this information as well located at <code>~/Library/Preferences/com.apple.loginwindow.plist</code> and <code>~/Library/Preferences/ByHost/com.apple.loginwindow.* .plist</code>. 

An adversary can modify one of these files directly to include a link to their malicious executable to provide a persistence mechanism each time the user reboots their machine (Citation: Methods of Mac Malware Persistence).
T1547.006 | Kernel Modules and Extensions | Adversaries may modify the kernel to automatically execute programs on system boot. Loadable Kernel Modules (LKMs) are pieces of code that can be loaded and unloaded into the kernel upon demand. They extend the functionality of the kernel without the need to reboot the system. For example, one type of module is the device driver, which allows the kernel to access hardware connected to the system. (Citation: Linux Kernel Programming) 

When used maliciously, LKMs can be a type of kernel-mode [Rootkit](https://attack.mitre.org/techniques/T1014) that run with the highest operating system privilege (Ring 0). (Citation: Linux Kernel Module Programming Guide) Common features of LKM based rootkits include: hiding itself, selective hiding of files, processes and network activity, as well as log tampering, providing authenticated backdoors and enabling root access to non-privileged users. (Citation: iDefense Rootkit Overview)

Kernel extensions, also called kext, are used for macOS to load functionality onto a system similar to LKMs for Linux. They are loaded and unloaded through <code>kextload</code> and <code>kextunload</code> commands.

Adversaries can use LKMs and kexts to covertly persist on a system and elevate privileges. Examples have been found in the wild and there are some open source projects. (Citation: Volatility Phalanx2) (Citation: CrowdStrike Linux Rootkit) (Citation: GitHub Reptile) (Citation: GitHub Diamorphine)(Citation: RSAC 2015 San Francisco Patrick Wardle) (Citation: Synack Secure Kernel Extension Broken)(Citation: Securelist Ventir) (Citation: Trend Micro Skidmap)
T1547.005 | Security Support Provider | Adversaries may abuse security support providers (SSPs) to execute DLLs when the system boots. Windows SSP DLLs are loaded into the Local Security Authority (LSA) process at system start. Once loaded into the LSA, SSP DLLs have access to encrypted and plaintext passwords that are stored in Windows, such as any logged-on user's Domain password or smart card PINs.

The SSP configuration is stored in two Registry keys: <code>HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Security Packages</code> and <code>HKLM\SYSTEM\CurrentControlSet\Control\Lsa\OSConfig\Security Packages</code>. An adversary may modify these Registry keys to add new SSPs, which will be loaded the next time the system boots, or when the AddSecurityPackage Windows API function is called.(Citation: Graeber 2014)
T1547.004 | Winlogon Helper DLL | Adversaries may abuse features of Winlogon to execute DLLs and/or executables when a user logs in. Winlogon.exe is a Windows component responsible for actions at logon/logoff as well as the secure attention sequence (SAS) triggered by Ctrl-Alt-Delete. Registry entries in <code>HKLM\Software[\\Wow6432Node\\]\Microsoft\Windows NT\CurrentVersion\Winlogon\</code> and <code>HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\</code> are used to manage additional helper programs and functionalities that support Winlogon. (Citation: Cylance Reg Persistence Sept 2013) 

Malicious modifications to these Registry keys may cause Winlogon to load and execute malicious DLLs and/or executables. Specifically, the following subkeys have been known to be possibly vulnerable to abuse: (Citation: Cylance Reg Persistence Sept 2013)

* Winlogon\Notify - points to notification package DLLs that handle Winlogon events
* Winlogon\Userinit - points to userinit.exe, the user initialization program executed when a user logs on
* Winlogon\Shell - points to explorer.exe, the system shell executed when a user logs on

Adversaries may take advantage of these features to repeatedly execute malicious code and establish persistence.
T1547.003 | Time Providers | Adversaries may abuse time providers to execute DLLs when the system boots. The Windows Time service (W32Time) enables time synchronization across and within domains. (Citation: Microsoft W32Time Feb 2018) W32Time time providers are responsible for retrieving time stamps from hardware/network resources and outputting these values to other network clients. (Citation: Microsoft TimeProvider)

Time providers are implemented as dynamic-link libraries (DLLs) that are registered in the subkeys of  <code>HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\W32Time\TimeProviders\</code>. (Citation: Microsoft TimeProvider) The time provider manager, directed by the service control manager, loads and starts time providers listed and enabled under this key at system startup and/or whenever parameters are changed. (Citation: Microsoft TimeProvider)

Adversaries may abuse this architecture to establish persistence, specifically by registering and enabling a malicious DLL as a time provider. Administrator privileges are required for time provider registration, though execution will run in context of the Local Service account. (Citation: Github W32Time Oct 2017)
T1546.014 | Emond | Adversaries may gain persistence and elevate privileges by executing malicious content triggered by the Event Monitor Daemon (emond). Emond is a [Launch Daemon](https://attack.mitre.org/techniques/T1543/004) that accepts events from various services, runs them through a simple rules engine, and takes action. The emond binary at <code>/sbin/emond</code> will load any rules from the <code>/etc/emond.d/rules/</code> directory and take action once an explicitly defined event takes place.

The rule files are in the plist format and define the name, event type, and action to take. Some examples of event types include system startup and user authentication. Examples of actions are to run a system command or send an email. The emond service will not launch if there is no file present in the QueueDirectories path <code>/private/var/db/emondClients</code>, specified in the [Launch Daemon](https://attack.mitre.org/techniques/T1543/004) configuration file at<code>/System/Library/LaunchDaemons/com.apple.emond.plist</code>.(Citation: xorrior emond Jan 2018)(Citation: magnusviri emond Apr 2016)(Citation: sentinelone macos persist Jun 2019)

Adversaries may abuse this service by writing a rule to execute commands when a defined event occurs, such as system start up or user authentication.(Citation: xorrior emond Jan 2018)(Citation: magnusviri emond Apr 2016)(Citation: sentinelone macos persist Jun 2019) Adversaries may also be able to escalate privileges from administrator to root as the emond service is executed with root privileges by the [Launch Daemon](https://attack.mitre.org/techniques/T1543/004) service.
T1546.013 | PowerShell Profile | Adversaries may gain persistence and elevate privileges by executing malicious content triggered by PowerShell profiles. A PowerShell profile  (<code>profile.ps1</code>) is a script that runs when [PowerShell](https://attack.mitre.org/techniques/T1059/001) starts and can be used as a logon script to customize user environments.

[PowerShell](https://attack.mitre.org/techniques/T1059/001) supports several profiles depending on the user or host program. For example, there can be different profiles for [PowerShell](https://attack.mitre.org/techniques/T1059/001) host programs such as the PowerShell console, PowerShell ISE or Visual Studio Code. An administrator can also configure a profile that applies to all users and host programs on the local computer. (Citation: Microsoft About Profiles) 

Adversaries may modify these profiles to include arbitrary commands, functions, modules, and/or [PowerShell](https://attack.mitre.org/techniques/T1059/001) drives to gain persistence. Every time a user opens a [PowerShell](https://attack.mitre.org/techniques/T1059/001) session the modified script will be executed unless the <code>-NoProfile</code> flag is used when it is launched. (Citation: ESET Turla PowerShell May 2019) 

An adversary may also be able to escalate privileges if a script in a PowerShell profile is loaded and executed by an account with higher privileges, such as a domain administrator. (Citation: Wits End and Shady PowerShell Profiles)
T1546.012 | Image File Execution Options Injection | Adversaries may establish persistence and/or elevate privileges by executing malicious content triggered by Image File Execution Options (IEFO) debuggers. IEFOs enable a developer to attach a debugger to an application. When a process is created, a debugger present in an application’s IFEO will be prepended to the application’s name, effectively launching the new process under the debugger (e.g., <code>C:\dbg\ntsd.exe -g  notepad.exe</code>). (Citation: Microsoft Dev Blog IFEO Mar 2010)

IFEOs can be set directly via the Registry or in Global Flags via the GFlags tool. (Citation: Microsoft GFlags Mar 2017) IFEOs are represented as <code>Debugger</code> values in the Registry under <code>HKLM\SOFTWARE{\Wow6432Node}\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\<executable></code> where <code>&lt;executable&gt;</code> is the binary on which the debugger is attached. (Citation: Microsoft Dev Blog IFEO Mar 2010)

IFEOs can also enable an arbitrary monitor program to be launched when a specified program silently exits (i.e. is prematurely terminated by itself or a second, non kernel-mode process). (Citation: Microsoft Silent Process Exit NOV 2017) (Citation: Oddvar Moe IFEO APR 2018) Similar to debuggers, silent exit monitoring can be enabled through GFlags and/or by directly modifying IEFO and silent process exit Registry values in <code>HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SilentProcessExit\</code>. (Citation: Microsoft Silent Process Exit NOV 2017) (Citation: Oddvar Moe IFEO APR 2018)

Similar to [Accessibility Features](https://attack.mitre.org/techniques/T1546/008), on Windows Vista and later as well as Windows Server 2008 and later, a Registry key may be modified that configures "cmd.exe," or another program that provides backdoor access, as a "debugger" for an accessibility program (ex: utilman.exe). After the Registry is modified, pressing the appropriate key combination at the login screen while at the keyboard or when connected with [Remote Desktop Protocol](https://attack.mitre.org/techniques/T1021/001) will cause the "debugger" program to be executed with SYSTEM privileges. (Citation: Tilbury 2014)

Similar to [Process Injection](https://attack.mitre.org/techniques/T1055), these values may also be abused to obtain privilege escalation by causing a malicious executable to be loaded and run in the context of separate processes on the computer. (Citation: Endgame Process Injection July 2017) Installing IFEO mechanisms may also provide Persistence via continuous triggered invocation.

Malware may also use IFEO to [Impair Defenses](https://attack.mitre.org/techniques/T1562) by registering invalid debuggers that redirect and effectively disable various system and security applications. (Citation: FSecure Hupigon) (Citation: Symantec Ushedix June 2008)
T1546.011 | Application Shimming | Adversaries may establish persistence and/or elevate privileges by executing malicious content triggered by application shims. The Microsoft Windows Application Compatibility Infrastructure/Framework (Application Shim) was created to allow for backward compatibility of software as the operating system codebase changes over time. For example, the application shimming feature allows developers to apply fixes to applications (without rewriting code) that were created for Windows XP so that it will work with Windows 10. (Citation: Endgame Process Injection July 2017)

Within the framework, shims are created to act as a buffer between the program (or more specifically, the Import Address Table) and the Windows OS. When a program is executed, the shim cache is referenced to determine if the program requires the use of the shim database (.sdb). If so, the shim database uses hooking to redirect the code as necessary in order to communicate with the OS. 

A list of all shims currently installed by the default Windows installer (sdbinst.exe) is kept in:

* <code>%WINDIR%\AppPatch\sysmain.sdb</code> and
* <code>hklm\software\microsoft\windows nt\currentversion\appcompatflags\installedsdb</code>

Custom databases are stored in:

* <code>%WINDIR%\AppPatch\custom & %WINDIR%\AppPatch\AppPatch64\Custom</code> and
* <code>hklm\software\microsoft\windows nt\currentversion\appcompatflags\custom</code>

To keep shims secure, Windows designed them to run in user mode so they cannot modify the kernel and you must have administrator privileges to install a shim. However, certain shims can be used to [Bypass User Access Control](https://attack.mitre.org/techniques/T1548/002) (UAC and RedirectEXE), inject DLLs into processes (InjectDLL), disable Data Execution Prevention (DisableNX) and Structure Exception Handling (DisableSEH), and intercept memory addresses (GetProcAddress).

Utilizing these shims may allow an adversary to perform several malicious acts such as elevate privileges, install backdoors, disable defenses like Windows Defender, etc. (Citation: FireEye Application Shimming) Shims can also be abused to establish persistence by continuously being invoked by affected programs.
T1547.002 | Authentication Package | Adversaries may abuse authentication packages to execute DLLs when the system boots. Windows authentication package DLLs are loaded by the Local Security Authority (LSA) process at system start. They provide support for multiple logon processes and multiple security protocols to the operating system. (Citation: MSDN Authentication Packages)

Adversaries can use the autostart mechanism provided by LSA authentication packages for persistence by placing a reference to a binary in the Windows Registry location <code>HKLM\SYSTEM\CurrentControlSet\Control\Lsa\</code> with the key value of <code>"Authentication Packages"=&lt;target binary&gt;</code>. The binary will then be executed by the system when the authentication packages are loaded.
T1546.010 | AppInit DLLs | Adversaries may establish persistence and/or elevate privileges by executing malicious content triggered by AppInit DLLs loaded into processes. Dynamic-link libraries (DLLs) that are specified in the <code>AppInit_DLLs</code> value in the Registry keys <code>HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Windows</code> or <code>HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows</code> are loaded by user32.dll into every process that loads user32.dll. In practice this is nearly every program, since user32.dll is a very common library. (Citation: Endgame Process Injection July 2017)

Similar to Process Injection, these values can be abused to obtain elevated privileges by causing a malicious DLL to be loaded and run in the context of separate processes on the computer. (Citation: AppInit Registry) Malicious AppInit DLLs may also provide persistence by continuously being triggered by API activity. 

The AppInit DLL functionality is disabled in Windows 8 and later versions when secure boot is enabled. (Citation: AppInit Secure Boot)
T1546.009 | AppCert DLLs | Adversaries may establish persistence and/or elevate privileges by executing malicious content triggered by AppCert DLLs loaded into processes. Dynamic-link libraries (DLLs) that are specified in the <code>AppCertDLLs</code> Registry key under <code>HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\</code> are loaded into every process that calls the ubiquitously used application programming interface (API) functions <code>CreateProcess</code>, <code>CreateProcessAsUser</code>, <code>CreateProcessWithLoginW</code>, <code>CreateProcessWithTokenW</code>, or <code>WinExec</code>. (Citation: Endgame Process Injection July 2017)

Similar to [Process Injection](https://attack.mitre.org/techniques/T1055), this value can be abused to obtain elevated privileges by causing a malicious DLL to be loaded and run in the context of separate processes on the computer. Malicious AppCert DLLs may also provide persistence by continuously being triggered by API activity. 
T1546.008 | Accessibility Features | Adversaries may establish persistence and/or elevate privileges by executing malicious content triggered by accessibility features. Windows contains accessibility features that may be launched with a key combination before a user has logged in (ex: when the user is on the Windows logon screen). An adversary can modify the way these programs are launched to get a command prompt or backdoor without logging in to the system.

Two common accessibility programs are <code>C:\Windows\System32\sethc.exe</code>, launched when the shift key is pressed five times and <code>C:\Windows\System32\utilman.exe</code>, launched when the Windows + U key combination is pressed. The sethc.exe program is often referred to as "sticky keys", and has been used by adversaries for unauthenticated access through a remote desktop login screen. (Citation: FireEye Hikit Rootkit)

Depending on the version of Windows, an adversary may take advantage of these features in different ways. Common methods used by adversaries include replacing accessibility feature binaries or pointers/references to these binaries in the Registry. In newer versions of Windows, the replaced binary needs to be digitally signed for x64 systems, the binary must reside in <code>%systemdir%\</code>, and it must be protected by Windows File or Resource Protection (WFP/WRP). (Citation: DEFCON2016 Sticky Keys) The [Image File Execution Options Injection](https://attack.mitre.org/techniques/T1546/012) debugger method was likely discovered as a potential workaround because it does not require the corresponding accessibility feature binary to be replaced.

For simple binary replacement on Windows XP and later as well as and Windows Server 2003/R2 and later, for example, the program (e.g., <code>C:\Windows\System32\utilman.exe</code>) may be replaced with "cmd.exe" (or another program that provides backdoor access). Subsequently, pressing the appropriate key combination at the login screen while sitting at the keyboard or when connected over [Remote Desktop Protocol](https://attack.mitre.org/techniques/T1021/001) will cause the replaced file to be executed with SYSTEM privileges. (Citation: Tilbury 2014)

Other accessibility features exist that may also be leveraged in a similar fashion: (Citation: DEFCON2016 Sticky Keys)(Citation: Narrator Accessibility Abuse)

* On-Screen Keyboard: <code>C:\Windows\System32\osk.exe</code>
* Magnifier: <code>C:\Windows\System32\Magnify.exe</code>
* Narrator: <code>C:\Windows\System32\Narrator.exe</code>
* Display Switcher: <code>C:\Windows\System32\DisplaySwitch.exe</code>
* App Switcher: <code>C:\Windows\System32\AtBroker.exe</code>
T1546.007 | Netsh Helper DLL | Adversaries may establish persistence by executing malicious content triggered by Netsh Helper DLLs. Netsh.exe (also referred to as Netshell) is a command-line scripting utility used to interact with the network configuration of a system. It contains functionality to add helper DLLs for extending functionality of the utility. (Citation: TechNet Netsh) The paths to registered netsh.exe helper DLLs are entered into the Windows Registry at <code>HKLM\SOFTWARE\Microsoft\Netsh</code>.

Adversaries can use netsh.exe helper DLLs to trigger execution of arbitrary code in a persistent manner. This execution would take place anytime netsh.exe is executed, which could happen automatically, with another persistence technique, or if other software (ex: VPN) is present on the system that executes netsh.exe as part of its normal functionality. (Citation: Github Netsh Helper CS Beacon)(Citation: Demaske Netsh Persistence)
T1546.006 | LC_LOAD_DYLIB Addition | Adversaries may establish persistence by executing malicious content triggered by the execution of tainted binaries. Mach-O binaries have a series of headers that are used to perform certain operations when a binary is loaded. The LC_LOAD_DYLIB header in a Mach-O binary tells macOS and OS X which dynamic libraries (dylibs) to load during execution time. These can be added ad-hoc to the compiled binary as long as adjustments are made to the rest of the fields and dependencies. (Citation: Writing Bad Malware for OSX) There are tools available to perform these changes.

Adversaries may modify Mach-O binary headers to load and execute malicious dylibs every time the binary is executed. Although any changes will invalidate digital signatures on binaries because the binary is being modified, this can be remediated by simply removing the LC_CODE_SIGNATURE command from the binary so that the signature isn’t checked at load time. (Citation: Malware Persistence on OS X)
T1546.005 | Trap | Adversaries may establish persistence by executing malicious content triggered by an interrupt signal. The <code>trap</code> command allows programs and shells to specify commands that will be executed upon receiving interrupt signals. A common situation is a script allowing for graceful termination and handling of common keyboard interrupts like <code>ctrl+c</code> and <code>ctrl+d</code>.

Adversaries can use this to register code to be executed when the shell encounters specific interrupts as a persistence mechanism. Trap commands are of the following format <code>trap 'command list' signals</code> where "command list" will be executed when "signals" are received.(Citation: Trap Manual)(Citation: Cyberciti Trap Statements)
T1546.004 | .bash_profile and .bashrc | Adversaries may establish persistence by executing malicious content triggered by a user’s shell. <code>~/.bash_profile</code> and <code>~/.bashrc</code> are shell scripts that contain shell commands. These files are executed in a user's context when a new shell opens or when a user logs in so that their environment is set correctly.

<code>~/.bash_profile</code> is executed for login shells and <code>~/.bashrc</code> is executed for interactive non-login shells. This means that when a user logs in (via username and password) to the console (either locally or remotely via something like SSH), the <code>~/.bash_profile</code> script is executed before the initial command prompt is returned to the user. After that, every time a new shell is opened, the <code>~/.bashrc</code> script is executed. This allows users more fine-grained control over when they want certain commands executed. These shell scripts are meant to be written to by the local user to configure their own environment.

The macOS Terminal.app is a little different in that it runs a login shell by default each time a new terminal window is opened, thus calling <code>~/.bash_profile</code> each time instead of <code>~/.bashrc</code>.

Adversaries may abuse these shell scripts by inserting arbitrary shell commands that may be used to execute other binaries to gain persistence. Every time the user logs in or opens a new shell, the modified ~/.bash_profile and/or ~/.bashrc scripts will be executed.(Citation: amnesia malware)
T1546.003 | Windows Management Instrumentation Event Subscription | Adversaries may establish persistence and elevate privileges by executing malicious content triggered by a Windows Management Instrumentation (WMI) event subscription. WMI can be used to install event filters, providers, consumers, and bindings that execute code when a defined event occurs. Examples of events that may be subscribed to are the wall clock time, user loging, or the computer's uptime. (Citation: Mandiant M-Trends 2015)

Adversaries may use the capabilities of WMI to subscribe to an event and execute arbitrary code when that event occurs, providing persistence on a system. (Citation: FireEye WMI SANS 2015) (Citation: FireEye WMI 2015) Adversaries may also compile WMI scripts into Windows Management Object (MOF) files (.mof extension) that can be used to create a malicious subscription. (Citation: Dell WMI Persistence) (Citation: Microsoft MOF May 2018)

WMI subscription execution is proxied by the WMI Provider Host process (WmiPrvSe.exe) and thus may result in elevated SYSTEM privileges.
T1546.002 | Screensaver | Adversaries may establish persistence by executing malicious content triggered by user inactivity. Screensavers are programs that execute after a configurable time of user inactivity and consist of Portable Executable (PE) files with a .scr file extension.(Citation: Wikipedia Screensaver) The Windows screensaver application scrnsave.scr is located in <code>C:\Windows\System32\</code>, and <code>C:\Windows\sysWOW64\</code>  on 64-bit Windows systems, along with screensavers included with base Windows installations.

The following screensaver settings are stored in the Registry (<code>HKCU\Control Panel\Desktop\</code>) and could be manipulated to achieve persistence:

* <code>SCRNSAVE.exe</code> - set to malicious PE path
* <code>ScreenSaveActive</code> - set to '1' to enable the screensaver
* <code>ScreenSaverIsSecure</code> - set to '0' to not require a password to unlock
* <code>ScreenSaveTimeout</code> - sets user inactivity timeout before screensaver is executed

Adversaries can use screensaver settings to maintain persistence by setting the screensaver to run malware after a certain timeframe of user inactivity. (Citation: ESET Gazer Aug 2017)
T1546.001 | Change Default File Association | Adversaries may establish persistence by executing malicious content triggered by a file type association. When a file is opened, the default program used to open the file (also called the file association or handler) is checked. File association selections are stored in the Windows Registry and can be edited by users, administrators, or programs that have Registry access (Citation: Microsoft Change Default Programs) (Citation: Microsoft File Handlers) or by administrators using the built-in assoc utility. (Citation: Microsoft Assoc Oct 2017) Applications can modify the file association for a given file extension to call an arbitrary program when a file with the given extension is opened.

System file associations are listed under <code>HKEY_CLASSES_ROOT\.[extension]</code>, for example <code>HKEY_CLASSES_ROOT\.txt</code>. The entries point to a handler for that extension located at <code>HKEY_CLASSES_ROOT\[handler]</code>. The various commands are then listed as subkeys underneath the shell key at <code>HKEY_CLASSES_ROOT\[handler]\shell\[action]\command</code>. For example: 
* <code>HKEY_CLASSES_ROOT\txtfile\shell\open\command</code>
* <code>HKEY_CLASSES_ROOT\txtfile\shell\print\command</code>
* <code>HKEY_CLASSES_ROOT\txtfile\shell\printto\command</code>

The values of the keys listed are commands that are executed when the handler opens the file extension. Adversaries can modify these values to continually execute arbitrary commands. (Citation: TrendMicro TROJ-FAKEAV OCT 2012)
T1547.001 | Registry Run Keys / Startup Folder | Adversaries may achieve persistence by adding a program to a startup folder or referencing it with a Registry run key. Adding an entry to the "run keys" in the Registry or startup folder will cause the program referenced to be executed when a user logs in. (Citation: Microsoft Run Key) These programs will be executed under the context of the user and will have the account's associated permissions level.

Placing a program within a startup folder will also cause that program to execute when a user logs in. There is a startup folder location for individual user accounts as well as a system-wide startup folder that will be checked regardless of which user account logs in. The startup folder path for the current user is <code>C:\Users\[Username]\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup</code>. The startup folder path for all users is <code>C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp</code>.

The following run keys are created by default on Windows systems:
* <code>HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run</code>
* <code>HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce</code>
* <code>HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run</code>
* <code>HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce</code>

The <code>HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnceEx</code> is also available but is not created by default on Windows Vista and newer. Registry run key entries can reference programs directly or list them as a dependency. (Citation: Microsoft RunOnceEx APR 2018) For example, it is possible to load a DLL at logon using a "Depend" key with RunOnceEx: <code>reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\0001\Depend /v 1 /d "C:\temp\evil[.]dll"</code> (Citation: Oddvar Moe RunOnceEx Mar 2018)

The following Registry keys can be used to set startup folder items for persistence:
* <code>HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders</code>
* <code>HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders</code>
* <code>HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders</code>
* <code>HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders</code>

The following Registry keys can control automatic startup of services during boot:
* <code>HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce</code>
* <code>HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce</code>
* <code>HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices</code>
* <code>HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServices</code>

Using policy settings to specify startup programs creates corresponding values in either of two Registry keys:
* <code>HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run</code>
* <code>HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run</code>

The Winlogon key controls actions that occur when a user logs on to a computer running Windows 7. Most of these actions are under the control of the operating system, but you can also add custom actions here. The <code>HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit</code> and <code>HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell</code> subkeys can automatically launch programs.

Programs listed in the load value of the registry key <code>HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows</code> run when any user logs on.

By default, the multistring <code>BootExecute</code> value of the registry key <code>HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager</code> is set to <code>autocheck autochk *</code>. This value causes Windows, at startup, to check the file-system integrity of the hard disks if the system has been shut down abnormally. Adversaries can add other programs or processes to this registry value which will automatically launch at boot.

Adversaries can use these configuration locations to execute malware, such as remote access tools, to maintain persistence through system reboots. Adversaries may also use [Masquerading](https://attack.mitre.org/techniques/T1036) to make the Registry entries look as if they are associated with legitimate programs.
T1547 | Boot or Logon Autostart Execution | Adversaries may configure system settings to automatically execute a program during system boot or logon to maintain persistence or gain higher-level privileges on compromised systems. Operating systems may have mechanisms for automatically running a program on system boot or account logon.(Citation: Microsoft Run Key)(Citation: MSDN Authentication Packages)(Citation: Microsoft TimeProvider)(Citation: Cylance Reg Persistence Sept 2013)(Citation: Linux Kernel Programming)  These mechanisms may include automatically executing programs that are placed in specially designated directories or are referenced by repositories that store configuration information, such as the Windows Registry. An adversary may achieve the same goal by modifying or extending features of the kernel.

Since some boot or logon autostart programs run with higher privileges, an adversary may leverage these to elevate privileges.
T1546 | Event Triggered Execution | Adversaries may establish persistence and/or elevate privileges using system mechanisms that trigger execution based on specific events. Various operating systems have means to monitor and subscribe to events such as logons or other user activity such as running specific applications/binaries. 

Adversaries may abuse these mechanisms as a means of maintaining persistent access to a victim via repeatedly executing malicious code. After gaining access to a victim system, adversaries may create/modify event triggers to point to malicious content that will be executed whenever the event trigger is invoked. 

Since the execution can be proxied by an account with higher permissions, such as SYSTEM or service accounts, an adversary may be able to abuse these triggered execution mechanisms to escalate their privileges. 
T1098.003 | Add Office 365 Global Administrator Role | An adversary may add the Global Administrator role to an adversary-controlled account to maintain persistent access to an Office 365 tenant.(Citation: Microsoft Support O365 Add Another Admin, October 2019)(Citation: Microsoft O365 Admin Roles) With sufficient permissions, a compromised account can gain almost unlimited access to data and settings (including the ability to reset the passwords of other admins) via the global admin role.(Citation: Microsoft O365 Admin Roles) 

This account modification may immediately follow [Create Account](https://attack.mitre.org/techniques/T1136) or other malicious account activity.
T1098.002 | Exchange Email Delegate Permissions | Adversaries may grant additional permission levels, such as ReadPermission or FullAccess, to maintain persistent access to an adversary-controlled email account. The <code>Add-MailboxPermission</code> [PowerShell](https://attack.mitre.org/techniques/T1059/001) cmdlet, available in on-premises Exchange and in the cloud-based service Office 365, adds permissions to a mailbox.(Citation: Microsoft - Add-MailboxPermission)(Citation: FireEye APT35 2018)(Citation: Crowdstrike Hiding in Plain Sight 2018)

This may be used in persistent threat incidents as well as BEC (Business Email Compromise) incidents where an adversary can assign more access rights to the accounts they wish to compromise. This may further enable use of additional techniques for gaining access to systems. For example, compromised business accounts are often used to send messages to other accounts in the network of the target business while creating inbox rules (ex: [Internal Spearphishing](https://attack.mitre.org/techniques/T1534)), so the messages evade spam/phishing detection mechanisms.(Citation: Bienstock, D. - Defending O365 - 2019)
T1098.001 | Additional Azure Service Principal Credentials | Adversaries may add adversary-controlled credentials for Azure Service Principals in addition to existing legitimate credentials(Citation: Create Azure Service Principal) to maintain persistent access to victim Azure accounts.(Citation: Blue Cloud of Death)(Citation: Blue Cloud of Death Video) Azure Service Principals support both password and certificate credentials.(Citation: Why AAD Service Principals) With sufficient permissions, there are a variety of ways to add credentials including the Azure Portal, Azure command line interface, and Azure or Az [PowerShell](https://attack.mitre.org/techniques/T1059/001) modules.(Citation: Demystifying Azure AD Service Principals)
T1543.004 | Launch Daemon | Adversaries may create or modify launch daemons to repeatedly execute malicious payloads as part of persistence. Per Apple’s developer documentation, when macOS and OS X boot up, launchd is run to finish system initialization. This process loads the parameters for each launch-on-demand system-level daemon from the property list (plist) files found in <code>/System/Library/LaunchDaemons</code> and <code>/Library/LaunchDaemons</code> (Citation: AppleDocs Launch Agent Daemons). These LaunchDaemons have property list files which point to the executables that will be launched (Citation: Methods of Mac Malware Persistence). 

Adversaries may install a new launch daemon that can be configured to execute at startup by using launchd or launchctl to load a plist into the appropriate directories  (Citation: OSX Malware Detection). The daemon name may be disguised by using a name from a related operating system or benign software (Citation: WireLurker). Launch Daemons may be created with administrator privileges, but are executed under root privileges, so an adversary may also use a service to escalate privileges from administrator to root. 

The plist file permissions must be root:wheel, but the script or program that it points to has no such requirement. So, it is possible for poor configurations to allow an adversary to modify a current Launch Daemon’s executable and gain persistence or Privilege Escalation. 
T1543.003 | Windows Service | Adversaries may create or modify Windows services to repeatedly execute malicious payloads as part of persistence. When Windows boots up, it starts programs or applications called services that perform background system functions.(Citation: TechNet Services) Windows service configuration information, including the file path to the service's executable or recovery programs/commands, is stored in the Windows Registry. Service configurations can be modified using utilities such as sc.exe and [Reg](https://attack.mitre.org/software/S0075). 

Adversaries may install a new service or modify an existing service by using system utilities to interact with services, by directly modifying the Registry, or by using custom tools to interact with the Windows API. Adversaries may configure services to execute at startup in order to persist on a system.

An adversary may also incorporate [Masquerading](https://attack.mitre.org/techniques/T1036) by using a service name from a related operating system or benign software, or by modifying existing services to make detection analysis more challenging. Modifying existing services may interrupt their functionality or may enable services that are disabled or otherwise not commonly used. 

Services may be created with administrator privileges but are executed under SYSTEM privileges, so an adversary may also use a service to escalate privileges from administrator to SYSTEM. Adversaries may also directly start services through [Service Execution](https://attack.mitre.org/techniques/T1569/002). 
T1543.002 | Systemd Service | Adversaries may create or modify systemd services to repeatedly execute malicious payloads as part of persistence. The systemd service manager is commonly used for managing background daemon processes (also known as services) and other system resources.(Citation: Linux man-pages: systemd January 2014)(Citation: Freedesktop.org Linux systemd 29SEP2018) Systemd is the default initialization (init) system on many Linux distributions starting with Debian 8, Ubuntu 15.04, CentOS 7, RHEL 7, Fedora 15, and replaces legacy init systems including SysVinit and Upstart while remaining backwards compatible with the aforementioned init systems.

Systemd utilizes configuration files known as service units to control how services boot and under what conditions. By default, these unit files are stored in the <code>/etc/systemd/system</code> and <code>/usr/lib/systemd/system</code> directories and have the file extension <code>.service</code>. Each service unit file may contain numerous directives that can execute system commands:

* ExecStart, ExecStartPre, and ExecStartPost directives cover execution of commands when a services is started manually by 'systemctl' or on system start if the service is set to automatically start. 
* ExecReload directive covers when a service restarts. 
* ExecStop and ExecStopPost directives cover when a service is stopped or manually by 'systemctl'.

Adversaries have used systemd functionality to establish persistent access to victim systems by creating and/or modifying service unit files that cause systemd to execute malicious commands at recurring intervals, such as at system boot.(Citation: Anomali Rocke March 2019)(Citation: gist Arch package compromise 10JUL2018)(Citation: Arch Linux Package Systemd Compromise BleepingComputer 10JUL2018)(Citation: acroread package compromised Arch Linux Mail 8JUL2018)

While adversaries typically require root privileges to create/modify service unit files in the <code>/etc/systemd/system</code> and <code>/usr/lib/systemd/system</code> directories, low privilege users can create/modify service unit files in directories such as <code>~/.config/systemd/user/</code> to achieve user-level persistence.(Citation: Rapid7 Service Persistence 22JUNE2016)
T1543.001 | Launch Agent | Adversaries may create or modify launch agents to repeatedly execute malicious payloads as part of persistence. Per Apple’s developer documentation, when a user logs in, a per-user launchd process is started which loads the parameters for each launch-on-demand user agent from the property list (plist) files found in <code>/System/Library/LaunchAgents</code>, <code>/Library/LaunchAgents</code>, and <code>$HOME/Library/LaunchAgents</code> (Citation: AppleDocs Launch Agent Daemons) (Citation: OSX Keydnap malware) (Citation: Antiquated Mac Malware). These launch agents have property list files which point to the executables that will be launched (Citation: OSX.Dok Malware).
 
Adversaries may install a new launch agent that can be configured to execute at login by using launchd or launchctl to load a plist into the appropriate directories  (Citation: Sofacy Komplex Trojan)  (Citation: Methods of Mac Malware Persistence). The agent name may be disguised by using a name from a related operating system or benign software. Launch Agents are created with user level privileges and are executed with the privileges of the user when they log in (Citation: OSX Malware Detection) (Citation: OceanLotus for OS X). They can be set up to execute when a specific user logs in (in the specific user’s directory structure) or when any user logs in (which requires administrator privileges).
T1037.005 | Startup Items | Adversaries may use startup items automatically executed at boot initialization to establish persistence. Startup items execute during the final phase of the boot process and contain shell scripts or other executable files along with configuration information used by the system to determine the execution order for all startup items. (Citation: Startup Items)

This is technically a deprecated technology (superseded by [Launch Daemon](https://attack.mitre.org/techniques/T1543/004)), and thus the appropriate folder, <code>/Library/StartupItems</code> isn’t guaranteed to exist on the system by default, but does appear to exist by default on macOS Sierra. A startup item is a directory whose executable and configuration property list (plist), <code>StartupParameters.plist</code>, reside in the top-level directory. 

An adversary can create the appropriate folders/files in the StartupItems directory to register their own persistence mechanism (Citation: Methods of Mac Malware Persistence). Additionally, since StartupItems run during the bootup phase of macOS, they will run as the elevated root user.
T1037.004 | Rc.common | Adversaries may use rc.common automatically executed at boot initialization to establish persistence. During the boot process, macOS executes <code>source /etc/rc.common</code>, which is a shell script containing various utility functions. This file also defines routines for processing command-line arguments and for gathering system settings and is thus recommended to include in the start of Startup Item Scripts (Citation: Startup Items). In macOS and OS X, this is now a deprecated mechanism in favor of [Launch Agent](https://attack.mitre.org/techniques/T1543/001) and [Launch Daemon](https://attack.mitre.org/techniques/T1543/004) but is currently still used.

Adversaries can use the rc.common file as a way to hide code for persistence that will execute on each reboot as the root user. (Citation: Methods of Mac Malware Persistence)
T1037.003 | Network Logon Script | Adversaries may use network logon scripts automatically executed at logon initialization to establish persistence. Network logon scripts can be assigned using Active Directory or Group Policy Objects.(Citation: Petri Logon Script AD) These logon scripts run with the privileges of the user they are assigned to. Depending on the systems within the network, initializing one of these scripts could apply to more than one or potentially all systems.  
 
Adversaries may use these scripts to maintain persistence on a network. Depending on the access configuration of the logon scripts, either local credentials or an administrator account may be necessary.
T1543 | Create or Modify System Process | Adversaries may create or modify system-level processes to repeatedly execute malicious payloads as part of persistence. When operating systems boot up, they can start processes that perform background system functions. On Windows and Linux, these system processes are referred to as services. (Citation: TechNet Services) On macOS, launchd processes known as [Launch Daemon](https://attack.mitre.org/techniques/T1543/004) and [Launch Agent](https://attack.mitre.org/techniques/T1543/001) are run to finish system initialization and load user specific parameters.(Citation: AppleDocs Launch Agent Daemons) 

Adversaries may install new services, daemons, or agents that can be configured to execute at startup or a repeatable interval in order to establish persistence. Similarly, adversaries may modify existing services, daemons, or agents to achieve the same effect.  

Services, daemons, or agents may be created with administrator privileges but executed under root/SYSTEM privileges. Adversaries may leverage this functionality to create or modify system processes in order to escalate privileges. (Citation: OSX Malware Detection).  
T1037.002 | Logon Script (Mac) | Adversaries may use macOS logon scripts automatically executed at logon initialization to establish persistence. macOS allows logon scripts (known as login hooks) to be executed whenever a specific user logs into a system. A login hook tells Mac OS X to execute a certain script when a user logs in, but unlike [Startup Items](https://attack.mitre.org/techniques/T1037/005), a login hook executes as the elevated root user.(Citation: creating login hook)

Adversaries may use these login hooks to maintain persistence on a single system.(Citation: S1 macOs Persistence) Access to login hook scripts may allow an adversary to insert additional malicious code. There can only be one login hook at a time though and depending on the access configuration of the hooks, either local credentials or an administrator account may be necessary. 
T1037.001 | Logon Script (Windows) | Adversaries may use Windows logon scripts automatically executed at logon initialization to establish persistence. Windows allows logon scripts to be run whenever a specific user or group of users log into a system.(Citation: TechNet Logon Scripts) This is done via adding a path to a script to the <code>HKCU\Environment\UserInitMprLogonScript</code> Registry key.(Citation: Hexacorn Logon Scripts)

Adversaries may use these scripts to maintain persistence on a single system. Depending on the access configuration of the logon scripts, either local credentials or an administrator account may be necessary. 
T1542.003 | Bootkit | Adversaries may use bootkits to persist on systems. Bootkits reside at a layer below the operating system and may make it difficult to perform full remediation unless an organization suspects one was used and can act accordingly.

A bootkit is a malware variant that modifies the boot sectors of a hard drive, including the Master Boot Record (MBR) and Volume Boot Record (VBR). (Citation: Mandiant M Trends 2016) The MBR is the section of disk that is first loaded after completing hardware initialization by the BIOS. It is the location of the boot loader. An adversary who has raw access to the boot drive may overwrite this area, diverting execution during startup from the normal boot loader to adversary code. (Citation: Lau 2011)

The MBR passes control of the boot process to the VBR. Similar to the case of MBR, an adversary who has raw access to the boot drive may overwrite the VBR to divert execution during startup to adversary code.
T1542.002 | Component Firmware | Adversaries may modify component firmware to persist on systems. Some adversaries may employ sophisticated means to compromise computer components and install malicious firmware that will execute adversary code outside of the operating system and main system firmware or BIOS. This technique may be similar to [System Firmware](https://attack.mitre.org/techniques/T1542/001) but conducted upon other system components/devices that may not have the same capability or level of integrity checking.

Malicious component firmware could provide both a persistent level of access to systems despite potential typical failures to maintain access and hard disk re-images, as well as a way to evade host software-based defenses and integrity checks.
T1542.001 | System Firmware | Adversaries may modify system firmware to persist on systems.The BIOS (Basic Input/Output System) and The Unified Extensible Firmware Interface (UEFI) or Extensible Firmware Interface (EFI) are examples of system firmware that operate as the software interface between the operating system and hardware of a computer. (Citation: Wikipedia BIOS) (Citation: Wikipedia UEFI) (Citation: About UEFI)

System firmware like BIOS and (U)EFI underly the functionality of a computer and may be modified by an adversary to perform or assist in malicious activity. Capabilities exist to overwrite the system firmware, which may give sophisticated adversaries a means to install malicious firmware updates as a means of persistence on a system that may be difficult to detect.
T1505.003 | Web Shell | Adversaries may backdoor web servers with web shells to establish persistent access to systems. A Web shell is a Web script that is placed on an openly accessible Web server to allow an adversary to use the Web server as a gateway into a network. A Web shell may provide a set of functions to execute or a command-line interface on the system that hosts the Web server.

In addition to a server-side script, a Web shell may have a client interface program that is used to talk to the Web server (ex: [China Chopper](https://attack.mitre.org/software/S0020) Web shell client).(Citation: Lee 2013) 
T1505.002 | Transport Agent | Adversaries may abuse Microsoft transport agents to establish persistent access to systems. Microsoft Exchange transport agents can operate on email messages passing through the transport pipeline to perform various tasks such as filtering spam, filtering malicious attachments, journaling, or adding a corporate signature to the end of all outgoing emails.(Citation: Microsoft TransportAgent Jun 2016)(Citation: ESET LightNeuron May 2019) Transport agents can be written by application developers and then compiled to .NET assemblies that are subsequently registered with the Exchange server. Transport agents will be invoked during a specified stage of email processing and carry out developer defined tasks. 

Adversaries may register a malicious transport agent to provide a persistence mechanism in Exchange Server that can be triggered by adversary-specified email events.(Citation: ESET LightNeuron May 2019) Though a malicious transport agent may be invoked for all emails passing through the Exchange transport pipeline, the agent can be configured to only carry out specific tasks in response to adversary defined criteria. For example, the transport agent may only carry out an action like copying in-transit attachments and saving them for later exfiltration if the recipient email address matches an entry on a list provided by the adversary. 
T1505.001 | SQL Stored Procedures | Adversaries may abuse SQL stored procedures to establish persistent access to systems. SQL Stored Procedures are code that can be saved and reused so that database users do not waste time rewriting frequently used SQL queries. Stored procedures can be invoked via SQL statements to the database using the procedure name or via defined events (e.g. when a SQL server application is started/restarted).

Adversaries may craft malicious stored procedures that can provide a persistence mechanism in SQL database servers.(Citation: NetSPI Startup Stored Procedures)(Citation: Kaspersky MSSQL Aug 2019) To execute operating system commands through SQL syntax the adversary may have to enable additional functionality, such as xp_cmdshell for MSSQL Server.(Citation: NetSPI Startup Stored Procedures)(Citation: Kaspersky MSSQL Aug 2019)(Citation: Microsoft xp_cmdshell 2017) 

Microsoft SQL Server can enable common language runtime (CLR) integration. With CLR integration enabled, application developers can write stored procedures using any .NET framework language (e.g. VB .NET, C#, etc.).(Citation: Microsoft CLR Integration 2017) Adversaries may craft or modify CLR assemblies that are linked to stored procedures since these CLR assemblies can be made to execute arbitrary commands.(Citation: NetSPI SQL Server CLR) 
T1053.003 | Cron | Adversaries may abuse the <code>cron</code> utility to perform task scheduling for initial or recurring execution of malicious code. The <code>cron</code> utility is a time-based job scheduler for Unix-like operating systems.  The <code> crontab</code> file contains the schedule of cron entries to be run and the specified times for execution. Any <code>crontab</code> files are stored in operating system-specific file paths.

An adversary may use <code>cron</code> in Linux or Unix environments to execute programs at system startup or on a scheduled basis for persistence. <code>cron</code> can also be abused to conduct remote Execution as part of Lateral Movement and or to run a process under the context of a specified account.
T1053.004 | Launchd | Adversaries may abuse the <code>Launchd</code> daemon to perform task scheduling for initial or recurring execution of malicious code. The <code>launchd</code> daemon, native to macOS, is responsible for loading and maintaining services within the operating system. This process loads the parameters for each launch-on-demand system-level daemon from the property list (plist) files found in <code>/System/Library/LaunchDaemons</code> and <code>/Library/LaunchDaemons</code> (Citation: AppleDocs Launch Agent Daemons). These LaunchDaemons have property list files which point to the executables that will be launched (Citation: Methods of Mac Malware Persistence).

An adversary may use the <code>launchd</code> daemon in macOS environments to schedule new executables to run at system startup or on a scheduled basis for persistence. <code>launchd</code> can also be abused to run a process under the context of a specified account. Daemons, such as <code>launchd</code>, run with the permissions of the root user account, and will operate regardless of which user account is logged in.
T1053.001 | At (Linux) | Adversaries may abuse the [at](https://attack.mitre.org/software/S0110) utility to perform task scheduling for initial or recurring execution of malicious code. The [at](https://attack.mitre.org/software/S0110) command within Linux operating systems enables administrators to schedule tasks.(Citation: Kifarunix - Task Scheduling in Linux)

An adversary may use [at](https://attack.mitre.org/software/S0110) in Linux environments to execute programs at system startup or on a scheduled basis for persistence. [at](https://attack.mitre.org/software/S0110) can also be abused to conduct remote Execution as part of Lateral Movement and or to run a process under the context of a specified account.
T1053.005 | Scheduled Task | Adversaries may abuse the Windows Task Scheduler to perform task scheduling for initial or recurring execution of malicious code. There are multiple ways to access the Task Scheduler in Windows. The <code>schtasks</code> can be run directly on the command line, or the Task Scheduler can be opened through the GUI within the Administrator Tools section of the Control Panel. In some cases, adversaries have used a .NET wrapper for the Windows Task Scheduler, and alternatively, adversaries have used the Windows netapi32 library to create a scheduled task.

The deprecated [at](https://attack.mitre.org/software/S0110) utility could also be abused by adversaries (ex: [At (Windows)](https://attack.mitre.org/techniques/T1053/002)), though <code>at.exe</code> can not access tasks created with <code>schtasks</code> or the Control Panel.

An adversary may use Windows Task Scheduler to execute programs at system startup or on a scheduled basis for persistence. The Windows Task Scheduler can also be abused to conduct remote Execution as part of Lateral Movement and or to run a process under the context of a specified account (such as SYSTEM).
T1053.002 | At (Windows) | Adversaries may abuse the <code>at.exe</code> utility to perform task scheduling for initial or recurring execution of malicious code. The [at](https://attack.mitre.org/software/S0110) utility exists as an executable within Windows for scheduling tasks at a specified time and date. Using [at](https://attack.mitre.org/software/S0110) requires that the Task Scheduler service be running, and the user to be logged on as a member of the local Administrators group. 

An adversary may use <code>at.exe</code> in Windows environments to execute programs at system startup or on a scheduled basis for persistence. [at](https://attack.mitre.org/software/S0110) can also be abused to conduct remote Execution as part of Lateral Movement and or to run a process under the context of a specified account (such as SYSTEM).

Note: The <code>at.exe</code> command line utility has been deprecated in current versions of Windows in favor of <code>schtasks</code>.
T1542 | Pre-OS Boot | Adversaries may abuse Pre-OS Boot mechanisms as a way to establish persistence on a system. During the booting process of a computer, firmware and various startup services are loaded before the operating system. These programs control flow of execution before the operating system takes control.(Citation: Wikipedia Booting)

Adversaries may overwrite data in boot drivers or firmware such as BIOS (Basic Input/Output System) and The Unified Extensible Firmware Interface (UEFI) to persist on systems at a layer below the operating system. This can be particularly difficult to detect as malware at this level will not be detected by host software-based defenses.
T1137.001 | Office Template Macros | Adversaries may abuse Microsoft Office templates to obtain persistence on a compromised system. Microsoft Office contains templates that are part of common Office applications and are used to customize styles. The base templates within the application are used each time an application starts. (Citation: Microsoft Change Normal Template)

Office Visual Basic for Applications (VBA) macros (Citation: MSDN VBA in Office) can be inserted into the base template and used to execute code when the respective Office application starts in order to obtain persistence. Examples for both Word and Excel have been discovered and published. By default, Word has a Normal.dotm template created that can be modified to include a malicious macro. Excel does not have a template file created by default, but one can be added that will automatically be loaded.(Citation: enigma0x3 normal.dotm)(Citation: Hexacorn Office Template Macros) Shared templates may also be stored and pulled from remote locations.(Citation: GlobalDotName Jun 2019) 

Word Normal.dotm location:<br>
<code>C:\Users\&lt;username&gt;\AppData\Roaming\Microsoft\Templates\Normal.dotm</code>

Excel Personal.xlsb location:<br>
<code>C:\Users\&lt;username&gt;\AppData\Roaming\Microsoft\Excel\XLSTART\PERSONAL.XLSB</code>

Adversaries may also change the location of the base template to point to their own by hijacking the application's search order, e.g. Word 2016 will first look for Normal.dotm under <code>C:\Program Files (x86)\Microsoft Office\root\Office16\</code>, or by modifying the GlobalDotName registry key. By modifying the GlobalDotName registry key an adversary can specify an arbitrary location, file name, and file extension to use for the template that will be loaded on application startup. To abuse GlobalDotName, adversaries may first need to register the template as a trusted document or place it in a trusted location.(Citation: GlobalDotName Jun 2019) 

An adversary may need to enable macros to execute unrestricted depending on the system or enterprise security policy on use of macros.
T1137.004 | Outlook Home Page | Adversaries may abuse Microsoft Outlook's Home Page feature to obtain persistence on a compromised system. Outlook Home Page is a legacy feature used to customize the presentation of Outlook folders. This feature allows for an internal or external URL to be loaded and presented whenever a folder is opened. A malicious HTML page can be crafted that will execute code when loaded by Outlook Home Page.(Citation: SensePost Outlook Home Page)

Once malicious home pages have been added to the user’s mailbox, they will be loaded when Outlook is started. Malicious Home Pages will execute when the right Outlook folder is loaded/reloaded.(Citation: SensePost Outlook Home Page)

T1137.003 | Outlook Forms | Adversaries may abuse Microsoft Outlook forms to obtain persistence on a compromised system. Outlook forms are used as templates for presentation and functionality in Outlook messages. Custom Outlook forms can be created that will execute code when a specifically crafted email is sent by an adversary utilizing the same custom Outlook form.(Citation: SensePost Outlook Forms)

Once malicious forms have been added to the user’s mailbox, they will be loaded when Outlook is started. Malicious forms will execute when an adversary sends a specifically crafted email to the user.(Citation: SensePost Outlook Forms)
T1137.005 | Outlook Rules | Adversaries may abuse Microsoft Outlook rules to obtain persistence on a compromised system. Outlook rules allow a user to define automated behavior to manage email messages. A benign rule might, for example, automatically move an email to a particular folder in Outlook if it contains specific words from a specific sender. Malicious Outlook rules can be created that can trigger code execution when an adversary sends a specifically crafted email to that user.(Citation: SilentBreak Outlook Rules)

Once malicious rules have been added to the user’s mailbox, they will be loaded when Outlook is started. Malicious rules will execute when an adversary sends a specifically crafted email to the user.(Citation: SilentBreak Outlook Rules)
T1137.006 | Add-ins | Adversaries may abuse Microsoft Office add-ins to obtain persistence on a compromised system. Office add-ins can be used to add functionality to Office programs. (Citation: Microsoft Office Add-ins) There are different types of add-ins that can be used by the various Office products; including Word/Excel add-in Libraries (WLL/XLL), VBA add-ins, Office Component Object Model (COM) add-ins, automation add-ins, VBA Editor (VBE), Visual Studio Tools for Office (VSTO) add-ins, and Outlook add-ins. (Citation: MRWLabs Office Persistence Add-ins)(Citation: FireEye Mail CDS 2018)

Add-ins can be used to obtain persistence because they can be set to execute code when an Office application starts. 
T1137.002 | Office Test | Adversaries may abuse the Microsoft Office "Office Test" Registry key to obtain persistence on a compromised system. An Office Test Registry location exists that allows a user to specify an arbitrary DLL that will be executed every time an Office application is started. This Registry key is thought to be used by Microsoft to load DLLs for testing and debugging purposes while developing Office applications. This Registry key is not created by default during an Office installation.(Citation: Hexacorn Office Test)(Citation: Palo Alto Office Test Sofacy)

There exist user and global Registry keys for the Office Test feature:

* <code>HKEY_CURRENT_USER\Software\Microsoft\Office test\Special\Perf</code>
* <code>HKEY_LOCAL_MACHINE\Software\Microsoft\Office test\Special\Perf</code>

Adversaries may add this Registry key and specify a malicious DLL that will be executed whenever an Office application, such as Word or Excel, is started.
T1525 | Implant Container Image | Adversaries may implant cloud container images with malicious code to establish persistence. Amazon Web Service (AWS) Amazon Machine Images (AMI), Google Cloud Platform (GCP) Images, and Azure Images as well as popular container runtimes such as Docker can be implanted or backdoored. Depending on how the infrastructure is provisioned, this could provide persistent access if the infrastructure provisioning tool is instructed to always use the latest image.(Citation: Rhino Labs Cloud Image Backdoor Technique Sept 2019)

A tool has been developed to facilitate planting backdoors in cloud container images.(Citation: Rhino Labs Cloud Backdoor September 2019) If an attacker has access to a compromised AWS instance, and permissions to list the available container images, they may implant a backdoor such as a [Web Shell](https://attack.mitre.org/techniques/T1505/003).(Citation: Rhino Labs Cloud Image Backdoor Technique Sept 2019) Adversaries may also implant Docker images that may be inadvertently used in cloud deployments, which has been reported in some instances of cryptomining botnets.(Citation: ATT Cybersecurity Cryptocurrency Attacks on Cloud) 
T1505 | Server Software Component | Adversaries may abuse legitimate extensible development features of servers to establish persistent access to systems. Enterprise server applications may include features that allow developers to write and install software or scripts to extend the functionality of the main application. Adversaries may install malicious components to extend and abuse server applications.
T1197 | BITS Jobs | Adversaries may abuse BITS jobs to persistently execute or clean up after malicious payloads. Windows Background Intelligent Transfer Service (BITS) is a low-bandwidth, asynchronous file transfer mechanism exposed through [Component Object Model](https://attack.mitre.org/techniques/T1559/001) (COM). (Citation: Microsoft COM) (Citation: Microsoft BITS) BITS is commonly used by updaters, messengers, and other applications preferred to operate in the background (using available idle bandwidth) without interrupting other networked applications. File transfer tasks are implemented as BITS jobs, which contain a queue of one or more file operations.

The interface to create and manage BITS jobs is accessible through [PowerShell](https://attack.mitre.org/techniques/T1059/001)  (Citation: Microsoft BITS) and the [BITSAdmin](https://attack.mitre.org/software/S0190) tool. (Citation: Microsoft BITSAdmin)

Adversaries may abuse BITS to download, execute, and even clean up after running malicious code. BITS tasks are self-contained in the BITS job database, without new files or registry modifications, and often permitted by host firewalls. (Citation: CTU BITS Malware June 2016) (Citation: Mondok Windows PiggyBack BITS May 2007) (Citation: Symantec BITS May 2007) BITS enabled execution may also enable persistence by creating long-standing jobs (the default maximum lifetime is 90 days and extendable) or invoking an arbitrary program when a job completes or errors (including after system reboots). (Citation: PaloAlto UBoatRAT Nov 2017) (Citation: CTU BITS Malware June 2016)

BITS upload functionalities can also be used to perform [Exfiltration Over Alternative Protocol](https://attack.mitre.org/techniques/T1048). (Citation: CTU BITS Malware June 2016)
T1205 | Traffic Signaling | Adversaries may use traffic signaling to hide open ports or other malicious functionality used for persistence or command and control. Traffic signaling involves the use of a magic value or sequence that must be sent to a system to trigger a special response, such as opening a closed port or executing a malicious task. This may take the form of sending a series of packets with certain characteristics before a port will be opened that the adversary can use for command and control. Usually this series of packets consists of attempted connections to a predefined sequence of closed ports (i.e. [Port Knocking](https://attack.mitre.org/techniques/T1205/001)), but can involve unusual flags, specific strings, or other unique characteristics. After the sequence is completed, opening a port may be accomplished by the host-based firewall, but could also be implemented by custom software.

Adversaries may also communicate with an already open port, but the service listening on that port will only respond to commands or trigger other malicious functionality if passed the appropriate magic value(s).

The observation of the signal packets to trigger the communication can be conducted through different methods. One means, originally implemented by Cd00r (Citation: Hartrell cd00r 2002), is to use the libpcap libraries to sniff for the packets in question. Another method leverages raw sockets, which enables the malware to use ports that are already open for use by other programs.
T1176 | Browser Extensions | Adversaries may abuse Internet browser extensions to establish persistence access to victim systems. Browser extensions or plugins are small programs that can add functionality and customize aspects of Internet browsers. They can be installed directly or through a browser's app store and generally have access and permissions to everything that the browser can access. (Citation: Wikipedia Browser Extension) (Citation: Chrome Extensions Definition)

Malicious extensions can be installed into a browser through malicious app store downloads masquerading as legitimate extensions, through social engineering, or by an adversary that has already compromised a system. Security can be limited on browser app stores so it may not be difficult for malicious extensions to defeat automated scanners. (Citation: Malicious Chrome Extension Numbers) Once the extension is installed, it can browse to websites in the background, (Citation: Chrome Extension Crypto Miner) (Citation: ICEBRG Chrome Extensions) steal all information that a user enters into a browser (including credentials) (Citation: Banker Google Chrome Extension Steals Creds) (Citation: Catch All Chrome Extension) and be used as an installer for a RAT for persistence.

There have also been instances of botnets using a persistent backdoor through malicious Chrome extensions. (Citation: Stantinko Botnet) There have also been similar examples of extensions being used for command & control  (Citation: Chrome Extension C2 Malware).
T1136 | Create Account | Adversaries may create an account to maintain access to victim systems. With a sufficient level of access, creating such accounts may be used to establish secondary credentialed access that do not require persistent remote access tools to be deployed on the system.

Accounts may be created on the local system or within a domain or cloud tenant. In cloud environments, adversaries may create accounts that only have access to specific services, which can reduce the chance of detection.
T1137 | Office Application Startup | Adversaries may leverage Microsoft Office-based applications for persistence between startups. Microsoft Office is a fairly common application suite on Windows-based operating systems within an enterprise network. There are multiple mechanisms that can be used with Office for persistence when an Office-based application is started; this can include the use of Office Template Macros and add-ins.

A variety of features have been discovered in Outlook that can be abused to obtain persistence, such as Outlook rules, forms, and Home Page.(Citation: SensePost Ruler GitHub) These persistence mechanisms can work within Outlook or be used through Office 365.(Citation: TechNet O365 Outlook Rules)
T1133 | External Remote Services | Adversaries may leverage external-facing remote services to initially access and/or persist within a network. Remote services such as VPNs, Citrix, and other access mechanisms allow users to connect to internal enterprise network resources from external locations. There are often remote service gateways that manage connections and credential authentication for these services. Services such as [Windows Remote Management](https://attack.mitre.org/techniques/T1021/006) can also be used externally.

Access to [Valid Accounts](https://attack.mitre.org/techniques/T1078) to use the service is often a requirement, which could be obtained through credential pharming or by obtaining the credentials from users after compromising the enterprise network.(Citation: Volexity Virtual Private Keylogging) Access to remote services may be used as a redundant or persistent access mechanism during an operation.
T1108 | Redundant Access | **This technique has been deprecated. Please use [Create Account](https://attack.mitre.org/techniques/T1136), [Web Shell](https://attack.mitre.org/techniques/T1505/003), and [External Remote Services](https://attack.mitre.org/techniques/T1133) where appropriate.**

Adversaries may use more than one remote access tool with varying command and control protocols or credentialed access to remote services so they can maintain access if an access mechanism is detected or mitigated. 

If one type of tool is detected and blocked or removed as a response but the organization did not gain a full understanding of the adversary's tools and access, then the adversary will be able to retain access to the network. Adversaries may also attempt to gain access to [Valid Accounts](https://attack.mitre.org/techniques/T1078) to use [External Remote Services](https://attack.mitre.org/techniques/T1133) such as external VPNs as a way to maintain access despite interruptions to remote access tools deployed within a target network.(Citation: Mandiant APT1) Adversaries may also retain access through cloud-based infrastructure and applications.

Use of a [Web Shell](https://attack.mitre.org/techniques/T1100) is one such way to maintain access to a network through an externally accessible Web server.
T1098 | Account Manipulation | Adversaries may manipulate accounts to maintain access to victim systems. Account manipulation may consist of any action that preserves adversary access to a compromised account, such as modifying credentials or permission groups. These actions could also include account activity designed to subvert security policies, such as performing iterative password updates to bypass password duration policies and preserve the life of compromised credentials. In order to create or manipulate accounts, the adversary must already have sufficient permissions on systems or the domain.
T1078 | Valid Accounts | Adversaries may obtain and abuse credentials of existing accounts as a means of gaining Initial Access, Persistence, Privilege Escalation, or Defense Evasion. Compromised credentials may be used to bypass access controls placed on various resources on systems within the network and may even be used for persistent access to remote systems and externally available services, such as VPNs, Outlook Web Access and remote desktop. Compromised credentials may also grant an adversary increased privilege to specific systems or access to restricted areas of the network. Adversaries may choose not to use malware or tools in conjunction with the legitimate access those credentials provide to make it harder to detect their presence.

The overlap of permissions for local, domain, and cloud accounts across a network of systems is of concern because the adversary may be able to pivot across accounts and systems to reach a high level of access (i.e., domain or enterprise administrator) to bypass access controls set within the enterprise. (Citation: TechNet Credential Theft)
T1062 | Hypervisor | **This technique has been deprecated and should no longer be used.**

A type-1 hypervisor is a software layer that sits between the guest operating systems and system's hardware. (Citation: Wikipedia Hypervisor) It presents a virtual running environment to an operating system. An example of a common hypervisor is Xen. (Citation: Wikipedia Xen) A type-1 hypervisor operates at a level below the operating system and could be designed with [Rootkit](https://attack.mitre.org/techniques/T1014) functionality to hide its existence from the guest operating system. (Citation: Myers 2007) A malicious hypervisor of this nature could be used to persist on systems through interruption.
T1053 | Scheduled Task/Job | Adversaries may abuse task scheduling functionality to facilitate initial or recurring execution of malicious code. Utilities exist within all major operating systems to schedule programs or scripts to be executed at a specified date and time. A task can also be scheduled on a remote system, provided the proper authentication is met (ex: RPC and file and printer sharing in Windows environments). Scheduling a task on a remote system typically requires being a member of an admin or otherwise privileged group on the remote system.(Citation: TechNet Task Scheduler Security)

Adversaries may use task scheduling to execute programs at system startup or on a scheduled basis for persistence. These mechanisms can also be abused to run a process under the context of a specified account (such as one with elevated permissions/privileges).
T1037 | Boot or Logon Initialization Scripts | Adversaries may use scripts automatically executed at boot or logon initialization to establish persistence. Initialization scripts can be used to perform administrative functions, which may often execute other programs or send information to an internal logging server. These scripts can vary based on operating system and whether applied locally or remotely.  

Adversaries may use these scripts to maintain persistence on a single system. Depending on the access configuration of the logon scripts, either local credentials or an administrator account may be necessary. 

An adversary may also be able to escalate their privileges since some boot or logon initialization scripts run with higher privileges.
T1034 | Path Interception | **This technique has been deprecated. Please use [Path Interception by PATH Environment Variable](https://attack.mitre.org/techniques/T1574/007), [Path Interception by Search Order Hijacking](https://attack.mitre.org/techniques/T1574/008), and/or [Path Interception by Unquoted Path](https://attack.mitre.org/techniques/T1574/009).**

Path interception occurs when an executable is placed in a specific path so that it is executed by an application instead of the intended target. One example of this was the use of a copy of [cmd](https://attack.mitre.org/software/S0106) in the current working directory of a vulnerable application that loads a CMD or BAT file with the CreateProcess function. (Citation: TechNet MS14-019)

There are multiple distinct weaknesses or misconfigurations that adversaries may take advantage of when performing path interception: unquoted paths, path environment variable misconfigurations, and search order hijacking. The first vulnerability deals with full program paths, while the second and third occur when program paths are not specified. These techniques can be used for persistence if executables are called on a regular basis, as well as privilege escalation if intercepted executables are started by a higher privileged process.

### Unquoted Paths
Service paths (stored in Windows Registry keys) (Citation: Microsoft Subkey) and shortcut paths are vulnerable to path interception if the path has one or more spaces and is not surrounded by quotation marks (e.g., <code>C:\unsafe path with space\program.exe</code> vs. <code>"C:\safe path with space\program.exe"</code>). (Citation: Baggett 2012) An adversary can place an executable in a higher level directory of the path, and Windows will resolve that executable instead of the intended executable. For example, if the path in a shortcut is <code>C:\program files\myapp.exe</code>, an adversary may create a program at <code>C:\program.exe</code> that will be run instead of the intended program. (Citation: SecurityBoulevard Unquoted Services APR 2018) (Citation: SploitSpren Windows Priv Jan 2018)

### PATH Environment Variable Misconfiguration
The PATH environment variable contains a list of directories. Certain methods of executing a program (namely using cmd.exe or the command-line) rely solely on the PATH environment variable to determine the locations that are searched for a program when the path for the program is not given. If any directories are listed in the PATH environment variable before the Windows directory, <code>%SystemRoot%\system32</code> (e.g., <code>C:\Windows\system32</code>), a program may be placed in the preceding directory that is named the same as a Windows program (such as cmd, PowerShell, or Python), which will be executed when that command is executed from a script or command-line.

For example, if <code>C:\example path</code> precedes <code>C:\Windows\system32</code> is in the PATH environment variable, a program that is named net.exe and placed in <code>C:\example path</code> will be called instead of the Windows system "net" when "net" is executed from the command-line.

### Search Order Hijacking
Search order hijacking occurs when an adversary abuses the order in which Windows searches for programs that are not given a path. The search order differs depending on the method that is used to execute the program. (Citation: Microsoft CreateProcess) (Citation: Hill NT Shell) (Citation: Microsoft WinExec) However, it is common for Windows to search in the directory of the initiating program before searching through the Windows system directory. An adversary who finds a program vulnerable to search order hijacking (i.e., a program that does not specify the path to an executable) may take advantage of this vulnerability by creating a program named after the improperly specified program and placing it within the initiating program's directory.

For example, "example.exe" runs "cmd.exe" with the command-line argument <code>net user</code>. An adversary may place a program called "net.exe" within the same directory as example.exe, "net.exe" will be run instead of the Windows system utility net. In addition, if an adversary places a program called "net.com" in the same directory as "net.exe", then <code>cmd.exe /C net user</code> will execute "net.com" instead of "net.exe" due to the order of executable extensions defined under PATHEXT. (Citation: MSDN Environment Property)

Search order hijacking is also a common practice for hijacking DLL loads and is covered in [DLL Search Order Hijacking](https://attack.mitre.org/techniques/T1038).

Invoke-AtomicTest-By -Tactic persistence


```{toctree}
:hidden:
:titlesonly:


persistence/T1108.ipynb
persistence/T1098.004.ipynb
persistence/T1546.008.ipynb
persistence/T1546.011.ipynb
persistence/T1546.013.ipynb
persistence/T1547.ipynb
persistence/T1547.009.ipynb
persistence/T1137.ipynb
persistence/T1137.005.ipynb
persistence/T1543.004.ipynb
persistence/T1547.010.ipynb
persistence/T1098.002.ipynb
persistence/T1574.012.ipynb
persistence/T1133.ipynb
persistence/T1137.001.ipynb
persistence/T1176.ipynb
persistence/.DS_Store
persistence/T1543.ipynb
persistence/T1542.003.ipynb
persistence/T1037.ipynb
persistence/T1136.002.ipynb
persistence/T1574.009.ipynb
persistence/T1542.001.ipynb
persistence/T1546.015.ipynb
persistence/T1543.002.ipynb
persistence/T1205.001.ipynb
persistence/T1574.010.ipynb
persistence/T1137.003.ipynb
persistence/T1547.008.ipynb
persistence/T1197.ipynb
persistence/T1546.ipynb
persistence/T1546.012.ipynb
persistence/T1547.011.ipynb
persistence/T1053.ipynb
persistence/T1136.ipynb
persistence/T1137.004.ipynb
persistence/T1546.009.ipynb
persistence/T1137.006.ipynb
persistence/T1525.ipynb
persistence/T1546.010.ipynb
persistence/T1546.014.ipynb
persistence/T1034.ipynb
persistence/T1574.008.ipynb
persistence/T1505.ipynb
persistence/T1136.001.ipynb
persistence/T1574.011.ipynb
persistence/T1137.002.ipynb
persistence/T1098.001.ipynb
persistence/T1543.003.ipynb
persistence/T1543.001.ipynb
persistence/T1098.003.ipynb
persistence/T1136.003.ipynb
persistence/T1542.ipynb
persistence/T1542.002.ipynb
persistence/T1505.002.ipynb
persistence/T1574.006.ipynb
persistence/T1037.003.ipynb
persistence/T1546.003.ipynb
persistence/T1078.003.ipynb
persistence/T1053.004.ipynb
persistence/T1078.001.ipynb
persistence/T1546.001.ipynb
persistence/T1037.001.ipynb
persistence/T1547.002.ipynb
persistence/T1574.004.ipynb
persistence/T1547.006.ipynb
persistence/T1037.005.ipynb
persistence/T1053.002.ipynb
persistence/T1546.005.ipynb
persistence/T1546.007.ipynb
persistence/T1062.ipynb
persistence/T1574.002.ipynb
persistence/T1547.004.ipynb
persistence/T1098.ipynb
persistence/T1554.ipynb
persistence/T1574.005.ipynb
persistence/T1505.001.ipynb
persistence/T1547.003.ipynb
persistence/T1547.001.ipynb
persistence/T1037.002.ipynb
persistence/T1574.007.ipynb
persistence/T1505.003.ipynb
persistence/T1053.005.ipynb
persistence/T1078.002.ipynb
persistence/T1546.002.ipynb
persistence/T1053.001.ipynb
persistence/T1546.006.ipynb
persistence/T1547.005.ipynb
persistence/T1078.ipynb
persistence/T1574.001.ipynb
persistence/T1547.007.ipynb
persistence/T1574.ipynb
persistence/T1037.004.ipynb
persistence/T1546.004.ipynb
persistence/T1078.004.ipynb
persistence/T1205.ipynb
persistence/T1053.003.ipynb
```
