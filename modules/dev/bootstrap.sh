# shellcheck shell=bash
# Body of the `bootstrap` package. See bootstrap.nix.

readonly FACTER_REMOTE_TMP=/tmp/zix-facter.json

HOST=""
MODE=""
TARGET=""
SSH_PORT=22
HOST_KEY=""
SAVE_HOST_KEY=""
DO_FACTER=true
REFRESH_FACTER=false
DO_SECRETS=true
DRY_RUN=false
ASSUME_YES=false

KEY_DIR=""
EXTRA_FILES=""

info() { printf '\033[1;34m•\033[0m %s\n' "$*" >&2; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die() {
  printf '\033[1;31merror:\033[0m %s\n' "$*" >&2
  exit 1
}
step() { printf '\n\033[1;32m==>\033[0m \033[1m%s\033[0m\n' "$*" >&2; }

run() {
  printf '  \033[2m$ %s\033[0m\n' "$*" >&2
  if [[ $DRY_RUN == false ]]; then
    "$@"
  fi
}

cleanup() {
  if [[ -n $KEY_DIR && -d $KEY_DIR ]]; then
    rm -rf "$KEY_DIR"
  fi
  if [[ -n $EXTRA_FILES && -d $EXTRA_FILES ]]; then
    rm -rf "$EXTRA_FILES"
  fi
}
trap cleanup EXIT

usage() {
  cat <<'EOF'
zix-bootstrap — provision a NixOS host declared in this flake

Usage:
  zix-bootstrap <host> --target [user@]<address> [options]
  zix-bootstrap <host> --local [options]

Modes:
  --target <[user@]addr>  install onto a machine already running a NixOS
                          installer, over ssh, with nixos-anywhere. Without a
                          user, root@ is assumed.
  --local                 install onto the machine running this script, which
                          must be a NixOS installer with the target disks
                          attached.

Options:
  --ssh-port <port>       port of the installer's sshd (default 22). This is the
                          installer's port, not the port the host ends up on.
  --host-key <file>       reuse this ed25519 private key as the host key instead
                          of generating one. Use it to keep a rebuilt machine's
                          existing sops identity.
  --save-host-key <dir>   also write the generated host key to <dir>.
  --refresh-facter        regenerate the hardware report even if one exists.
  --no-facter             do not generate a hardware report.
  --no-secrets            do not provision a host key and do not touch
                          .sops.yaml. The host will boot with no key that sops
                          can use, so no secret will decrypt.
  --dry-run               print every command that would run, change nothing.
  -y, --yes               do not prompt before destroying disks.
  -h, --help              this message.

What it does, in order:
  1. preflight   the host directory exists and the flake evaluates
  2. hardware    nixos-facter report -> modules/hosts/<host>/facter.json
  3. secrets     generate the host's ed25519 key, derive its age recipient, add
                 it to .sops.yaml, rekey every secret with `sops updatekeys`
  4. install     disko destroys, formats and mounts the disks the host declares,
                 then the system is installed with the host key already at
                 /etc/ssh/ssh_host_ed25519_key so secrets decrypt on first boot

Steps are idempotent: an existing report is reused, and an existing .sops.yaml
entry for the host is updated in place rather than duplicated.
EOF
}

sops_upsert_recipient() {
  local anchor=$1 key=$2
  local existing groups aliased

  existing=$(ANCHOR=$anchor yq '[.keys[] | select(anchor == strenv(ANCHOR))] | length' .sops.yaml)
  if [[ $existing == 0 ]]; then
    info "adding &$anchor to .sops.yaml"
    run env ANCHOR="$anchor" KEY="$key" yq -i \
      '.keys += [strenv(KEY)] | .keys[-1] anchor = strenv(ANCHOR)' .sops.yaml
  else
    info "updating &$anchor in .sops.yaml"
    run env ANCHOR="$anchor" KEY="$key" yq -i \
      '(.keys[] | select(anchor == strenv(ANCHOR))) = strenv(KEY) | .keys[] |= (select(. == strenv(KEY)) | . anchor = strenv(ANCHOR))' .sops.yaml
  fi

  groups=$(yq '[.creation_rules[].key_groups[]] | length' .sops.yaml)
  aliased=$(ANCHOR=$anchor yq '[.creation_rules[].key_groups[].age[] | select(alias == strenv(ANCHOR))] | length' .sops.yaml)
  if [[ $aliased == 0 ]]; then
    info "granting *$anchor every creation rule"
    run env ANCHOR="$anchor" yq -i \
      '(.creation_rules[].key_groups[].age) += [""] | .creation_rules[].key_groups[].age[-1] alias = strenv(ANCHOR)' .sops.yaml
  elif [[ $aliased != "$groups" ]]; then
    warn "*$anchor is in $aliased of $groups key groups in .sops.yaml; reconcile it by hand"
  else
    info "*$anchor already covers every creation rule"
  fi
}

rekey_secrets() {
  local files=() f
  while IFS= read -r f; do
    case $f in
    *.yaml | *.json | *.env | *.ini) files+=("$f") ;;
    esac
  done < <(git ls-files -- secrets)

  if [[ ${#files[@]} -eq 0 ]]; then
    info "no secret files to rekey"
    return 0
  fi

  info "rekeying ${#files[@]} secret file(s); this needs a key that can already decrypt them"
  for f in "${files[@]}"; do
    run sops updatekeys --yes "$f" || die "sops updatekeys failed for $f"
  done
}

generate_report_remote() {
  local out=$1
  ssh -p "$SSH_PORT" "$TARGET" \
    "nix --extra-experimental-features 'nix-command flakes' run nixpkgs#nixos-facter -- -o $FACTER_REMOTE_TMP >&2 && cat $FACTER_REMOTE_TMP" \
    >"$out"
}

while [[ $# -gt 0 ]]; do
  case $1 in
  -h | --help)
    usage
    exit 0
    ;;
  --target)
    TARGET=${2:?--target needs an address}
    MODE=remote
    shift 2
    ;;
  --local)
    MODE=local
    shift
    ;;
  --ssh-port)
    SSH_PORT=${2:?--ssh-port needs a port}
    shift 2
    ;;
  --host-key)
    HOST_KEY=${2:?--host-key needs a file}
    shift 2
    ;;
  --save-host-key)
    SAVE_HOST_KEY=${2:?--save-host-key needs a directory}
    shift 2
    ;;
  --refresh-facter)
    REFRESH_FACTER=true
    shift
    ;;
  --no-facter)
    DO_FACTER=false
    shift
    ;;
  --no-secrets)
    DO_SECRETS=false
    shift
    ;;
  --dry-run)
    DRY_RUN=true
    shift
    ;;
  -y | --yes)
    ASSUME_YES=true
    shift
    ;;
  -*)
    die "unknown option: $1 (--help for usage)"
    ;;
  *)
    if [[ -n $HOST ]]; then
      die "unexpected argument: $1"
    fi
    HOST=$1
    shift
    ;;
  esac
