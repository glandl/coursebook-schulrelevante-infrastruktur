+++
title = "Rollenkarten"
weight = 20
+++

Jede Rollenkarte beschreibt **was** am Ende laufen muss, nicht **wie** jeder Klick aussieht. Den Weg dorthin findet ihr im Team mit der offiziellen Dokumentation (Abschnitt *Einstiegspunkte*). Genau diesen Weg haltet ihr im [Rollen-Runbook]({{% relref "../documentation" %}}) fest: Ein Runbook, das nur aus dem Buch abgeschrieben ist, hilft im Ernstfall niemandem.

Jede Karte hat dieselben Abschnitte:

| Abschnitt | Inhalt |
|---|---|
| **Die Rolle an einer Schule** | Wozu die Rolle da ist, mit einem Beispiel aus dem Schulalltag |
| **Abhängigkeiten** | Welche anderen Rollen vorher laufen müssen |
| **Ziel in der Windows-Welt** / **Ziel in der Linux-Welt** | Was am Ende der Einheit 1 läuft (für sich, ohne Domäne) |
| **Ziel in Einheit 2** | Wie die Rolle mit den anderen zusammenarbeitet |
| **Abnahmetests** | Wie ihr vom Testclient aus beweist, dass es funktioniert |
| **Stolpersteine** | Was erfahrungsgemäß schiefgeht |
| **Einstiegspunkte** | Offizielle Dokumentation (Primärquellen) |
| **Vergleichsfragen** | Fragen für Runbook und Präsentation |

{{% callout style="warning" title="Status: ungeprüft" %}}
Die Befehle, Paketnamen und Menüpunkte auf den Rollenkarten wurden noch **nicht** im Proxmox-Labor ausgeführt. Stand der Software-Angaben: November 2026 (Windows Server 2025, Debian 13 „trixie“). Prüft Versionen und Befehle in der offiziellen Dokumentation. *Getestet am: offen.*
{{% /callout %}}

**Grundregel für die Windows-Welt:** Bevorzugt **PowerShell**. Was ihr in PowerShell eingebt, kann man kopieren, prüfen und wiederholen. Ein Klickpfad im Server-Manager lässt sich nur schwer dokumentieren. Den Server-Manager dürft ihr zum Nachsehen verwenden.

**Grundregel für die Linux-Welt:** Konfiguration steht in **Textdateien** unter `/etc`. Legt vor jeder Änderung eine Sicherung an (`cp datei datei.orig`), dann ist das Zurücknehmen ein Befehl.

{{% pages display="tree" orderby="weight" %}}
