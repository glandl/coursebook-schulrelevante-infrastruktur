+++
title = "Team 3: Verzeichnisdienst"
weight = 3
+++

**Windows-Welt:** `10.50.13.12`, Active Directory Domain Services (AD DS) · **Linux-Welt:** `10.50.13.23`, Samba als Active-Directory-Domänencontroller (Debian-**VM**)

Dieses Team ist zu dritt, weil fast alle anderen Rollen in Einheit 2 auf euch warten.

## Die Rolle an einer Schule

Eine Lehrerin meldet sich mit **einem** Konto am Rechner im Lehrerzimmer, im EDV-Raum und am Beamer-PC an. Ihr Klassenordner ist überall da, der Drucker auch, und wenn sie die Schule verlässt, sperrt die Administration **ein** Konto statt zwanzig. Das leistet ein **Verzeichnisdienst**: eine zentrale Liste von Benutzern, Gruppen und Geräten, mit Anmeldung (Kerberos), Abfrage (LDAP) und Richtlinien. In Österreich ist das an vielen Schulen ein Active Directory.

## Abhängigkeiten

- Feste Adresse und ein **endgültiger Rechnername** **vor** dem Einrichten. Einen Domänencontroller benennt man nicht mehr um.
- DNS: Der Domänencontroller wird selbst DNS-Server seiner Domäne. Weiterleitung an `10.50.13.254`.
- **Uhrzeit:** Kerberos verweigert die Anmeldung, wenn die Uhren mehr als 5 Minuten auseinanderliegen.

## Ziel in der Windows-Welt

- Rechnername `dc` (vollständig `dc.win.schule.lan`), feste Adresse `10.50.13.12`, DNS-Server `127.0.0.1`.
- Rolle **AD DS** installiert, neue Gesamtstruktur `win.schule.lan`, NetBIOS-Name `WINSCHULE`, DNS-Server integriert.
- Organisationseinheiten `Lehrende`, `Schueler`, `Gruppen`, `Geraete`.
- Testkonten `lehrer01`–`lehrer03`, `schueler01`–`schueler05`, Gruppen `GG-Lehrende`, `GG-Schueler`.
- Hinweis: `Install-WindowsFeature AD-Domain-Services -IncludeManagementTools`, danach `Install-ADDSForest`. Konten mit `New-ADOrganizationalUnit`, `New-ADUser`, `New-ADGroup`.

## Ziel in der Linux-Welt

- Die Debian-VM ist installiert (Debian-13-Image ist eingebunden, minimal, **ohne** grafische Oberfläche, mit SSH-Server).
- Rechnername `dc` (vollständig `dc.linux.schule.lan`), feste Adresse `10.50.13.23`, Eintrag in `/etc/hosts`.
- Samba als **AD-Domänencontroller** für `linux.schule.lan`, NetBIOS-Name `LXSCHULE`, interner DNS-Server von Samba mit Weiterleitung an `10.50.13.254`.
- Dieselben Organisationseinheiten, Konten und Gruppen wie in der Windows-Welt.
- Hinweis: Pakete `samba`, `krb5-user`, `winbind`, `smbclient`. Einrichten mit `samba-tool domain provision`, Konten mit `samba-tool user add`, `samba-tool group add`, `samba-tool ou add`. Der Dienst heißt `samba-ad-dc`; die Dienste `smbd`, `nmbd` und `winbind` werden auf einem Domänencontroller **abgeschaltet**.

{{% callout style="info" title="Warum eine VM und kein Container?" %}}
Samba speichert die Berechtigungen der Anmeldeskripte und Richtlinien (`sysvol`) in erweiterten Dateiattributen und ACLs. In einem unprivilegierten Linux-Container funktioniert das oft nicht oder nur teilweise. Deshalb läuft der Linux-Domänencontroller als eigene VM.
{{% /callout %}}

## Ziel in Einheit 2

