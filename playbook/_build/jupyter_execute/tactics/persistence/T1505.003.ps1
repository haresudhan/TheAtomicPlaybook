# T1505.003 - Server Software Component: Web Shell
Adversaries may backdoor web servers with web shells to establish persistent access to systems. A Web shell is a Web script that is placed on an openly accessible Web server to allow an adversary to use the Web server as a gateway into a network. A Web shell may provide a set of functions to execute or a command-line interface on the system that hosts the Web server.

In addition to a server-side script, a Web shell may have a client interface program that is used to talk to the Web server (ex: [China Chopper](https://attack.mitre.org/software/S0020) Web shell client).(Citation: Lee 2013) 

## Atomic Tests

#Import the Module before running the tests.
Import-Module /Users/0x6c/AtomicRedTeam/atomics/invoke-atomicredteam/Invoke-AtomicRedTeam.psd1 - Force

### Atomic Test #1 - Web Shell Written to Disk
This test simulates an adversary leveraging Web Shells by simulating the file modification to disk.
Idea from APTSimulator.
cmd.aspx source - https://github.com/tennc/webshell/blob/master/fuzzdb-webshell/asp/cmd.aspx

**Supported Platforms:** windows
#### Attack Commands: Run with `command_prompt`
```command_prompt
xcopy #{web_shells} #{web_shell_path}
```

Invoke-AtomicTest T1505.003 -TestNumbers 1

## Detection
Web shells can be difficult to detect. Unlike other forms of persistent remote access, they do not initiate connections. The portion of the Web shell that is on the server may be small and innocuous looking. The PHP version of the China Chopper Web shell, for example, is the following short payload: (Citation: Lee 2013) 

<code>&lt;?php @eval($_POST['password']);&gt;</code>

Nevertheless, detection mechanisms exist. Process monitoring may be used to detect Web servers that perform suspicious actions such as running cmd.exe or accessing files that are not in the Web directory. File monitoring may be used to detect changes to files in the Web directory of a Web server that do not match with updates to the Web server's content and may indicate implantation of a Web shell script. Log authentication attempts to the server and any unusual traffic patterns to or from the server and internal network. (Citation: US-CERT Alert TA15-314A Web Shells) 