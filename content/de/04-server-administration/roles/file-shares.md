+++
title = "Team 4: Dateifreigaben"
weight = 4
+++

**Windows-Welt:** `10.50.13.13`, SMB-Freigaben mit NTFS-Berechtigungen · **Linux-Welt:** `10.50.13.24`, Samba (Debian-Container)

## Die Rolle an einer Schule

Die Klassenvorständin legt Arbeitsblätter in `Klassen\3B` ab, die Schülerinnen und Schüler der 3B dürfen sie lesen, aber nicht löschen. Jede Lehrperson hat einen eigenen Ordner, den niemand sonst sieht, und die Administration hat ein Laufwerk, das für Lehrende unsichtbar ist. Das sind **Freigaben** (wer kommt über das Netz an den Ordner) und **Dateiberechtigungen** (wer darf darin was). Die Regeln dafür stehen in einer Berechtigungsmatrix (siehe [VLAN- und Berechtigungsmatrizen]({{% relref "/00-documentation/vlan-permission-matrices" %}})).

## Abhängigkeiten

- Einheit 1: keine (lokale Benutzer und Gruppen auf dem Server).
- Einheit 2: Verzeichnisdienst (Team 3) für Domänenkonten und -gruppen.

## Berechtigungsmatrix (für beide Welten)

| Ordner | `GG-Lehrende` | `GG-Schueler` | Administration |
|---|---|---|---|
| `Klassen` | Lesen, Schreiben | Lesen | Vollzugriff |
| `Lehrende` | Lesen, Schreiben | **kein Zugriff, unsichtbar** | Vollzugriff |
| `Austausch` | Lesen, Schreiben | Lesen, Schreiben (nur eigene Dateien löschen) | Vollzugriff |

## Ziel in der Windows-Welt

- Rolle **Dateiserver** (`FS-FileServer`) installiert, Ordner unter `C:\Freigaben\…`.
- Drei Freigaben nach der Matrix, Freigabe-Berechtigung großzügig, die eigentliche Regel in den **NTFS-Berechtigungen**.
- **Zugriffsbasierte Aufzählung** (*Access-Based Enumeration*) eingeschaltet: Wer keinen Zugriff hat, sieht den Ordner nicht.
- Einheit 1 mit lokalen Gruppen `GG-Lehrende`, `GG-Schueler` und Testkonten.
- Hinweis: `New-SmbShare -FolderEnumerationMode AccessBased`, NTFS mit `icacls` oder `Get-Acl`/`Set-Acl`.

## Ziel in der Linux-Welt

- Paket `samba` installiert, drei Freigaben in `/etc/samba/smb.conf` nach der Matrix.
- Linux-Gruppen und -Benutzer, Samba-Kennwörter mit `smbpasswd -a`.
- Unsichtbarkeit: `access based share enum = yes` bzw. `hide unreadable = yes`.
- Dateirechte mit Besitzer, Gruppe und `chmod`, für den Ordner `Austausch` das *Sticky Bit* (`chmod +t`).
- Prüfen vor jedem Neustart: `testparm`.

## Ziel in Einheit 2

1. Beide Server treten der Domäne ihrer Welt bei (Windows: `Add-Computer`; Samba: als *Domain Member* mit `winbind`, nicht als Domänencontroller).
2. Die Berechtigungen gelten jetzt für **Domänengruppen** statt lokaler Gruppen.
3. **Kombination:** Der Windows-Testclient verbindet die **Samba**-Freigabe als Laufwerk, der Linux-Testclient die **Windows**-Freigabe.

## Abnahmetests

| Test | Windows-Testclient | Linux-Testclient |
|---|---|---|
| Freigaben auflisten | `net view \\10.50.13.13` | `smbclient -L //10.50.13.24 -U lehrer01` |
| Lehrende dürfen schreiben | als `lehrer01`: Datei in `\\10.50.13.13\Klassen` anlegen | `smbclient //10.50.13.24/Klassen -U lehrer01 -c 'put test.txt'` |
| Schüler dürfen nur lesen | als `schueler01`: Anlegen scheitert mit *Zugriff verweigert* | wie links mit `-U schueler01` |
| Unsichtbarkeit | `schueler01` sieht `Lehrende` nicht | wie links |
| Als Laufwerk (Einheit 2) | `New-PSDrive -Name K -PSProvider FileSystem -Root \\10.50.13.24\Klassen -Persist` | `sudo mount -t cifs //10.50.13.13/Klassen /mnt -o username=lehrer01` |

## Stolpersteine

- Unter Windows gilt immer die **strengere** von Freigabe- und NTFS-Berechtigung.
- **Vererbung:** Neue Unterordner erben die Rechte. Wer Vererbung abschaltet, muss alles selbst setzen.
- Samba: Linux-Dateirechte **und** Samba-Einstellungen (`valid users`, `read only`) gelten beide.
- SMB1 ist unsicher und auf beiden Seiten abgeschaltet. Nicht wieder einschalten, auch wenn ein altes Gerät danach fragt.

## Einstiegspunkte

- Microsoft Learn: [SMB-Dateifreigaben (Überblick)](https://learn.microsoft.com/de-de/windows-server/storage/file-server/file-server-smb-overview)
- Microsoft Learn: [New-SmbShare](https://learn.microsoft.com/de-de/powershell/module/smbshare/new-smbshare), [icacls](https://learn.microsoft.com/de-de/windows-server/administration/windows-commands/icacls)
- Samba Wiki: [Setting up Samba as a Standalone Server](https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Standalone_Server), [Setting up Samba as a Domain Member](https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Domain_Member)
- Samba: `man smb.conf`

## Vergleichsfragen

- Wo ist die Berechtigungsmatrix leichter umzusetzen, wo leichter zu **überprüfen**?
- Speicherplatz pro Person begrenzen (Kontingente): Wie geht das in jeder Welt?
- Ein Windows-Client merkt nicht, dass hinter der Freigabe Linux läuft. Was heißt das für die Wahl des Servers an einer Schule?
- Welche Alternative wäre ein Cloud-Speicher (OneDrive, Nextcloud aus [Kapitel 1]({{% relref "/01-virtualization-containerization" %}}))? Was wird dabei aus der Berechtigungsmatrix und dem Datenschutz?
