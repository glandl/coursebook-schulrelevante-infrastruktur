+++
title = "Runbooks"
weight = 40
+++

## Goal

You can describe a recurring task or a fault fix so that **another person carries it out correctly without asking questions**, even under time pressure. A runbook answers: *How do I carry out this task reproducibly?*

## Basics

### Runbook, guide, manual

| Document type | Purpose | Example |
|---|---|---|
| **Runbook** | Concrete sequence for a specific task or fault | "Create a new teacher account", "Restore Nextcloud" |
| Concept | Why is something built this way? | Architecture description, ADR |
| Reference | Look things up | IP plan, matrices |

### Types of runbooks

- **Routine** (standard tasks): create users, install updates, check backup, school year changeover.
- **Fault** (incident): service not reachable, WLAN down, storage full.
- **Emergency / recovery:** restore from backup, server failure.

### Properties of a good runbook

- **Executable:** numbered steps, one action per step (command or click path).
- **Verifiable:** After important steps it states how to recognise success.
- **Safe:** Warnings about destructive steps come **before** the step. The way back (rollback) is described.
- **Complete:** prerequisites, permissions, estimated duration, contact persons.
- **Current:** date of the last check. Ideally it is tested and corrected the next time it is carried out.

## Step by step

1. **Delimit the task:** The title names action and object ("Restore Nextcloud from backup").
2. **Carry out the task yourself** and write down steps and commands while doing so.
3. **Clarify prerequisites:** access, tools, rights, maintenance window.
4. **Smooth out the steps:** one action per step, commands in a code block, state the expected output.
5. **Add checkpoints and warnings.**
6. **Describe the rollback:** How do you return to the initial state?
7. **Test run by another person** who uses only the runbook. Every question they ask is a defect in the runbook.
8. **Publish, add version and date**, store it in a well-known place (repository, wiki).

## Template

````markdown
# Runbook: <Action> <Object>

- **Version / date:** 1.0 / <DD.MM.YYYY>
- **Author:** <Name>   **Checked by:** <Name>, <Date>
- **Type:** Routine | Fault | Emergency
- **Estimated duration:** <Minutes>
- **Impact:** <Who is affected? Is there downtime?>

## Prerequisites
- Access: <System, account, where the password is stored – not the password itself>
- Tools: <Software, version>
- Done beforehand: <e.g. current backup available>

## Steps
1. <Action>
   ```bash
   <Command>
   ```
   **Expected:** <Output or state>
2. ...

> **Warning:** <Warning about destructive step>

## Verify success
- [ ] <Check 1>
- [ ] <Check 2>

## Rollback
1. <Way back>

## If problems occur
- <Typical error message> → <Solution>
- Contact: <Role, contact details>

## Changes
| Date | Version | Change | Author |
|---|---|---|---|
````

## Example

Short routine runbook (commands *untested*, paths depend on the installation):

````markdown
# Runbook: Create a VM snapshot before the update

- **Version / date:** 1.0 / 05.10.2026
- **Type:** Routine, **Duration:** approx. 5 minutes
- **Impact:** none (VM keeps running)

## Prerequisites
- VirtualBox host with access to the VM `ubuntu-lab`
- At least 5 GB of free storage on the host

## Steps
1. Check that the VM is running and no maintenance is in progress.
   ```bash
   VBoxManage list runningvms
   ```
   **Expected:** `"ubuntu-lab" {…}` is in the list.
2. Create the snapshot.
   ```bash
   VBoxManage snapshot ubuntu-lab take "before-update-2026-10-05" --description "Before apt upgrade"
   ```
3. Run the update in the VM: `sudo apt update && sudo apt upgrade`.

## Verify success
- [ ] `VBoxManage snapshot ubuntu-lab list` shows the new snapshot.

## Rollback
1. Shut down the VM.
2. `VBoxManage snapshot ubuntu-lab restore "before-update-2026-10-05"`
> **Warning:** Restoring discards all changes made since the snapshot.
````

## Common mistakes

| Mistake | Better |
|---|---|
| Steps assume knowledge ("then configure as usual") | Spell out every action |
| Several actions in one step | One action per step |
| No expected output | State checkpoints |
| Warning comes after the dangerous step | Put the warning before the step |
| No rollback | Always describe the way back |
| Passwords in the runbook | Reference to the password manager |
| Never tested, never updated | Test run by a third party, enter check date |
| Commands as screenshots | Text in a code block, copyable |

## Use in the course

Mainly used in: [Session 4]({{% relref "/04-server-administration" %}})

The principle already helps in session 1: The [Guided lab]({{% relref "/01-virtualization-containerization/lab" %}}) is itself a small runbook.
