+++
title = "Documentation task: role runbook"
weight = 50
+++

{{% callout style="info" title="Technique" %}}
Read first in the documentation script: [Runbooks]({{% relref "/00-documentation/runbooks" %}})
{{% /callout %}}

{{% callout style="warning" title="Graded" %}}
The **role runbook** is the graded portfolio entry of this chapter (rubric see [assessment]({{% relref "/rubric" %}})). Due: **06.12.2026**. There is no separate homework in this chapter.
{{% /callout %}}

## Task

Each role team writes **one shared runbook** for its role. It describes how to set up, check and undo the role in the **Windows world** and in the **Linux world**, so that another team of teachers can rebuild it without asking. The runbook is in the portfolios of **all** team members (same file). In addition, **each person** writes a short personal reflection.

**Location:** `04-server-administration/README.md` (runbook) and `04-server-administration/reflection.md` (personal), images in `assets/`, branch `session-04`, submission via pull request.

## Content

1. **Header** following the template in the documentation script: title "Runbook: set up the server role `<role>` in Windows and Linux", version, date, authors, checked by (another team), estimated duration.
2. **Starting point:** machines, addresses, operating system versions, software versions (e.g. `Get-ComputerInfo`, `cat /etc/debian_version`, `kea-dhcp4 -V`).
3. **Prerequisites and dependencies:** which other roles have to run? Which accounts are needed (passwords only as placeholders)?
4. **Steps in the Windows world** and **steps in the Linux world** as a table with an **undo column**:

   | # | Step | Command | Expected | Undo |
   |---|---|---|---|---|
   | 1 | Install role | `Install-WindowsFeature DHCP -IncludeManagementTools` | `Success: True` | `Uninstall-WindowsFeature DHCP` |

   Commands **copyable** (code block or code in the table). Where a click path was needed, it is written out in full.
5. **Acceptance tests** from the test client, with the result (output as text, at least one screenshot per world).
6. **Integration and combination** (session 2): what had to be agreed with which team, which Windows–Linux combination did you test, with what result?
7. **Problems and solutions:** at least two real problems with cause and solution.
8. **Windows vs. Linux comparison** as a table: effort (number of steps, time), licence costs, vendor dependence, further development, data protection, suitability for a team of teachers. With **one recommendation** for *Mittelschule Musterstadt* and a short justification.
9. **Sources:** the official documentation you used.

**Personal reflection** (`reflection.md`, approx. 150–250 words per person): what did you do yourself, what surprised you, which world would you want to look after at your school, and why?

## Review by another team

By **30.11.2026** you give your runbook to another team (team 1 to team 2, team 2 to team 3, …, team 8 to team 1). They read the runbook and note every place where they would have had to ask as a comment in the pull request. Every question is a bug in the runbook.

## Checklist

- [ ] Header complete, "checked by" filled in.
- [ ] Both worlds described, every step has an "undo" column.
- [ ] Commands are copyable, outputs as text, screenshots in `assets/` with alt text.
- [ ] At least two problems with cause and solution.
- [ ] Comparison table and recommendation present.
- [ ] No passwords, no real names of people.
- [ ] Personal reflection of every person present.
- [ ] Pull request opened, comments of the reviewing team answered.
