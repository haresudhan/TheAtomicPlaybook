# T1134.004 - Access Token Manipulation: Parent PID Spoofing
Adversaries may spoof the parent process identifier (PPID) of a new process to evade process-monitoring defenses or to elevate privileges. New processes are typically spawned directly from their parent, or calling, process unless explicitly specified. One way of explicitly assigning the PPID of a new process is via the <code>CreateProcess</code> API call, which supports a parameter that defines the PPID to use.(Citation: DidierStevens SelectMyParent Nov 2009) This functionality is used by Windows features such as User Account Control (UAC) to correctly set the PPID after a requested elevated process is spawned by SYSTEM (typically via <code>svchost.exe</code> or <code>consent.exe</code>) rather than the current user context.(Citation: Microsoft UAC Nov 2018)

Adversaries may abuse these mechanisms to evade defenses, such as those blocking processes spawning directly from Office documents, and analysis targeting unusual/potentially malicious parent-child process relationships, such as spoofing the PPID of [PowerShell](https://attack.mitre.org/techniques/T1086)/[Rundll32](https://attack.mitre.org/techniques/T1085) to be <code>explorer.exe</code> rather than an Office document delivered as part of [Spearphishing Attachment](https://attack.mitre.org/techniques/T1566/001).(Citation: CounterCept PPID Spoofing Dec 2018) This spoofing could be executed via [Visual Basic](https://attack.mitre.org/techniques/T1059/005) within a malicious Office document or any code that can perform [Native API](https://attack.mitre.org/techniques/T1106).(Citation: CTD PPID Spoofing Macro Mar 2019)(Citation: CounterCept PPID Spoofing Dec 2018)

Explicitly assigning the PPID may also enable elevated privileges given appropriate access rights to the parent process. For example, an adversary in a privileged user context (i.e. administrator) may spawn a new process and assign the parent as a process running as SYSTEM (such as <code>lsass.exe</code>), causing the new process to be elevated via the inherited access token.(Citation: XPNSec PPID Nov 2017)

## Atomic Tests

#Import the Module before running the tests.
Import-Module /Users/0x6c/AtomicRedTeam/atomics/invoke-atomicredteam/Invoke-AtomicRedTeam.psd1 - Force

### Atomic Test #1 - Parent PID Spoofing using PowerShell
This test uses PowerShell to replicates how Cobalt Strike does ppid spoofing and masquerade a spawned process.
Upon execution, "Process C:\Program Files\Internet Explorer\iexplore.exe is spawned with pid ####" will be displayed and
calc.exe will be launched.

Credit to In Ming Loh (https://github.com/countercept/ppid-spoofing/blob/master/PPID-Spoof.ps1)

**Supported Platforms:** windows
#### Attack Commands: Run with `powershell`
```powershell
. $PathToAtomicsFolder\T1134.004\src\PPID-Spoof.ps1
$ppid=Get-Process #{parent_process_name} | select -expand id
PPID-Spoof -ppid $ppid -spawnto "#{spawnto_process_path}" -dllpath "#{dll_path}"
```

Invoke-AtomicTest T1134.004 -TestNumbers 1

## Detection
Look for inconsistencies between the various fields that store PPID information, such as the EventHeader ProcessId from data collected via Event Tracing for Windows (ETW), Creator Process ID/Name from Windows event logs, and the ProcessID and ParentProcessID (which are also produced from ETW and other utilities such as Task Manager and Process Explorer). The ETW provided EventHeader ProcessId identifies the actual parent process.(Citation: CounterCept PPID Spoofing Dec 2018)

Monitor and analyze API calls to <code>CreateProcess</code>/<code>CreateProcessA</code>, specifically those from user/potentially malicious processes and with parameters explicitly assigning PPIDs (ex: the Process Creation Flags of 0x8XXX, indicating that the process is being created with extended startup information(Citation: Microsoft Process Creation Flags May 2018)). Malicious use of <code>CreateProcess</code>/<code>CreateProcessA</code> may also be proceeded by a call to <code>UpdateProcThreadAttribute</code>, which may be necessary to update process creation attributes.(Citation: Secuirtyinbits Ataware3 May 2019) This may generate false positives from normal UAC elevation behavior, so compare to a system baseline/understanding of normal system activity if possible.