+++
title = "Sicherheit und Datenschutz"
weight = 80
+++

{{% callout style="warning" title="Keine Rechtsberatung" %}}
Dieser Abschnitt gibt eine technische Orientierung. Rechtliche Fragen (z. B. Rechtsgrundlage, Speicherdauer, Auftragsverarbeitung) klärt die Schule mit der Datenschutzbeauftragten bzw. dem Datenschutzbeauftragten und dem Schulerhalter.
{{% /callout %}}

## Das Wichtigste in Kürze

| Thema | Maßnahme |
|---|---|
| **Wenige Administratorkonten** | Für die tägliche Arbeit ein normales Konto, für die Administration ein eigenes Administratorkonto. Der Domänen-Administrator wird nur für Domänenaufgaben verwendet. |
| **Ein Dienst, ein Server** | Jede Rolle auf einem eigenen Server oder Container: Ein Fehler oder Angriff auf den Webserver erreicht nicht gleich den Domänencontroller. Genau so ist das Labor aufgebaut. |
| **Nur nötige Dienste** | Was nicht gebraucht wird, wird nicht installiert. Server Core und minimale Debian-Installationen haben weniger Angriffsfläche. |
| **Updates** | Server regelmäßig aktualisieren, auch im Labor. Debian: `unattended-upgrades` für Sicherheitsupdates. Windows: Windows Update. |
| **Fernzugriff** | Remotedesktop und SSH nie direkt aus dem Internet. SSH mit Schlüsseln, Remotedesktop mit NLA, von außen nur über VPN mit Mehrfaktor-Anmeldung. |
| **Offene Resolver und DHCP** | DNS beantwortet rekursive Anfragen nur aus dem eigenen Netz. Nur ein geplanter DHCP-Server pro Netz, fremde DHCP-Server werden am Switch blockiert (*DHCP Snooping*). |
| **Verschlüsselung** | Webseiten nur mit HTTPS. Interne Zertifikate aus einer eigenen Zertifizierungsstelle statt Browserwarnungen wegklicken. SMB1 bleibt abgeschaltet. |
| **Sicherung** | Domänencontroller, Freigaben und Konfigurationsdateien werden gesichert, und die Wiederherstellung wird geübt. Ein Snapshot ist keine Sicherung. |

## Datenschutz im Schulkontext

- **Verzeichnisdienst:** Er enthält Namen, Klassenzugehörigkeit, Anmeldezeiten und Gruppen Minderjähriger. Das gehört in das Verzeichnis der Verarbeitungstätigkeiten (siehe [Dokumentationsskript]({{% relref "/00-documentation/processing-register-adr" %}})).
- **Protokolle:** DHCP (welches Gerät wann im Netz), DNS (welche Seiten aufgerufen werden), Druckserver (wer was druckt) und Fernzugriff (wer sich wann anmeldet) erzeugen personenbezogene Protokolle. Festlegen, wer sie sehen darf und wann sie gelöscht werden.
- **Eigener Server oder Cloud:** Bei Rollen in der Cloud (Entra ID, Universal Print, Autopilot) liegen die Daten bei einem Anbieter. Das braucht einen Auftragsverarbeitungsvertrag und eine Prüfung, wo die Daten verarbeitet werden. Bei eigenen Servern trägt die Schule die Verantwortung für Betrieb und Sicherheit selbst.
- **Abbilder (Team 7):** Ein Festplattenabbild kann Daten der letzten Person enthalten, die den Referenzrechner benutzt hat. Referenzrechner nie mit echten Konten verwenden. Alte Festplatten vor der Weitergabe sicher löschen.
- **Testdaten:** Im Labor nur erfundene Namen (`lehrer01`, `schueler01`). Keine echten Klassenlisten.
