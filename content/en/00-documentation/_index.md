+++
title = "Documentation techniques"
type = "chapter"
weight = 5
+++

This chapter is the **continuous script on documentation**. It follows the order of the sessions, so each technique builds on the previous one. The session chapters only refer here: this is where *how* to document is explained, while the sessions say *what* to document.

All submissions go into the portfolio repository (private, pull requests) and are assessed with the [assessment rubric]({{% relref "/rubric" %}}).

## Why document?

School IT is rarely run by one person alone, and rarely by the same person for long. Whoever leaves the school, goes on parental leave or falls ill takes their knowledge with them if it has not been written down. Good documentation

- makes operations **transferable** (cover, succession, external service providers),
- makes decisions **traceable** (school management, school maintainer, data protection),
- makes troubleshooting **faster**, because the target state is known,
- is often a **duty of proof** for data protection and IT security (see [Processing register and ADRs]({{% relref "processing-register-adr" %}})).

## The six techniques at a glance

| No. | Technique | Question it answers | Session |
|---|---|---|---|
| 1 | [Markdown, Git and pull request workflow]({{% relref "markdown-git" %}}) | How do I write, version and submit documentation? | 1 |
| 2 | [Network diagrams and IP plans]({{% relref "network-diagrams-ip-plans" %}}) | What is connected to what, and who has which address? | 2 |
| 3 | [VLAN and permission matrices]({{% relref "vlan-permission-matrices" %}}) | Who may access what? | 3 |
| 4 | [Runbooks]({{% relref "runbooks" %}}) | How do I carry out a task reproducibly? | 4 |
| 5 | [Change logs for device policies]({{% relref "change-logs" %}}) | What was changed, when, why and by whom? | 5 |
| 6 | [Processing register and ADRs]({{% relref "processing-register-adr" %}}) | Which data do we process, and why did we decide this way? | 6 |

## Structure of each page

Every technique has the same structure: **Goal**, **Basics**, **Step by step**, **Template**, **Example**, **Common mistakes**, **Use in the course**. You can copy the templates into your portfolio.

## General principles

These rules apply to all techniques:

1. **Write for the reader.** Imagine your successor who has to find a failed server at 7:30 a.m. a year from now.
2. **One document, one purpose.** Several short documents with a clear task are better than one long document for everything.
3. **State date, version and author.** Outdated documentation is more dangerous than none.
4. **No secrets in plain text.** Passwords, keys and tokens belong in a password manager, not in the repository. The documentation only says *where* they are.
5. **No personal data without need.** No real student names, class lists or photos of people in screenshots (see [Screenshot conventions]({{% relref "markdown-git" %}})).
6. **Make it verifiable.** Give versions, commands and expected results so that others can reproduce it.
7. **State your sources.** Separate your own work from adopted text. If you used AI support: label it and check it yourself.

{{% pages display="tree" levels="1" %}}
