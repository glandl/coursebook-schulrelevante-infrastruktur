# School-related IT Infrastructure (course)

Language used in the coursebook and its planning for a teacher-training course on running school IT. Sessions 3-4 build a shared school network out of server roles on the lecturer's Proxmox server.

## Server-roles block

**Server role**:
One service a school network needs (e.g. DHCP, DNS, directory, file shares), seen independently of the product that provides it.
_Avoid_: feature, service (when meaning the role), server (when meaning the role)

**Lab VLAN**:
The single network on the lecturer's Proxmox server that all lab VMs and containers share, with internet access and separated from the lecturer's production network.
_Avoid_: lab network, school network (when meaning the Proxmox setup)

**Windows world**:
The set of Windows Server 2025 VMs in the lab VLAN that provide every server role the Windows way.
_Avoid_: Windows lab, Windows side

**Linux world**:
The set of Debian 13 LXC containers in the same lab VLAN that provide every server role with open-source Linux tools.
_Avoid_: Linux lab, Linux side, open-source world

**Role team**:
A pair of students (one trio) that owns one server role and builds it in both the Windows world and the Linux world.
_Avoid_: group, pair (when meaning the team's responsibility)

**Role presentation**:
The short talk at the end of the block where a role team shows its server role in both worlds and compares them for the others.
_Avoid_: demo (reserved for what the lecturer shows), showcase

**Test client**:
A client machine (one Windows, one Linux) in the lab VLAN, provided by the lecturer, that proves a server role works from the user's point of view.
_Avoid_: client VM, workstation

**Lab router**:
The lecturer-owned gateway of the lab VLAN that gives internet access and forwards DNS; no role team configures it.
_Avoid_: gateway (when meaning this machine), firewall
