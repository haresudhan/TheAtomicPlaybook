# Exfiltration
The adversary is trying to steal data.

Exfiltration consists of techniques that adversaries may use to steal data from your network. Once they’ve collected data, adversaries often package it to avoid detection while removing it. This can include compression and encryption. Techniques for getting data out of a target network typically include transferring it over their command and control channel or an alternate channel and may also include putting size limits on the transmission.
## Techniques
| ID      | Name | Description |
| :--------: | :---------: | :---------: |
T1048.003 | Exfiltration Over Unencrypted/Obfuscated Non-C2 Protocol | Adversaries may steal data by exfiltrating it over an un-encrypted network protocol other than that of the existing command and control channel. The data may also be sent to an alternate network location from the main command and control server. 

Adversaries may opt to obfuscate this data, without the use of encryption, within network protocols that are natively unencrypted (such as HTTP, FTP, or DNS). This may include custom or publicly available encoding/compression algorithms (such as base64) as well as embedding data within protocol headers and fields. 
T1048.002 | Exfiltration Over Asymmetric Encrypted Non-C2 Protocol | Adversaries may steal data by exfiltrating it over an asymmetrically encrypted network protocol other than that of the existing command and control channel. The data may also be sent to an alternate network location from the main command and control server. 

Asymmetric encryption algorithms are those that use different keys on each end of the channel. Also known as public-key cryptography, this requires pairs of cryptographic keys that can encrypt/decrypt data from the corresponding key. Each end of the communication channels requires a private key (only in the procession of that entity) and the public key of the other entity. The public keys of each entity are exchanged before encrypted communications begin. 

Network protocols that use asymmetric encryption (such as HTTPS/TLS/SSL) often utilize symmetric encryption once keys are exchanged. Adversaries may opt to use these encrypted mechanisms that are baked into a protocol. 
T1048.001 | Exfiltration Over Symmetric Encrypted Non-C2 Protocol | Adversaries may steal data by exfiltrating it over a symmetrically encrypted network protocol other than that of the existing command and control channel. The data may also be sent to an alternate network location from the main command and control server. 

Symmetric encryption algorithms are those that use shared or the same keys/secrets on each end of the channel. This requires an exchange or pre-arranged agreement/possession of the value used to encrypt and decrypt data. 

Network protocols that use asymmetric encryption often utilize symmetric encryption once keys are exchanged, but adversaries may opt to manually share keys and implement symmetric cryptographic algorithms (ex: RC4, AES) vice using mechanisms that are baked into a protocol. This may result in multiple layers of encryption (in protocols that are natively encrypted such as HTTPS) or encryption in protocols that not typically encrypted (such as HTTP or FTP). 
T1052.001 | Exfiltration over USB | Adversaries may attempt to exfiltrate data over a USB connected physical device. In certain circumstances, such as an air-gapped network compromise, exfiltration could occur via a USB device introduced by a user. The USB device could be used as the final exfiltration point or to hop between otherwise disconnected systems.
T1011.001 | Exfiltration Over Bluetooth | Adversaries may attempt to exfiltrate data over Bluetooth rather than the command and control channel. If the command and control network is a wired Internet connection, an attacker may opt to exfiltrate data using a Bluetooth communication channel.

Adversaries may choose to do this if they have sufficient access and proximity. Bluetooth connections might not be secured or defended as well as the primary Internet-connected channel because it is not routed through the same enterprise network.
T1567.002 | Exfiltration to Cloud Storage | Adversaries may exfiltrate data to a cloud storage service rather than over their primary command and control channel. Cloud storage services allow for the storage, edit, and retrieval of data from a remote cloud storage server over the Internet.

