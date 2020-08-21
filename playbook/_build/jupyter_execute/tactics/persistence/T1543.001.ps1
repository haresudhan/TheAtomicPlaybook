# T1543.001 - Create or Modify System Process: Launch Agent
Adversaries may create or modify launch agents to repeatedly execute malicious payloads as part of persistence. Per Apple’s developer documentation, when a user logs in, a per-user launchd process is started which loads the parameters for each launch-on-demand user agent from the property list (plist) files found in <code>/System/Library/LaunchAgents</code>, <code>/Library/LaunchAgents</code>, and <code>$HOME/Library/LaunchAgents</code> (Citation: AppleDocs Launch Agent Daemons) (Citation: OSX Keydnap malware) (Citation: Antiquated Mac Malware). These launch agents have property list files which point to the executables that will be launched (Citation: OSX.Dok Malware).
 
Adversaries may install a new launch agent that can be configured to execute at login by using launchd or launchctl to load a plist into the appropriate directories  (Citation: Sofacy Komplex Trojan)  (Citation: Methods of Mac Malware Persistence). The agent name may be disguised by using a name from a related operating system or benign software. Launch Agents are created with user level privileges and are executed with the privileges of the user when they log in (Citation: OSX Malware Detection) (Citation: OceanLotus for OS X). They can be set up to execute when a specific user logs in (in the specific user’s directory structure) or when any user logs in (which requires administrator privileges).

## Atomic Tests

#Import the Module before running the tests.
Import-Module /Users/0x6c/AtomicRedTeam/atomics/invoke-atomicredteam/Invoke-AtomicRedTeam.psd1 - Force

### Atomic Test #1 - Launch Agent
Create a plist and execute it

**Supported Platforms:** macos
#### Attack Commands: Run with `bash`
```bash
if [ ! -d ~/Library/LaunchAgents ]; then mkdir ~/Library/LaunchAgents; fi;
sudo cp #{path_malicious_plist} ~/Library/LaunchAgents/#{plist_filename}
sudo launchctl load -w ~/Library/LaunchAgents/#{plist_filename}
```

Invoke-AtomicTest T1543.001 -TestNumbers 1

## Detection
Monitor Launch Agent creation through additional plist files and utilities such as Objective-See’s  KnockKnock application. Launch Agents also require files on disk for persistence which can also be monitored via other file monitoring applications.