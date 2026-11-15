+++
title = "Learning goals"
weight = 10
+++

After these two sessions you can:

1. explain what a **server role** is, and describe each of the eight roles of a school network (DHCP, DNS, directory service, file shares, printing, web, client deployment, remote access) with an **example from everyday school life**,
2. set up, test and undo **one role** in the **Windows world** (Windows Server 2025, preferably with PowerShell) **and** in the **Linux world** (Debian 13, free software),
3. prove with **acceptance tests** from a test client that a role works from the users' point of view,
4. name the **dependencies** between the roles (no directory service without DNS, no domain accounts for shares, printers and remote access without a directory service) and narrow down faults along this chain,
5. **combine** the Windows and Linux worlds (e.g. a Linux client on Active Directory, a Windows client on a Samba share) and explain which open protocols make this work (DHCP, DNS, LDAP, Kerberos, SMB, IPP, HTTP, PXE),
6. **compare** both solutions of a role with reasons: licence costs, operating effort, vendor dependence, further development, data protection and suitability for support by a team of teachers,
7. document your own work as a **role runbook**, with copyable commands and a column for undoing each step,
8. explain your own role in a **short presentation** to others who did not build it themselves.

*Mapping to the competency list: to follow (placeholder).*
