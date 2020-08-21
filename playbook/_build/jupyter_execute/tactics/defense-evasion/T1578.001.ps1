# T1578.001 - Create Snapshot
An adversary may create a snapshot or data backup within a cloud account to evade defenses. A snapshot is a point-in-time copy of an existing cloud compute component such as a virtual machine (VM), virtual hard drive, or volume. An adversary may leverage permissions to create a snapshot in order to bypass restrictions that prevent access to existing compute service infrastructure, unlike in [Revert Cloud Instance](https://attack.mitre.org/techniques/T1536) where an adversary may revert to a snapshot to evade detection and remove evidence of their presence.

An adversary may [Create Cloud Instance](https://attack.mitre.org/techniques/T1578/002), mount one or more created snapshots to that instance, and then apply a policy that allows the adversary access to the created instance, such as a firewall policy that allows them inbound and outbound SSH access.(Citation: Mandiant M-Trends 2020)

## Atomic Tests:
Currently, no tests are available for this technique.

## Detection
The creation of a snapshot is a common part of operations within many cloud environments. Events should then not be viewed in isolation, but as part of a chain of behavior that could lead to other activities such as the creation of one or more snapshots and the restoration of these snapshots by a new user account.

In AWS, CloudTrail logs capture the creation of snapshots and all API calls for AWS Backup as events. Using the information collected by CloudTrail, you can determine the request that was made, the IP address from which the request was made, which user made the request, when it was made, and additional details.(Citation: AWS Cloud Trail Backup API).

In Azure, the creation of a snapshot may be captured in Azure activity logs. Backup restoration events can also be detected through Azure Monitor Log Data by creating a custom alert for completed restore jobs.(Citation: Azure - Monitor Logs)

Google's Admin Activity audit logs within their Cloud Audit logs can be used to detect the usage of the <code>gcloud compute instances create</code> command to create a new VM disk from a snapshot.(Citation: Cloud Audit Logs) It is also possible to detect the usage of the GCP API with the <code>"sourceSnapshot":</code> parameter pointed to <code>"global/snapshots/[BOOT_SNAPSHOT_NAME]</code>.(Citation: GCP - Creating and Starting a VM)