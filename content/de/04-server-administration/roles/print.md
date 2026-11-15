+++
title = "Team 5: Drucken"
weight = 5
+++

**Windows-Welt:** `10.50.13.14`, Druckserver · **Linux-Welt:** `10.50.13.25`, CUPS (Debian-Container)

## Die Rolle an einer Schule

Im Lehrerzimmer steht ein Multifunktionsgerät, im EDV-Raum ein zweites. Lehrende sollen auf beiden drucken, Schülerinnen und Schüler nur im EDV-Raum, und am Ende des Monats will die Direktion wissen, wie viele Seiten gedruckt wurden. Ein **Druckserver** nimmt die Aufträge aller Geräte an, stellt die Treiber bereit, regelt, wer drucken darf, und sammelt Aufträge in einer Warteschlange.

Im Labor gibt es **keine** echten Drucker. Ihr verwendet **virtuelle Drucker**, die jeden Auftrag in eine Datei schreiben. Damit lässt sich alles prüfen außer dem Papier.

## Abhängigkeiten

- Einheit 1: keine.
- Einheit 2: Verzeichnisdienst (Team 3) für Domänengruppen, DNS (Team 2) für Namen statt Adressen.

## Ziel in der Windows-Welt

- Rolle **Druck- und Dokumentdienste** (`Print-Server`) installiert.
- Zwei freigegebene Drucker `Lehrerzimmer` und `EDV-Raum`, jeweils mit dem Treiber *Microsoft IPP Class Driver* oder *Generic / Text Only* und einem lokalen Anschluss, der in eine Datei schreibt (z. B. `C:\Druck\lehrerzimmer.prn`).
- Berechtigungen: `Lehrerzimmer` nur für `GG-Lehrende`, `EDV-Raum` für beide Gruppen.
- Hinweis: PowerShell-Modul `PrintManagement`, z. B. `Add-PrinterPort`, `Add-Printer -Shared`.

## Ziel in der Linux-Welt

- Pakete `cups` und `printer-driver-cups-pdf` installiert. Der virtuelle Drucker legt PDF-Dateien ab.
- Zwei Warteschlangen `Lehrerzimmer` und `EDV-Raum`, im Netz freigegeben, Weboberfläche nur aus `10.50.13.0/24` erreichbar.
- Zugriffsregeln pro Warteschlange (`lpadmin -u allow:…`).
- Hinweis: Konfiguration mit `lpadmin` und `cupsctl`, Weboberfläche auf Port `631`.

## Ziel in Einheit 2

1. Die Drucker werden über **Domänengruppen** freigegeben.
2. Der Windows-Testclient verbindet den Windows-Drucker als `\\win-print.labor.test\Lehrerzimmer` (Name von Team 2).
3. **Kombination:** Der Windows-Testclient druckt über **IPP** auf CUPS (`http://10.50.13.25:631/printers/EDV-Raum`), der Linux-Testclient auf den Windows-Druckserver.

## Abnahmetests

| Test | Windows-Testclient | Linux-Testclient |
|---|---|---|
| Drucker sichtbar | `Get-Printer -ComputerName 10.50.13.14` | `lpstat -h 10.50.13.25 -p` |
| Testseite | als `lehrer01` auf `Lehrerzimmer` drucken, Datei auf dem Server prüfen | `lp -h 10.50.13.25 -d EDV-Raum /etc/hostname`, PDF auf dem Server prüfen |
| Berechtigung | `schueler01` kann auf `Lehrerzimmer` **nicht** drucken | wie links |
| Warteschlange | `Get-PrintJob -ComputerName 10.50.13.14 -PrinterName Lehrerzimmer` | `lpstat -h 10.50.13.25 -o` |

## Stolpersteine

- Der Treiber *Microsoft Print to PDF* fragt **am Server** nach einem Dateinamen und blockiert dort. Für einen freigegebenen Drucker ungeeignet.
- Druckertreiber waren jahrelang eine große Sicherheitslücke (z. B. *PrintNightmare*, 2021). Microsoft führt deshalb einen geschützten Druckmodus ein, der nur noch den IPP-Standardtreiber erlaubt. Prüft den aktuellen Stand in der Dokumentation.
- CUPS-Weboberfläche nicht für alle Netze öffnen. Administration nur von `localhost` oder mit Anmeldung.
- In einem unprivilegierten Container darf CUPS keine USB-Geräte ansprechen. Für Netzwerkdrucker spielt das keine Rolle.

## Einstiegspunkte

- Microsoft Learn: [Druck- und Dokumentdienste (Überblick)](https://learn.microsoft.com/de-de/windows-server/administration/print/print-and-document-services-overview), [PrintManagement-Modul](https://learn.microsoft.com/de-de/powershell/module/printmanagement/)
- Microsoft Learn: [Windows protected print mode](https://learn.microsoft.com/de-de/windows-hardware/drivers/print/windows-protected-print-mode)
- OpenPrinting: [CUPS-Dokumentation](https://openprinting.github.io/cups/), [IPP Everywhere](https://www.pwg.org/ipp/everywhere.html)
- Debian Wiki: [CUPS](https://wiki.debian.org/CUPS)

## Vergleichsfragen

- Beide Welten bewegen sich zum selben offenen Standard (IPP, treiberlos). Wo ist er heute schon „zu Hause“?
- Druckkontingente und Abrechnung pro Klasse: Was bringt jede Welt mit, was braucht Zusatzsoftware?
- Microsoft bietet *Universal Print* als Cloud-Dienst an. Was bedeutet es für den Datenschutz, wenn Dokumente von Schülerinnen und Schülern über die Cloud zum Drucker gehen?
- Wer kümmert sich an einer Schule um Druckertreiber, und wie viel Zeit kostet das im Jahr?
