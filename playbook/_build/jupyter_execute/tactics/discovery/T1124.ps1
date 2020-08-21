# T1124 - System Time Discovery
An adversary may gather the system time and/or time zone from a local or remote system. The system time is set and stored by the Windows Time Service within a domain to maintain time synchronization between systems and services in an enterprise network. (Citation: MSDN System Time) (Citation: Technet Windows Time Service)

System time information may be gathered in a number of ways, such as with [Net](https://attack.mitre.org/software/S0039) on Windows by performing <code>net time \\hostname</code> to gather the system time on a remote system. The victim's time zone may also be inferred from the current system time or gathered by using <code>w32tm /tz</code>. (Citation: Technet Windows Time Service) The information could be useful for performing other techniques, such as executing a file with a [Scheduled Task/Job](https://attack.mitre.org/techniques/T1053) (Citation: RSA EU12 They're Inside), or to discover locality information based on time zone to assist in victim targeting.

## Atomic Tests

#Import the Module before running the tests.
Import-Module /Users/0x6c/AtomicRedTeam/atomics/invoke-atomicredteam/Invoke-AtomicRedTeam.psd1 - Force

### Atomic Test #1 - System Time Discovery
Identify the system time. Upon execution, the local computer system time and timezone will be displayed.

**Supported Platforms:** windows
#### Attack Commands: Run with `command_prompt`
```command_prompt
net time \\#{computer_name}
w32tm /tz
```

Invoke-AtomicTest T1124 -TestNumbers 1

### Atomic Test #2 - System Time Discovery - PowerShell
Identify the system time via PowerShell. Upon execution, the system time will be displayed.

**Supported Platforms:** windows
#### Attack Commands: Run with `powershell`
```powershell
Get-Date
```

Invoke-AtomicTest T1124 -TestNumbers 2

## Detection
Command-line interface monitoring may be useful to detect instances of net.exe or other command-line utilities being used to gather system time or time zone. Methods of detecting API use for gathering this information are likely less useful due to how often they may be used by legitimate software.