# T1558.002 - Silver Ticket
Adversaries who have the password hash of a target service account (e.g. SharePoint, MSSQL) may forge Kerberos ticket granting service (TGS) tickets, also known as silver tickets. Kerberos TGS tickets are also known as service tickets.(Citation: ADSecurity Silver Tickets)

Silver tickets are more limited in scope in than golden tickets in that they only enable adversaries to access a particular resource (e.g. MSSQL) and the system that hosts the resource; however, unlike golden tickets, adversaries with the ability to forge silver tickets are able to create TGS tickets without interacting with the Key Distribution Center (KDC), potentially making detection more difficult.(Citation: ADSecurity Detecting Forged Tickets)

Password hashes for target services may be obtained using [OS Credential Dumping](https://attack.mitre.org/techniques/T1003) or [Kerberoasting](https://attack.mitre.org/techniques/T1558/003).

## Atomic Tests:
Currently, no tests are available for this technique.

## Detection
Monitor for anomalous Kerberos activity, such as malformed or blank fields in Windows logon/logoff events (Event ID 4624, 4634, 4672).(Citation: ADSecurity Detecting Forged Tickets) 

Monitor for unexpected processes interacting with lsass.exe.(Citation: Medium Detecting Attempts to Steal Passwords from Memory) Common credential dumpers such as Mimikatz access the LSA Subsystem Service (LSASS) process by opening the process, locating the LSA secrets key, and decrypting the sections in memory where credential details, including Kerberos tickets, are stored.