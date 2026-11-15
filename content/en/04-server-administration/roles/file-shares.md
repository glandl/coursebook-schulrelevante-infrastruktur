+++
title = "Team 4: File shares"
weight = 4
+++

**Windows world:** `10.50.13.13`, SMB shares with NTFS permissions · **Linux world:** `10.50.13.24`, Samba (Debian container)

## The role at a school

The class teacher puts worksheets into `Klassen\3B`; the students of 3B may read them but not delete them. Every teacher has a personal folder nobody else sees, and the administration has a drive that is invisible to teachers. These are **shares** (who gets to the folder over the network) and **file permissions** (who may do what inside it). The rules are written down in a permission matrix (see [VLAN and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).

## Dependencies

- Session 1: none (local users and groups on the server).
- Session 2: directory service (team 3) for domain accounts and groups.

## Permission matrix (for both worlds)

| Folder | `GG-Lehrende` | `GG-Schueler` | Administration |
|---|---|---|---|
| `Klassen` | read, write | read | full control |
| `Lehrende` | read, write | **no access, invisible** | full control |
| `Austausch` | read, write | read, write (may delete only own files) | full control |

## Goal in the Windows world

- **File Server** role (`FS-FileServer`) installed, folders under `C:\Freigaben\…`.
- Three shares according to the matrix, share permission generous, the actual rule in the **NTFS permissions**.
- **Access-based enumeration** switched on: whoever has no access does not see the folder.
- Session 1 with local groups `GG-Lehrende`, `GG-Schueler` and test accounts.
- Hint: `New-SmbShare -FolderEnumerationMode AccessBased`, NTFS with `icacls` or `Get-Acl`/`Set-Acl`.

## Goal in the Linux world

- Package `samba` installed, three shares in `/etc/samba/smb.conf` according to the matrix.
- Linux groups and users, Samba passwords with `smbpasswd -a`.
- Invisibility: `access based share enum = yes` or `hide unreadable = yes`.
- File permissions with owner, group and `chmod`; for the folder `Austausch` the *sticky bit* (`chmod +t`).
- Check before every restart: `testparm`.

## Goal in session 2

1. Both servers join the domain of their world (Windows: `Add-Computer`; Samba: as a *domain member* with `winbind`, not as a domain controller).
2. The permissions now apply to **domain groups** instead of local groups.
3. **Combination:** the Windows test client maps the **Samba** share as a drive, the Linux test client the **Windows** share.

## Acceptance tests

| Test | Windows test client | Linux test client |
|---|---|---|
| List shares | `net view \\10.50.13.13` | `smbclient -L //10.50.13.24 -U lehrer01` |
| Teachers may write | as `lehrer01`: create a file in `\\10.50.13.13\Klassen` | `smbclient //10.50.13.24/Klassen -U lehrer01 -c 'put test.txt'` |
| Students may only read | as `schueler01`: creating fails with *Access denied* | as on the left with `-U schueler01` |
| Invisibility | `schueler01` does not see `Lehrende` | as on the left |
| As a drive (session 2) | `New-PSDrive -Name K -PSProvider FileSystem -Root \\10.50.13.24\Klassen -Persist` | `sudo mount -t cifs //10.50.13.13/Klassen /mnt -o username=lehrer01` |

## Pitfalls

- On Windows, the **stricter** of share and NTFS permission always applies.
- **Inheritance:** new subfolders inherit the permissions. Whoever disables inheritance has to set everything themselves.
- Samba: Linux file permissions **and** Samba settings (`valid users`, `read only`) both apply.
- SMB1 is insecure and switched off on both sides. Do not switch it back on, even if an old device asks for it.

## Entry points

- Microsoft Learn: [SMB file sharing (overview)](https://learn.microsoft.com/en-us/windows-server/storage/file-server/file-server-smb-overview)
- Microsoft Learn: [New-SmbShare](https://learn.microsoft.com/en-us/powershell/module/smbshare/new-smbshare), [icacls](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/icacls)
- Samba Wiki: [Setting up Samba as a Standalone Server](https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Standalone_Server), [Setting up Samba as a Domain Member](https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Domain_Member)
- Samba: `man smb.conf`

## Comparison questions

- Where is the permission matrix easier to implement, where easier to **verify**?
- Limiting storage per person (quotas): how does that work in each world?
- A Windows client does not notice that Linux runs behind the share. What does that mean for choosing the server at a school?
- Which alternative would cloud storage be (OneDrive, Nextcloud from [chapter 1]({{% relref "/01-virtualization-containerization" %}}))? What becomes of the permission matrix and of data protection?
