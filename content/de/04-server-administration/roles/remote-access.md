+++
title = "Team 8: Fernzugriff"
weight = 8
+++

**Windows-Welt:** `10.50.13.17`, Remotedesktop (RDP) · **Linux-Welt:** `10.50.13.28`, OpenSSH und xrdp (Debian-Container)

## Die Rolle an einer Schule

Der Kustos sitzt zu Hause, und am Server im Keller hängt ein Dienst. Statt in die Schule zu fahren, verbindet er sich über das Netz. Oder: Schülerinnen und Schüler arbeiten von schwachen Laptops aus auf einem leistungsfähigen Server mit Programmen, die sie selbst nicht installieren können. Beides ist **Fernzugriff**: als **Kommandozeile** (SSH, PowerShell-Remoting) für die Administration und als **grafischer Desktop** (RDP) für die Arbeit mit Programmen.

## Abhängigkeiten

- Einheit 1: keine (lokale Konten).
- Einheit 2: Verzeichnisdienst (Team 3) für die Anmeldung mit Domänenkonten.

## Ziel in der Windows-Welt

- **Remotedesktop** eingeschaltet, mit *Authentifizierung auf Netzwerkebene* (NLA), Firewall-Regel nur für das Labor-VLAN.
- Eine lokale Gruppe darf sich anmelden (*Remotedesktopbenutzer*), andere nicht.
- **PowerShell-Remoting** (WinRM) für die Administration eingeschaltet.
- Hinweis: Registry-Wert `fDenyTSConnections`, `Enable-NetFirewallRule`, `Enable-PSRemoting`.

{{% callout style="info" title="Zwei Sitzungen oder mehr?" %}}
Windows Server erlaubt **zwei** gleichzeitige Remotedesktop-Sitzungen zur **Administration** ohne Zusatzlizenz. Für mehr Benutzer braucht man die Rolle *Remotedesktop-Sitzungshost* und **RDS-Zugriffslizenzen** (RDS CAL) pro Benutzer oder Gerät. Die Sitzungshost-Rolle installiert ihr im Labor **nicht**, aber im Vergleich gehört sie erklärt.
{{% /callout %}}

## Ziel in der Linux-Welt

- **OpenSSH-Server** läuft, Anmeldung mit **Schlüssel** statt Kennwort, `root` darf sich nicht direkt anmelden.
- **xrdp** mit einer schlanken Oberfläche (Xfce) als grafischer Fernzugriff. Beliebig viele gleichzeitige Sitzungen, keine Zugriffslizenzen.
- Nur Mitglieder einer Gruppe (`fernzugriff`) dürfen sich per SSH und RDP anmelden.
- Hinweis: Pakete `openssh-server`, `xrdp`, `xfce4`; Konfiguration in `/etc/ssh/sshd_config.d/` und `/etc/xrdp/`. Prüfen mit `sshd -t`.

## Ziel in Einheit 2

1. Anmeldung mit **Domänenkonten** (Windows-Server tritt `win.schule.lan` bei, der Container `linux.schule.lan` mit `sssd`).
2. **Kombination:** Der Windows-Testclient öffnet mit der Remotedesktopverbindung (`mstsc`) eine Sitzung **auf dem Linux-Container** (xrdp spricht RDP). Der Linux-Testclient öffnet mit *Remmina* eine Sitzung auf dem Windows-Server.
3. Windows hat seit einigen Jahren selbst einen **OpenSSH-Server** eingebaut. Schaltet ihn ein und verbindet euch per SSH auf Windows.
4. Optional: [Apache Guacamole](https://guacamole.apache.org/) als Fernzugriff **im Browser**, ohne Programm am Client.

## Abnahmetests

| Test | Windows-Testclient | Linux-Testclient |
|---|---|---|
| Kommandozeile | `Enter-PSSession -ComputerName 10.50.13.17` bzw. `ssh lehrer01@10.50.13.28` | `ssh lehrer01@10.50.13.28` |
| Grafischer Desktop | `mstsc /v:10.50.13.17` und `mstsc /v:10.50.13.28` | Remmina auf `10.50.13.17` und `10.50.13.28` |
| Nur die Gruppe | `schueler01` (nicht in der Gruppe) wird abgewiesen | wie links |
| Kennwort-Anmeldung gesperrt | | `ssh -o PubkeyAuthentication=no lehrer01@10.50.13.28` wird abgewiesen |

## Stolpersteine

- Remotedesktop **niemals** direkt ins Internet öffnen. Von außen nur über VPN oder ein Gateway mit Mehrfaktor-Anmeldung.
- SSH: Wer die Kennwort-Anmeldung abschaltet, bevor sein Schlüssel funktioniert, sperrt sich aus. In Proxmox hilft die Konsole; an einer Schule nicht immer.
- Windows-Firewall-Regeln heißen je nach Systemsprache anders. Regeln über die Gruppe (`-Group`) statt über den angezeigten Namen ansprechen.
- xrdp im Container: Die Oberfläche (Xfce) muss im Container installiert sein, sonst bleibt der Bildschirm nach der Anmeldung schwarz.

## Einstiegspunkte

- Microsoft Learn: [Remotedesktop aktivieren](https://learn.microsoft.com/de-de/windows-server/remote/remote-desktop-services/clients/remote-desktop-allow-access), [Lizenzierung der Remotedesktopdienste](https://learn.microsoft.com/de-de/windows-server/remote/remote-desktop-services/rds-client-access-license)
- Microsoft Learn: [OpenSSH für Windows](https://learn.microsoft.com/de-de/windows-server/administration/openssh/openssh_overview), [Enable-PSRemoting](https://learn.microsoft.com/de-de/powershell/module/microsoft.powershell.core/enable-psremoting)
- OpenSSH: `man sshd_config`; Debian Wiki: [SSH](https://wiki.debian.org/SSH)
- xrdp: [Projektseite und Wiki](https://github.com/neutrinolabs/xrdp)

## Vergleichsfragen

- Was kostet es, 25 Schülerinnen und Schülern gleichzeitig einen Server-Desktop zu geben, in jeder Welt?
- Welche Protokolle sind offen, welche herstellerspezifisch? (Tipp: RDP ist dokumentiert, xrdp spricht es.)
- Wer darf an einer Schule aus der Ferne auf Server zugreifen, und wie wird das protokolliert?
- Welche Lösung würdet ihr einem Lehrenden-Team empfehlen, das nur einen halben Tag pro Woche für die IT hat?
