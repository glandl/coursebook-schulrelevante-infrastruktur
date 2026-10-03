+++
title = "Exercise (school scenario)"
weight = 40
+++

This exercise is **optional** (not graded), but it deepens the lab and prepares the homework. Work in pairs.

## Scenario

The *Musterstadt Middle School* (400 students, 40 teachers) has an old server that will fail at some point. The principal asks you as the person responsible for IT:

> "We would like a learning platform, a wiki for the staff and a file storage. In addition, the grade management runs on Windows Server 2016. Should we copy everything to new hardware or is there something better?"

## Task

1. **Classify the services.** Create a table with the four services (learning platform, wiki, file storage, grade management) and note for each service:

   | Service | Operating system requirement | Protection need of the data | Criticality | Recommendation (VM / container / cloud) | Reason |
   |---|---|---|---|---|---|

2. **Sketch the target architecture.** Draw a host with VMs and containers using Mermaid (see [Network diagrams]({{% relref "/00-documentation/network-diagrams-ip-plans" %}})).
3. **Estimate resources.** How many CPU cores, how much RAM and storage does the host need at least? (Assumption: 2 GB RAM per Linux VM, 4 GB per Windows VM, 0.5 to 1 GB per container service, 30 % reserve.)
4. **Play through a failure scenario.** The host fails. What is lost, how quickly does operation resume, what must be ready in advance? Note three concrete measures.
5. **Presentation:** Present your proposal to the "principal" (another team) in 3 minutes. Explain without technical terms why VMs or containers.

## Guiding questions

- Does the grade management really have to run on Windows? What effects does a move have?
- Who looks after the system when you are ill?
- Where are the backups, and when was a restore last tested?
- Which data must not leave the school?

## Extension (for fast learners)

In the lab, start a second service (e.g. [Wiki.js](https://hub.docker.com/r/requarks/wiki) or [Uptime Kuma](https://hub.docker.com/r/louislam/uptime-kuma)) with Docker Compose next to Nextcloud. Check how much RAM both need together (`docker stats`), and whether the VM is sufficient.