done

if [[ -z $HOST ]]; then
  usage
  die "no host given"
fi
if [[ -z $MODE ]]; then
  die "choose an install mode: --target <address> or --local"
fi
if [[ $MODE == remote && $TARGET != *@* ]]; then
  TARGET="root@$TARGET"
fi

step "Preflight"

command -v nix >/dev/null || die "nix is not on PATH"
REPO=$(git rev-parse --show-toplevel 2>/dev/null) || die "not inside a git work tree"
cd "$REPO" || die "cannot enter repo root: $REPO"

HOST_DIR="modules/hosts/$HOST"
REPORT="$HOST_DIR/facter.json"
[[ -d $HOST_DIR ]] || die "no such host: $HOST_DIR does not exist; declare the host first"

info "repo:   $REPO"
info "host:   $HOST"
if [[ $MODE == remote ]]; then
  info "target: $TARGET, installer sshd on port $SSH_PORT"
else
  info "target: this machine"
fi
if [[ $DRY_RUN == true ]]; then
  warn "dry run: nothing will be changed"
fi

step "Hardware report"

if [[ $DO_FACTER == false ]]; then
  info "skipped (--no-facter)"
elif [[ -s $REPORT && $REFRESH_FACTER == false ]]; then
  info "reusing $REPORT; pass --refresh-facter to regenerate it"
elif [[ $DRY_RUN == true ]]; then
  info "would run nixos-facter and write $REPORT"
else
  tmp=$(mktemp)
  if [[ $MODE == remote ]]; then
    info "running nixos-facter on $TARGET"
    generate_report_remote "$tmp" || die "could not generate a hardware report on $TARGET"
  else
    info "running nixos-facter here, as root"
    sudo nixos-facter -o "$tmp" || die "nixos-facter failed"
  fi
  jq -e . "$tmp" >/dev/null 2>&1 || die "the generated report is not valid JSON"
  mv "$tmp" "$REPORT"
  info "wrote $REPORT"
fi

if [[ -e $REPORT ]]; then
  # A file git does not know about is invisible to the flake.
  run git add --intent-to-add "$REPORT"
  if ! grep -rqF facter.json --include='*.nix' "$HOST_DIR"; then
    warn "nothing in $HOST_DIR references the report; add { hardware.facter.reportPath = ./facter.json; }"
  fi
fi

step "Flake checks"

