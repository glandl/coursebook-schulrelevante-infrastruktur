#!/usr/bin/env bash
# Proxmox permissions for the server-roles block (chapter 4, 16.11. + 23.11.).
# Run on the Proxmox host as root. Default is a dry run that only prints the commands;
# pass --apply to execute them.
#
#   ./setup-permissions.sh [--apply] [--snapshot] [teams.conf]
#
#   --apply     execute instead of printing
#   --snapshot  also create the snapshot "clean-start" on every team VM/CT and test client
#
# What it does:
#   - role  TeamVM          : console, power, snapshot + rollback, CD-ROM, view pool
#   - role  TestClientUser  : console + power only
#   - group team<N> per role team, group "students" for everybody
#   - pool  pool-team<N> (Windows VM + Debian CT), ACL TeamVM for group team<N>
#   - pool  pool-testclients, ACL TestClientUser for group students
# It does NOT remove the existing broad access - it lists it at the end so you can
# remove it by hand after checking (removing the wrong ACL locks you or students out).
set -euo pipefail

APPLY=0; SNAP=0; CONF=""
for a in "$@"; do
  case "$a" in
    --apply) APPLY=1 ;;
    --snapshot) SNAP=1 ;;
    *) CONF="$a" ;;
  esac
done
CONF="${CONF:-$(dirname "$0")/teams.conf}"
[[ -r "$CONF" ]] || { echo "config not found: $CONF (copy teams.conf.example)" >&2; exit 1; }

show() { printf '%q ' "$@"; echo; }
run() {
  if (( APPLY )); then echo -n "+ "; show "$@"; "$@"; else show "$@"; fi
}
# like run, but tolerate "already exists" so the script can be re-run
run_ok() {
  if (( APPLY )); then echo -n "+ "; show "$@"; "$@" 2>/dev/null || echo "  (exists / skipped)"; else show "$@"; fi
}

TESTCLIENTS="$(sed -n 's/^TESTCLIENTS=//p' "$CONF")"

echo "### roles"
TEAM_PRIVS="VM.Audit VM.Console VM.PowerMgmt VM.Snapshot VM.Snapshot.Rollback VM.Config.CDROM Pool.Audit"
TC_PRIVS="VM.Audit VM.Console VM.PowerMgmt Pool.Audit"
run_ok pveum role add TeamVM --privs "$TEAM_PRIVS"
run     pveum role modify TeamVM --privs "$TEAM_PRIVS"
run_ok pveum role add TestClientUser --privs "$TC_PRIVS"
run     pveum role modify TestClientUser --privs "$TC_PRIVS"

echo "### group students"
run_ok pveum group add students --comment "all students, server-roles block"

ALL_IDS=()
while read -r team vmid ctid users; do
  [[ -z "${team:-}" || "$team" == \#* || "$team" == TESTCLIENTS=* ]] && continue
  echo "### $team (VM $vmid, CT $ctid): $users"
  run_ok pveum group add "$team" --comment "role team $team"
  run_ok pveum pool add "pool-$team" --comment "role team $team"
  run     pveum pool modify "pool-$team" --vms "$vmid,$ctid"
  run     pveum acl modify "/pool/pool-$team" --groups "$team" --roles TeamVM
  IFS=',' read -ra U <<< "$users"
  for u in "${U[@]}"; do
    run pveum user modify "$u" --groups "$team,students" --append 1
  done
  IFS=',' read -ra IDS <<< "$vmid,$ctid"
  ALL_IDS+=("${IDS[@]}")
done < "$CONF"

echo "### test clients ($TESTCLIENTS)"
run_ok pveum pool add pool-testclients --comment "shared test clients"
run     pveum pool modify pool-testclients --vms "$TESTCLIENTS"
run     pveum acl modify /pool/pool-testclients --groups students --roles TestClientUser

if (( SNAP )); then
  echo "### snapshot clean-start"
  IFS=',' read -ra TC <<< "$TESTCLIENTS"
  for id in "${ALL_IDS[@]}" "${TC[@]}"; do
    if [[ -e "/etc/pve/lxc/$id.conf" ]]; then
      # LXC snapshots need snapshot-capable storage (ZFS, LVM-thin, Ceph)
      run_ok pct snapshot "$id" clean-start --description "before server-roles block"
    elif [[ -e "/etc/pve/qemu-server/$id.conf" ]]; then
      run_ok qm snapshot "$id" clean-start --description "before server-roles block"
    else
      echo "  $id: no VM/CT with this ID on this node - skipped"
    fi
  done
fi

echo
echo "### existing ACLs - remove the broad ones by hand, e.g. a student or group ACL on / or /vms:"
echo "###   pveum acl delete / --users student01@pve --roles <role>"
pveum acl list 2>/dev/null || echo "(pveum not available here - run on the Proxmox host)"
(( APPLY )) || echo -e "\nDry run only. Re-run with --apply to execute."
