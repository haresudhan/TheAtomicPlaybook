# T1565.002 - Transmitted Data Manipulation
Adversaries may alter data en route to storage or other systems in order to manipulate external outcomes or hide activity.(Citation: FireEye APT38 Oct 2018)(Citation: DOJ Lazarus Sony 2018) By manipulating transmitted data, adversaries may attempt to affect a business process, organizational understanding, and decision making.

Manipulation may be possible over a network connection or between system processes where there is an opportunity deploy a tool that will intercept and change information. The type of modification and the impact it will have depends on the target transmission mechanism as well as the goals and objectives of the adversary. For complex systems, an adversary would likely need special expertise and possibly access to specialized software related to the system that would typically be gained through a prolonged information gathering campaign in order to have the desired impact.

## Atomic Tests:
Currently, no tests are available for this technique.

## Detection
Detecting the manipulation of data as at passes over a network can be difficult without the appropriate tools. In some cases integrity verification checks, such as file hashing, may be used on critical files as they transit a network. With some critical processes involving transmission of data, manual or out-of-band integrity checking may be useful for identifying manipulated data. 