+++
title = "Access to the Proxmox lab"
weight = 15
+++

All servers and test clients of this chapter run on the lecturer's **Proxmox VE server**. Proxmox itself is an example of the Linux world: a free hypervisor based on Debian that manages virtual machines (VMs) and Linux containers (LXC) (see [chapter 1]({{% relref "/01-virtualization-containerization" %}})).

## Logging in

1. You get the address of the Proxmox web interface and your credentials in the session.
2. When logging in, choose `Proxmox VE authentication server` as the **realm**.
3. In the tree on the left you see only the machines of **your team** (pool `pool-team<N>`) and the two **test clients**.

{{% callout style="warning" title="Console only" %}}
The lab VLAN is **not** reachable from the university network. So you **cannot** connect from your laptop via SSH or Remote Desktop. Everything runs through the **console** in the Proxmox web interface, and all tests run inside the lab. For tests "from outside", use the test clients or a machine of another team.
{{% /callout %}}

## Using the console

| Machine | Console | Tip |
|---|---|---|
| Windows Server (VM) | *Console* (noVNC) | Ctrl+Alt+Del via the menu on the left (*Send Key*). Copy and paste works only partially in noVNC. Paste longer commands via the clipboard button on the left. |
| Debian container (LXC) | *Console* (xterm.js) | Paste with Ctrl+Shift+V or right-click. Log in as `root` or with the account the lecturer created. |
| Debian VM (teams 3 and 7) | *Console* | Installation from the Debian image that is already attached (see role card). |
| Test clients | *Console* (noVNC) | Graphical desktop. Before testing, announce briefly in the team channel who is using the test client. |

## What you may do in Proxmox

| You may | You may not |
|---|---|
| open the console, start, shut down, restart | create or delete machines or change their hardware |
| create and roll back **snapshots** of your machines | see or operate other teams' machines |
| change the ISO image in the CD drive | change network settings in Proxmox |
| use and restart the test clients | reset the test clients (lecturer only) |

## Snapshots: your way back

Each of your machines has the snapshot **`clean-start`**, the state before the first session. Create your own snapshot **before every bigger step** (*Snapshots → Take Snapshot*), e.g. `before-dhcp-scope`. If something goes wrong, you roll back with *Rollback*.

A snapshot is handy, but **no substitute for the "undo" column in the runbook**: at a school there is no simple rollback button for the production domain controller.

## Lab rules

1. **Static addresses only from your range** (see the IP plan in the [chapter overview]({{% relref "/04-server-administration" %}})). A duplicate address knocks out another team's machine.
2. **No additional DHCP server.** In the lab VLAN only team 1's Windows DHCP server and Kea hand out addresses, and only to the test clients. Many programs (e.g. FOG, Docker, dnsmasq) offer to start their own DHCP server: always **decline**.
3. **The lab router `10.50.13.254` is off limits.** It is the gateway and DNS forwarder for everyone.
4. **No real personal data.** User accounts are called e.g. `lehrer01`, `schueler01`, not like real people.
5. **Passwords** for test accounts appear in the runbook only as placeholders (`<password from password manager>`), never in plain text in the portfolio.
6. **Windows evaluation:** the Windows Server VMs run the **evaluation edition** (180 days from installation). It is meant for the lab, not for operation at a school.
