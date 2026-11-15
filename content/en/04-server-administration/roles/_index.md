+++
title = "Role cards"
weight = 20
+++

Each role card describes **what** has to run at the end, not **how** every click looks. You find the way there as a team with the official documentation (section *Entry points*). Exactly this way is what you record in the [role runbook]({{% relref "../documentation" %}}): a runbook that is only copied from the book helps nobody in an emergency.

Every card has the same sections:

| Section | Content |
|---|---|
| **The role at a school** | What the role is for, with an example from everyday school life |
| **Dependencies** | Which other roles have to run first |
| **Goal in the Windows world** / **Goal in the Linux world** | What runs at the end of session 1 (on its own, without a domain) |
| **Goal in session 2** | How the role works together with the others |
| **Acceptance tests** | How you prove from the test client that it works |
| **Pitfalls** | What usually goes wrong |
| **Entry points** | Official documentation (primary sources) |
| **Comparison questions** | Questions for the runbook and the presentation |

{{% callout style="warning" title="Status: untested" %}}
The commands, package names and menu items on the role cards have **not** yet been run in the Proxmox lab. Software as of November 2026 (Windows Server 2025, Debian 13 "trixie"). Check versions and commands in the official documentation. *Tested on: open.*
{{% /callout %}}

**Basic rule for the Windows world:** prefer **PowerShell**. What you type in PowerShell can be copied, checked and repeated. A click path in Server Manager is hard to document. You may use Server Manager to look things up.

**Basic rule for the Linux world:** configuration lives in **text files** under `/etc`. Make a backup before every change (`cp file file.orig`); then undoing is a single command.

{{% pages display="tree" orderby="weight" %}}
