+++
title = "Team 7: Client deployment"
weight = 7
+++

**FOG Project:** `10.50.13.27` (Debian **VM**) · **Windows reference machine:** `10.50.13.16` · **two empty target machines** (VMs without an operating system)

## The role at a school

End of August: 25 computers in the computer lab, carrying a school year's worth of traces from 300 students. Instead of reinstalling each computer individually, you set up **one** computer cleanly (*reference machine*), take an **image** of it and play it over the network onto all the others at the same time. For this, the computers boot from the network (**PXE**), fetch a small boot program and write the image to their disk.

## Why only one world here?

There is **no** Windows Server part for this role. The former Windows solution, *Windows Deployment Services* (WDS) with the *Microsoft Deployment Toolkit* (MDT), is no longer being developed by Microsoft. Microsoft relies on **Windows Autopilot** and **Intune** instead, i.e. on the cloud (see session 5). Check the current status in the sources.

**FOG Project** is free software, runs on Linux and deploys **Windows and Linux images**, even to a whole room at the same time (*multicast*). For your team, "both worlds" therefore means: **one Windows image and one Linux image** with the same free tool.

## Dependencies

- Session 1: none. You install the Debian VM and FOG.
- Session 2: **DHCP (team 1)** has to give your machines the PXE options 66 and 67. Without that, no computer boots from the network.

## Goal in session 1

1. **Debian VM** installed (the Debian 13 image is attached; minimal, without a desktop, with SSH server), static address `10.50.13.27`, computer name `fog`.
2. **FOG Project** installed (current stable version from the official repository, installer script `installfog.sh`).
3. Web interface `http://10.50.13.27/fog/` reachable (from the Windows test client), default password changed.
4. Two **image definitions** created: `win-referenz` (Windows) and `debian-referenz` (Linux).
5. MAC addresses of your three machines (reference machine, two target machines) noted and given to team 1. Find out in Proxmox whether the machines boot with BIOS (SeaBIOS) or UEFI (OVMF).

{{% callout style="warning" title="FOG must not start its own DHCP server" %}}
The installer script asks whether FOG should take over DHCP. The answer is **no** (also for the questions about DHCP router and DNS). There are already two DHCP servers from team 1 in the lab VLAN. A third one would give all teams wrong addresses.
{{% /callout %}}

## Goal in session 2

1. With team 1: the target machines and the reference machine get `next-server 10.50.13.27` and the matching boot file via DHCP (`undionly.kpxe` for BIOS, `ipxe.efi` for UEFI).
2. **Linux image:** install a minimal Debian on target machine 1, capture it as `debian-referenz` (*capture*), deploy it to target machine 2 (*deploy*).
3. **Windows image:** capture the reference machine `.16` as `win-referenz` and deploy it to a target machine.
4. Optional: **multicast** to both target machines at the same time.

## Acceptance tests

| Test | Evidence |
|---|---|
| FOG runs | web interface reachable from the Windows test client, dashboard shows the storage node |
| PXE boot | target machine shows the FOG menu at boot (screenshot of the console) |
| Registration | target machines appear under *Hosts* with their MAC address |
| Capture | image `debian-referenz` has a size > 0 under *Images* |
| Deployment | target machine 2 boots the Debian from the reference machine after deployment (same computer name, same files) |

## Pitfalls

- No PXE menu: boot order in Proxmox (*Options → Boot Order*: network first), DHCP options, wrong boot file for BIOS/UEFI.
- Target disk smaller than the source: choose image type *Single Disk – Resizable*.
- In practice, Windows images are generalized beforehand with **Sysprep** so that 25 computers do not have the same identity. In the lab you may skip it; in the runbook it has to be explained.
- Images need a lot of space. The VM has about 60 GB, enough for two small images.
- The installer script changes a lot on the system (web server, database, TFTP, NFS). Take a snapshot first.

## Entry points

- FOG Project: [documentation](https://docs.fogproject.org/), [installation](https://docs.fogproject.org/en/latest/installation/), [source code](https://github.com/FOGProject/fogproject)
- FOG Project: [Using FOG with an unmodifiable DHCP server / ProxyDHCP](https://docs.fogproject.org/) (search for *DHCP*)
- iPXE: [documentation](https://ipxe.org/docs)
- Microsoft Learn: [Windows Autopilot (overview)](https://learn.microsoft.com/en-us/autopilot/overview), [Sysprep](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep--generalize--a-windows-installation)

## Comparison questions

- Image in-house (FOG) or deployment from the cloud (Autopilot): what does each solution need (licences, internet bandwidth, hardware IDs registered with the vendor)?
- How long does it take to set up 25 computers again with FOG, how long by hand?
- What happens to the students' data on the old disks?
- FOG is developed by a community. What does that mean for support in an emergency, what for vendor dependence?
