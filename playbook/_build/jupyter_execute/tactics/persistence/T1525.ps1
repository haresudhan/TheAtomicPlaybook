# T1525 - Implant Container Image
Adversaries may implant cloud container images with malicious code to establish persistence. Amazon Web Service (AWS) Amazon Machine Images (AMI), Google Cloud Platform (GCP) Images, and Azure Images as well as popular container runtimes such as Docker can be implanted or backdoored. Depending on how the infrastructure is provisioned, this could provide persistent access if the infrastructure provisioning tool is instructed to always use the latest image.(Citation: Rhino Labs Cloud Image Backdoor Technique Sept 2019)

A tool has been developed to facilitate planting backdoors in cloud container images.(Citation: Rhino Labs Cloud Backdoor September 2019) If an attacker has access to a compromised AWS instance, and permissions to list the available container images, they may implant a backdoor such as a [Web Shell](https://attack.mitre.org/techniques/T1505/003).(Citation: Rhino Labs Cloud Image Backdoor Technique Sept 2019) Adversaries may also implant Docker images that may be inadvertently used in cloud deployments, which has been reported in some instances of cryptomining botnets.(Citation: ATT Cybersecurity Cryptocurrency Attacks on Cloud) 

## Atomic Tests:
Currently, no tests are available for this technique.

## Detection
Monitor interactions with images and containers by users to identify ones that are added or modified anomalously.