nix eval --raw ".#nixosConfigurations.$HOST.config.system.build.toplevel.drvPath" >/dev/null ||
  die "the flake does not evaluate for host '$HOST'"
info "the host evaluates"

# Only the device strings: disko's option type holds functors, so the whole
# devices tree cannot be converted to JSON.
if ! DISKS_JSON=$(nix eval --json ".#nixosConfigurations.$HOST.config.disko.devices.disk" \
  --apply 'builtins.mapAttrs (_: disk: disk.device)' 2>&1); then
  printf '%s\n' "$DISKS_JSON" >&2
  die "cannot read disko.devices.disk for '$HOST'; declare its disks in $HOST_DIR/disko.nix"
fi

DISKS=$(jq -r 'to_entries[]? | "\(.key) -> \(.value)"' <<<"$DISKS_JSON")
if [[ -z $DISKS ]]; then
  die "host '$HOST' declares no disko.devices.disk; add $HOST_DIR/disko.nix"
fi
info "disko will destroy and format:"
while IFS= read -r line; do
  info "    $line"
done <<<"$DISKS"

step "Secrets"

if [[ $DO_SECRETS == false ]]; then
  warn "skipped (--no-secrets): the host gets no key sops can use, so no secret will decrypt"
else
  KEY_DIR=$(mktemp -d)
  chmod 700 "$KEY_DIR"
  KEY="$KEY_DIR/ssh_host_ed25519_key"

  if [[ -n $HOST_KEY ]]; then
    [[ -r $HOST_KEY ]] || die "cannot read --host-key $HOST_KEY"
    install -m600 "$HOST_KEY" "$KEY"
    ssh-keygen -y -f "$KEY" >"$KEY.pub" || die "$HOST_KEY is not a usable private key"
    info "reusing the host key from $HOST_KEY"
  else
    ssh-keygen -q -t ed25519 -N "" -C "root@$HOST" -f "$KEY" || die "could not generate a host key"
    info "generated an ed25519 host key for $HOST"
  fi

  AGE_KEY=$(ssh-to-age -i "$KEY.pub") || die "ssh-to-age could not convert the host key"
  info "age recipient: $AGE_KEY"

  sops_upsert_recipient "$HOST" "$AGE_KEY"
  rekey_secrets

  EXTRA_FILES=$(mktemp -d)
  install -Dm600 "$KEY" "$EXTRA_FILES/etc/ssh/ssh_host_ed25519_key"
  install -Dm644 "$KEY.pub" "$EXTRA_FILES/etc/ssh/ssh_host_ed25519_key.pub"

  if [[ -n $SAVE_HOST_KEY ]]; then
    install -Dm600 "$KEY" "$SAVE_HOST_KEY/ssh_host_ed25519_key"
    install -Dm644 "$KEY.pub" "$SAVE_HOST_KEY/ssh_host_ed25519_key.pub"
    warn "the private host key is now at $SAVE_HOST_KEY; it decrypts every secret this host can read"
  fi
fi

step "Install"

if [[ $ASSUME_YES == false && $DRY_RUN == false ]]; then
  warn "this destroys all data on the disks listed above"
  read -r -p "type the hostname '$HOST' to continue: " answer
  [[ $answer == "$HOST" ]] || die "aborted"
fi

if [[ $MODE == remote ]]; then
  args=(
    --flake ".#$HOST"
    --target-host "$TARGET"
    --ssh-port "$SSH_PORT"
    --phases "kexec,disko,install,reboot"
  )
  if [[ -n $EXTRA_FILES ]]; then
    args+=(--extra-files "$EXTRA_FILES")
  fi
  run nixos-anywhere "${args[@]}"
else
  run sudo "$(command -v disko)" --mode destroy,format,mount --flake ".#$HOST"
  if [[ -n $EXTRA_FILES ]]; then
    run sudo install -Dm600 "$EXTRA_FILES/etc/ssh/ssh_host_ed25519_key" /mnt/etc/ssh/ssh_host_ed25519_key
    run sudo install -Dm644 "$EXTRA_FILES/etc/ssh/ssh_host_ed25519_key.pub" /mnt/etc/ssh/ssh_host_ed25519_key.pub
  fi
  run sudo "$(command -v nixos-install)" --flake ".#$HOST" --no-root-passwd
fi

step "Next steps"

cat >&2 <<EOF
  1. Commit what this wrote, or the next rebuild loses it:
       git add $REPORT .sops.yaml secrets
       git commit -m "hosts: bootstrap $HOST"

  2. The ssh concern puts sshd on port 30 and disables root and password login,
     so the installer's root access is gone once the host reboots. Reach it as
     your own user: ssh -p 30 <user>@<address>

  3. Confirm the secrets decrypted: ssh -p 30 <user>@<address> ls /run/secrets
EOF
