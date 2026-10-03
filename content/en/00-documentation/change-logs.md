+++
title = "Change logs for device policies"
weight = 50
+++

## Goal

You can log changes to device and security policies (e.g. in an MDM solution such as Intune, to group policies or WLAN profiles) so that it is clear later: **What was changed, when, why and by whom, and how do you undo it?**

## Basics

### Why change logs?

Policies affect many devices at once. A wrong setting can paralyse an entire school site (e.g. a blocked WLAN certificate) or open a security hole. A log

- enables **traceability** ("since when has the problem occurred?"),
- enables **rollback** (the old state is documented),
- creates **accountability** and **proof** (data protection, school management),
- forces **reasoning and planning** before the change.

### Change log vs. change request

| | Change log | Change request |
|---|---|---|
| Timing | afterwards, with every change | **before** the change |
| Content | what was changed | what is to be changed, risk, test, rollback |
| Scope at schools | always | for significant policies (e.g. security, access) |

For small schools a combined format is often enough: a short request in the entry, followed by the result.

### Characteristics of a good entry

- **Atomic:** one functional change per entry.
- **Unambiguous:** date, person responsible, affected policy and device group.
- **Justified:** occasion (ticket, decision, incident).
- **Reversible:** old and new value, rollback steps.
- **Verified:** where it was tested (pilot group) and with what result.

### Format

Like runbooks, as Markdown in the repository. The Git history adds (who, when), but does **not** replace the change log, because configurations are often in web interfaces (Intune) that are not in the repository. A common standard for the structure is [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) (categories *Added*, *Changed*, *Removed*, *Fixed*).

## Step by step

1. **Describe the change:** What should change, why, for whom?
2. **Record the current state** (setting, value, screenshot or export of the policy).
3. **Define risk and rollback:** What can go wrong? How do you return?
4. **Test on a pilot group first** (e.g. two devices of the IT group), note the result.
5. **Obtain approval** if required (school management, data protection officer).
6. **Roll out the change** and record the time.
7. **Verify the effect** (device reports compliance, user feedback) and close the entry.
8. **If problems occur:** carry out the rollback and note it in the log, do not delete.

## Template

### Entry

```markdown
## 2026-11-30 · PL-014 · Screen lock for teacher tablets

- **Author:** <Name>
- **Affected:** policy `Tablets-Teachers`, device group `Teacher-Tablets` (24 devices)
- **Occasion:** Decision of the school management of 20.11.2026, data protection recommendation
- **Change:** Lock after inactivity from 15 to 5 minutes
- **Old value → new value:** 15 min → 5 min
- **Risk:** frequent locking during presentations in class
- **Test:** Pilot group (3 devices), 25.11.–29.11., no complaints
- **Rollback:** Set value to 15 min, reassign policy
- **Result:** rolled out 30.11., all devices compliant on 01.12.
- **Reference:** Ticket #123
```

### Overview table (optional, at the top of the file)

```markdown
| No. | Date | Policy | Short description | Author | Status |
|---|---|---|---|---|---|
| PL-014 | 30.11.2026 | Tablets-Teachers | Lock time 15 → 5 min | <Name> | rolled out |
```

## Example

A log with two entries, as it might look after a few weeks:

```markdown
# Change log device policies – <School>

| No. | Date | Policy | Short description | Status |
|---|---|---|---|---|
| PL-015 | 03.12.2026 | WLAN profile students | Certificate renewed | rolled out |
| PL-014 | 30.11.2026 | Tablets-Teachers | Lock time 15 → 5 min | rolled out |

## 2026-12-03 · PL-015 · WLAN certificate renewed
- **Occasion:** The certificate expires on 15.12.
- **Change:** New certificate (valid until 2027-12-15) stored in the profile.
- **Test:** 2 pilot devices connect successfully.
- **Rollback:** The old certificate stays valid until 15.12.; the profile can be reset.
- **Result:** rolled out, 98 % of the devices reconnected by 05.12.
```

## Common mistakes

| Mistake | Better |
|---|---|
| Change only in someone's head or by word of mouth | Always in writing, with a date |
| Several changes in one entry | One entry per functional change |
| No old value | Record old and new, otherwise rollback is not possible |
| No test on a pilot group | Pilot first, then all devices |
| Changing or deleting entries afterwards | Corrections as a new entry |
| No reason given | State occasion, decision or ticket |
| Name of the person missing | Always state who is responsible |

## Use in the course

Mainly used in: [Session 5]({{% relref "/05-client-mobile-device-management" %}})