1. Die **Testclients** treten den Domänen bei: der Windows-Testclient `win.schule.lan`, der Linux-Testclient `linux.schule.lan` (mit `realm join`, Pakete `realmd` und `sssd`).
2. Die Server der Teams 4, 5 und 8 treten der Domäne ihrer Welt bei, damit Freigaben, Drucker und Fernzugriff mit Domänenkonten funktionieren. Ihr unterstützt die Teams dabei.
3. **Kombination:** Ein zweiter Linux-Rechner (z. B. der Container eines anderen Teams) tritt der **Windows**-Domäne bei, oder der Windows-Testclient meldet sich an der **Samba**-Domäne an. Beides funktioniert, weil Samba dieselben Protokolle spricht (LDAP, Kerberos, SMB).
4. Bedingte DNS-Weiterleitungen gemeinsam mit Team 2.

## Abnahmetests

| Test | Windows-Testclient | Linux-Testclient |
|---|---|---|
| Domänencontroller per DNS gefunden | `Resolve-DnsName _ldap._tcp.win.schule.lan -Type SRV` | `host -t SRV _ldap._tcp.linux.schule.lan` |
| Kerberos-Anmeldung | Anmeldung als `WINSCHULE\lehrer01` | `kinit lehrer01@LINUX.SCHULE.LAN`, dann `klist` |
| Konten abfragen | `Get-ADUser -Filter * -SearchBase "OU=Lehrende,DC=win,DC=schule,DC=lan"` (auf dem DC) | `samba-tool user list` (auf dem DC) |
| Gruppenmitgliedschaft am Client | `whoami /groups` | `id lehrer01@linux.schule.lan` |

## Stolpersteine

- **Rechnername oder Adresse nach dem Einrichten geändert:** Domäne neu aufsetzen (Snapshot!).
- Der Domänencontroller zeigt mit seinem DNS-Eintrag **auf sich selbst**, nicht auf `10.50.13.254`. Sonst findet er seine eigenen SRV-Einträge nicht.
- Samba: `/etc/samba/smb.conf` vor `samba-tool domain provision` **löschen** oder umbenennen, und `/etc/krb5.conf` danach durch die erzeugte Datei ersetzen.
- Samba: `/etc/resolv.conf` muss auf `127.0.0.1` bzw. die eigene Adresse zeigen.
- Domänennamen auf `.local` vermeiden (kollidiert mit Multicast-DNS bei Apple-Geräten).
- Kennwortrichtlinie: Testkonten brauchen Kennwörter, die die Standardrichtlinie erfüllen.

## Einstiegspunkte

- Microsoft Learn: [AD DS mit PowerShell installieren](https://learn.microsoft.com/de-de/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-)
- Microsoft Learn: [ActiveDirectory-Modul (PowerShell)](https://learn.microsoft.com/de-de/powershell/module/activedirectory/)
- Samba Wiki: [Setting up Samba as an Active Directory Domain Controller](https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller)
- Samba Wiki: [Distribution-specific Package Installation](https://wiki.samba.org/index.php/Distribution-specific_Package_Installation)
- Debian Wiki: [AD Server mit Samba](https://wiki.debian.org/AD%20Server)

## Vergleichsfragen

- Samba kann viel von Active Directory, aber nicht alles (z. B. Teile der Gruppenrichtlinien, Verwaltung nur mit Windows-Werkzeugen RSAT oder Kommandozeile). Was davon braucht eine Schule wirklich?
- Was kostet ein Domänencontroller in jeder Welt: Server-Lizenz, Zugriffslizenzen (CAL) für jeden Lehrenden und jedes Kind?
- Wie viele Personen an einer Schule können eine Samba-Domäne im Notfall betreuen, wie viele ein Active Directory?
- Ein Verzeichnisdienst enthält Namen, Klassen und Anmeldezeiten Minderjähriger. Wo liegen die Daten, wer hat Zugriff, wer ist verantwortlich?
- Microsoft bewirbt zunehmend die Cloud (Entra ID). Was würde der Umstieg für eure Rolle bedeuten?
