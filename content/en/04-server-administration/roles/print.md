+++
title = "Team 5: Printing"
weight = 5
+++

**Windows world:** `10.50.13.14`, print server · **Linux world:** `10.50.13.25`, CUPS (Debian container)

## The role at a school

There is a multifunction device in the staff room and a second one in the computer lab. Teachers should be able to print on both, students only in the computer lab, and at the end of the month the head wants to know how many pages were printed. A **print server** accepts the jobs of all devices, provides the drivers, controls who may print, and collects jobs in a queue.

There are **no** real printers in the lab. You use **virtual printers** that write every job to a file. That lets you check everything except the paper.

## Dependencies

- Session 1: none.
- Session 2: directory service (team 3) for domain groups, DNS (team 2) for names instead of addresses.

## Goal in the Windows world

- **Print and Document Services** role (`Print-Server`) installed.
- Two shared printers `Lehrerzimmer` and `EDV-Raum`, each with the driver *Microsoft IPP Class Driver* or *Generic / Text Only* and a local port that writes to a file (e.g. `C:\Druck\lehrerzimmer.prn`).
- Permissions: `Lehrerzimmer` only for `GG-Lehrende`, `EDV-Raum` for both groups.
- Hint: PowerShell module `PrintManagement`, e.g. `Add-PrinterPort`, `Add-Printer -Shared`.

## Goal in the Linux world

- Packages `cups` and `printer-driver-cups-pdf` installed. The virtual printer stores PDF files.
- Two queues `Lehrerzimmer` and `EDV-Raum`, shared on the network, web interface reachable only from `10.50.13.0/24`.
- Access rules per queue (`lpadmin -u allow:…`).
- Hint: configuration with `lpadmin` and `cupsctl`, web interface on port `631`.

## Goal in session 2

1. The printers are shared via **domain groups**.
2. The Windows test client connects the Windows printer as `\\win-print.labor.test\Lehrerzimmer` (name from team 2).
3. **Combination:** the Windows test client prints to CUPS via **IPP** (`http://10.50.13.25:631/printers/EDV-Raum`), the Linux test client to the Windows print server.

## Acceptance tests

| Test | Windows test client | Linux test client |
|---|---|---|
| Printers visible | `Get-Printer -ComputerName 10.50.13.14` | `lpstat -h 10.50.13.25 -p` |
| Test page | as `lehrer01`, print to `Lehrerzimmer`, check the file on the server | `lp -h 10.50.13.25 -d EDV-Raum /etc/hostname`, check the PDF on the server |
| Permission | `schueler01` **cannot** print to `Lehrerzimmer` | as on the left |
| Queue | `Get-PrintJob -ComputerName 10.50.13.14 -PrinterName Lehrerzimmer` | `lpstat -h 10.50.13.25 -o` |

## Pitfalls

- The *Microsoft Print to PDF* driver asks for a file name **on the server** and blocks there. Unsuitable for a shared printer.
- Printer drivers were a major security hole for years (e.g. *PrintNightmare*, 2021). Microsoft is therefore introducing a protected print mode that only allows the standard IPP driver. Check the current status in the documentation.
- Do not open the CUPS web interface to all networks. Administration only from `localhost` or with login.
- In an unprivileged container CUPS may not access USB devices. For network printers that does not matter.

## Entry points

- Microsoft Learn: [Print and Document Services (overview)](https://learn.microsoft.com/en-us/windows-server/administration/print/print-and-document-services-overview), [PrintManagement module](https://learn.microsoft.com/en-us/powershell/module/printmanagement/)
- Microsoft Learn: [Windows protected print mode](https://learn.microsoft.com/en-us/windows-hardware/drivers/print/windows-protected-print-mode)
- OpenPrinting: [CUPS documentation](https://openprinting.github.io/cups/), [IPP Everywhere](https://www.pwg.org/ipp/everywhere.html)
- Debian Wiki: [CUPS](https://wiki.debian.org/CUPS)

## Comparison questions

- Both worlds are moving towards the same open standard (IPP, driverless). Where is it already "at home" today?
- Print quotas and accounting per class: what does each world bring along, what needs additional software?
- Microsoft offers *Universal Print* as a cloud service. What does it mean for data protection when students' documents travel through the cloud to the printer?
- Who looks after printer drivers at a school, and how much time does that cost per year?
