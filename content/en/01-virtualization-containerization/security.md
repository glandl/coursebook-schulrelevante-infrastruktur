+++
title = "Security and data protection"
weight = 80
+++

{{% callout style="warning" title="No legal advice" %}}
This section gives technical orientation. Legal questions (e.g. legal basis, data processing agreements) are clarified by the school with the data protection officer and the school maintainer.
{{% /callout %}}

## The essentials in brief

| Topic | Measure |
|---|---|
| **Updates** | Keep host, VM operating system **and** container images up to date. A container image is not updated by `apt upgrade` in the VM. |
| **Pin versions** | Fixed image versions in Compose files, controlled updates (first backup or snapshot, then `pull` and `up -d`). |
| **Isolation** | A VM isolates more strongly than a container. Sensitive systems (e.g. grade management) in their own VM, ideally in their own network/VLAN (session 3). |
| **Docker rights** | Anyone in the `docker` group effectively has root rights on the host. Administrators only, never student accounts. Do not mount the Docker socket into containers. |
| **Container rights** | No `--privileged` containers, no unnecessary capabilities, services preferably not as `root` in the container. |
| **Ports** | Publish only necessary ports. Note: Docker sets its own firewall rules. Published ports are often reachable even if e.g. `ufw` is supposed to block them. Bind to `127.0.0.1:8080:80` if the service should only be reachable locally. |
| **Secrets** | Passwords, tokens and keys in `.env` or a secret store, never in the repository, never in the image, not in screenshots. |
| **Backups** | Back up data (volumes, database), keep it in a different location, **test the restore regularly**, protect backups as well (access, encryption). |
| **Snapshots** | Fallback, not a backup. Older snapshots contain old, unpatched states and data that may have to be deleted. |
| **Images** | Only official or trustworthy sources. For unknown images, check who maintains them and how current they are. |
| **Access** | Strong passwords, preferably **SSH keys** instead of passwords, do not mix administrator accounts with everyday accounts. |
| **Logs** | Logs (`docker logs`, system logs) may contain personal data (user names, IP addresses). Limit retention. |

## Data protection in the school context

- **Personal data in VMs and containers:** Disk images, snapshots, volumes and backups also contain personal data and are subject to the same protection. A VM image that is passed on may contain student data.
- **Deleting:** Anyone who deletes data must also consider snapshots, backups and copies. Deletion and retention periods apply to all copies.
- **Location of the data:** For cloud services, check where the data is stored and whether a data processing agreement (DPA) exists. With self-hosting, the school is responsible for the technical measures (TOM).
- **Separation:** Do not mix school and test environments. **No real student data in practice environments**, use test data in class.
- **Processing register:** New services (wiki, learning platform, tickets) are new processing activities and belong in the register (see [Processing register and ADRs]({{% relref "/00-documentation/processing-register-adr" %}})).
- **Responsibility:** The school remains responsible even when operation is by third parties or several teachers. Define clear responsibilities and cover.

## Checklist for a new service

- [ ] Who is responsible, who is the substitute?
- [ ] Which personal data is generated (categories, data subjects)?
- [ ] Image/software version known and pinned, update plan in place?
- [ ] Backup set up **and restore tested**?
- [ ] Access restricted (accounts, network, ports)?
- [ ] Encryption of transmission (HTTPS) planned?
- [ ] Entry in the processing register, ADR for the decision?
- [ ] Deletion concept (including backups and snapshots)?

The topics **network separation** (sessions 2 and 3), **server hardening and backups** (session 4) and **data protection law** (session 6) are deepened in the following sessions.