Examples of cloud storage services include Dropbox and Google Docs. Exfiltration to these cloud storage services can provide a significant amount of cover to the adversary if hosts within the network are already communicating with the service. 
T1567.001 | Exfiltration to Code Repository | Adversaries may exfiltrate data to a code repository rather than over their primary command and control channel. Code repositories are often accessible via an API (ex: https://api.github.com). Access to these APIs are often over HTTPS, which gives the adversary an additional level of protection.

Exfiltration to a code repository can also provide a significant amount of cover to the adversary if it is a popular service already used by hosts within the network. 
T1567 | Exfiltration Over Web Service | Adversaries may use an existing, legitimate external Web service to exfiltrate data rather than their primary command and control channel. Popular Web services acting as an exfiltration mechanism may give a significant amount of cover due to the likelihood that hosts within a network are already communicating with them prior to compromise. Firewall rules may also already exist to permit traffic to these services.

Web service providers also commonly use SSL/TLS encryption, giving adversaries an added level of protection.
T1537 | Transfer Data to Cloud Account | Adversaries may exfiltrate data by transferring the data, including backups of cloud environments, to another cloud account they control on the same service to avoid typical file transfers/downloads and network-based exfiltration detection.

A defender who is monitoring for large transfers to outside the cloud environment through normal file transfers or over command and control channels may not be watching for data transfers to another account within the same cloud provider. Such transfers may utilize existing cloud provider APIs and the internal address space of the cloud provider to blend into normal traffic or avoid data transfers over external network interfaces.

Incidents have been observed where adversaries have created backups of cloud instances and transferred them to separate accounts.(Citation: DOJ GRU Indictment Jul 2018) 
T1052 | Exfiltration Over Physical Medium | Adversaries may attempt to exfiltrate data via a physical medium, such as a removable drive. In certain circumstances, such as an air-gapped network compromise, exfiltration could occur via a physical medium or device introduced by a user. Such media could be an external hard drive, USB drive, cellular phone, MP3 player, or other removable storage and processing device. The physical medium or device could be used as the final exfiltration point or to hop between otherwise disconnected systems.
T1048 | Exfiltration Over Alternative Protocol | Adversaries may steal data by exfiltrating it over a different protocol than that of the existing command and control channel. The data may also be sent to an alternate network location from the main command and control server.  

Alternate protocols include FTP, SMTP, HTTP/S, DNS, SMB, or any other network protocol not being used as the main command and control channel. Different protocol channels could also include Web services such as cloud storage. Adversaries may also opt to encrypt and/or obfuscate these alternate channels. 

[Exfiltration Over Alternative Protocol](https://attack.mitre.org/techniques/T1048) can be done using various common operating system utilities such as [Net](https://attack.mitre.org/software/S0039)/SMB or FTP.(Citation: Palo Alto OilRig Oct 2016) 
T1041 | Exfiltration Over C2 Channel | Adversaries may steal data by exfiltrating it over an existing command and control channel. Stolen data is encoded into the normal communications channel using the same protocol as command and control communications.
T1030 | Data Transfer Size Limits | An adversary may exfiltrate data in fixed size chunks instead of whole files or limit packet sizes below certain thresholds. This approach may be used to avoid triggering network data transfer threshold alerts.
T1029 | Scheduled Transfer | Adversaries may schedule data exfiltration to be performed only at certain times of day or at certain intervals. This could be done to blend traffic patterns with normal activity or availability.

When scheduled exfiltration is used, other exfiltration techniques likely apply as well to transfer the information out of the network, such as [Exfiltration Over C2 Channel](https://attack.mitre.org/techniques/T1041) or [Exfiltration Over Alternative Protocol](https://attack.mitre.org/techniques/T1048).
T1020 | Automated Exfiltration | Adversaries may exfiltrate data, such as sensitive documents, through the use of automated processing after being gathered during Collection. 

When automated exfiltration is used, other exfiltration techniques likely apply as well to transfer the information out of the network, such as [Exfiltration Over C2 Channel](https://attack.mitre.org/techniques/T1041) and [Exfiltration Over Alternative Protocol](https://attack.mitre.org/techniques/T1048).
T1011 | Exfiltration Over Other Network Medium | Adversaries may attempt to exfiltrate data over a different network medium than the command and control channel. If the command and control network is a wired Internet connection, the exfiltration may occur, for example, over a WiFi connection, modem, cellular data connection, Bluetooth, or another radio frequency (RF) channel.

Adversaries may choose to do this if they have sufficient access or proximity, and the connection might not be secured or defended as well as the primary Internet-connected channel because it is not routed through the same enterprise network

Invoke-AtomicTest-By -Tactic exfiltration


```{toctree}
:hidden:
:titlesonly:


exfiltration/T1052.ipynb
exfiltration/T1567.ipynb
exfiltration/.DS_Store
exfiltration/T1048.002.ipynb
exfiltration/T1011.ipynb
exfiltration/T1029.ipynb
exfiltration/T1030.ipynb
exfiltration/T1048.ipynb
exfiltration/T1048.003.ipynb
exfiltration/T1048.001.ipynb
exfiltration/T1567.001.ipynb
exfiltration/T1052.001.ipynb
exfiltration/T1020.ipynb
exfiltration/T1041.ipynb
exfiltration/T1567.002.ipynb
exfiltration/T1537.ipynb
exfiltration/T1011.001.ipynb
```
