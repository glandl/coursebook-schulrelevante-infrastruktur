+++
title = "Learning goals"
weight = 10
+++

After this session you can:

1. **explain** what a hypervisor is and distinguish type 1 from type 2 hypervisors,
2. **compare VM and container** (isolation, resource needs, startup, portability, security),
3. **create a Linux VM** (Ubuntu Server) in VirtualBox, operate it, back it up with **snapshots** and **clone** it,
4. **install Docker**, manage images and containers (`run`, `ps`, `logs`, `exec`, `stop`, `rm`),
5. **start a service with Docker Compose** (web server or Nextcloud with database), back up and restore persistent data via **volumes**,
6. **decide with reasons** whether a school service should run as a VM, as a container or not locally at all,
7. **name security and data protection aspects** (updates, isolation, backup, access to images and volumes),
8. **document your work in Markdown** and submit it via Git and pull request.

{{% callout style="info" title="Mapping to the competency list" %}}
Goals 1–6 belong to the infrastructure competency (servers and virtualization), goal 7 to IT security and data protection, goal 8 to the documentation competency. _Reference to the competency list: follows once the list is included in the script._
{{% /callout %}}

## Prerequisites

- Basic knowledge of networking (IP address, port, router).
- **No** Linux knowledge needed. The required commands are explained in the lab.
- A laptop with at least **8 GB RAM**, **30 GB free storage** and virtualization enabled in the BIOS/UEFI (see [Lab, preparation]({{% relref "lab" %}})).
- A GitHub account.
