# T1548 - Abuse Elevation Control Mechanism
Adversaries may circumvent mechanisms designed to control elevate privileges to gain higher-level permissions. Most modern systems contain native elevation control mechanisms that are intended to limit privileges that a user can perform on a machine. Authorization has to be granted to specific users in order to perform tasks that can be considered of higher risk. An adversary can perform several methods to take advantage of built-in control mechanisms in order to escalate privileges on a system.

## Atomic Tests:
Currently, no tests are available for this technique.

## Detection
Monitor the file system for files that have the setuid or setgid bits set. Also look for any process API calls for behavior that may be indicative of [Process Injection](https://attack.mitre.org/techniques/T1055) and unusual loaded DLLs through [DLL Search Order Hijacking](https://attack.mitre.org/techniques/T1574/001), which indicate attempts to gain access to higher privileged processes. On Linux, auditd can alert every time a user's actual ID and effective ID are different (this is what happens when you sudo).

Consider monitoring for <code>/usr/libexec/security_authtrampoline</code> executions which may indicate that AuthorizationExecuteWithPrivileges is being executed. MacOS system logs may also indicate when AuthorizationExecuteWithPrivileges is being called. Monitoring OS API callbacks for the execution can also be a way to detect this behavior but requires specialized security tooling.

On Linux, auditd can alert every time a user's actual ID and effective ID are different (this is what happens when you sudo). This technique is abusing normal functionality in macOS and Linux systems, but sudo has the ability to log all input and output based on the <code>LOG_INPUT</code> and <code>LOG_OUTPUT</code> directives in the <code>/etc/sudoers</code> file.

There are many ways to perform UAC bypasses when a user is in the local administrator group on a system, so it may be difficult to target detection on all variations. Efforts should likely be placed on mitigation and collecting enough information on process launches and actions that could be performed before and after a UAC bypass is performed. Some UAC bypass methods rely on modifying specific, user-accessible Registry settings. Analysts should monitor Registry settings for unauthorized changes.