# NOTE: https://just.systems

# just global settings
set quiet

# Systems information
FLAKE_HOST := "desktop"

# Commands macro
NOTIFY := "&& just notify 0 || just notify $?"

default:
    just --list

pkill app_name="zen-beta":
    #!/usr/bin/env bash
    set -euo pipefail
    if pgrep "{{ app_name }}" >/dev/null 2>&1; then
      printf "{{ RED }}   PKILL?  {{ NORMAL }} {{ app_name }} [y/N]: "
      read -r answer

      if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        pkill {{ app_name }}
        printf "{{ RED }}  󱒼 KILLED  {{ NORMAL }} {{ app_name }}\n"
      else
        printf "{{ BLUE }}  󰜺 SKIPPED {{ NORMAL }} {{ app_name }}\n"
      fi
    fi

restart app_name="noctalia":
    #!/usr/bin/env bash
    set -euo pipefail
    if pgrep "{{ app_name }}" >/dev/null 2>&1; then
      printf "{{ RED }}   RESTART?{{ NORMAL }} {{ app_name }} [Y/n]: "
      read -r answer

      if [[ "$answer" == "n" || "$answer" == "N" ]]; then
        printf "{{ BLUE }}  󰜺 SKIPPED {{ NORMAL }} {{ app_name }}\n"
      else
        printf "{{ RED }}  󱒼 KILLED  {{ NORMAL }} {{ app_name }}\n";
        pkill "{{ app_name }}"

        printf "{{ BLUE }}   RESTART {{ NORMAL }} {{ app_name }}\n"
        {{ app_name }} >/dev/null 2>&1 & disown

        sleep 3
      fi
    fi

git:
    printf "{{ GREEN }}   GIT     {{ NORMAL }} *\n"
    git add -A

notify exit_code="0" context="system":
    #!/usr/bin/env bash
    set -euo pipefail

    # Context path
    if [[ "{{ context }}" == "system" ]]; then
      APP_NAME="System Task"
      ICON="{{ justfile_directory() }}/public/images/logos/nixos-colorful.png"
      SUCC_TITLE="Task Completed"
      SUCC_BODY="The operation completed without error."
      FAIL_TITLE="Task Failed (Code: {{ exit_code }})"
      FAIL_BODY="The operation was aborted. Check terminal for the error."
    else
      RAW_CONTEXT="{{ context }}"
      ACTION="${RAW_CONTEXT^}"
      APP_NAME="Git"
      ICON="{{ justfile_directory() }}/public/images/icons/git.png"
      SUCC_TITLE="${ACTION} Successful"
      SUCC_BODY="All commits have been safely ${RAW_CONTEXT} from/to the remote repository."
      FAIL_TITLE="${ACTION} Rejected (Code: {{ exit_code }})"
      FAIL_BODY="Check the terminal for upstream conflicts or network issues."
    fi

    IS_GUI_RUNNING() {
      pgrep "noctalia" &>/dev/null
    }

    # Warning notification
    if [[ "{{ exit_code }}" -ne 0 ]]; then
      printf "{{ RED }}   FAILED  {{ NORMAL }} Task\n" 
      if IS_GUI_RUNNING; then
        nix run nixpkgs#libnotify -- \
          --transient \
          -u critical \
          -a "$APP_NAME" \
          -i "$ICON" \
          "$FAIL_TITLE" \
          "$FAIL_BODY"
      fi
      exit {{ exit_code }}
    fi

    # Success notification
    printf "{{ GREEN }}   SUCCESS {{ NORMAL }} Task\n"
    if IS_GUI_RUNNING; then
      nix run nixpkgs#libnotify -- \
        --transient \
          -a "$APP_NAME" \
          -i "$ICON" \
          "$SUCC_TITLE" \
          "$SUCC_BODY"
    fi
    exit 0

commit host=FLAKE_HOST:
    #!/usr/bin/env bash
    set -euo pipefail
    GEN=$(readlink /nix/var/nix/profiles/system | cut -d "-" -f 2)
    MESS="[ {{ host }} ] NixOS Generation $GEN"
    DESC="Saved latest generation $GEN at $(date -u +%Y-%m-%d\ %H:%M:%S)."

    if git diff --quiet --cached; then
      printf "{{ BLUE }}   SKIPPED  {{ NORMAL }} Auto-commit\n"
      exit 0
    fi

    git commit -m "$MESS" -m "$DESC" &>/dev/null
    printf "{{ GREEN }}   COMMIT  {{ NORMAL }} Latest Generation\n"

push:
    printf "{{ BLUE }}   PUSH    {{ NORMAL }} Github\n"
    git push -v && just notify 0 push || just notify $? push

pull:
    printf "{{ BLUE }}   PULL    {{ NORMAL }} Github\n"
    git pull -v && just notify 0 pull || just notify $? pull

repl:
    printf "{{ BLUE }}   REPL    {{ NORMAL }} Unstable channel\n"
    nix repl -f channel:nixos-unstable

doc:
    printf "{{ BLUE }}  󰈙 REPL    {{ NORMAL }} :doc\n"
    nh os repl {{ justfile_directory() }} -H {{ FLAKE_HOST }}

inspect:
    printf "{{ BLUE }}   INSPECT {{ NORMAL }} NixOS Flake\n"
    nix run nixpkgs#nix-inspect -- -p {{ justfile_directory() }}

# Virtualisation/Gaming
specialisation spec_name="Virtualisation" host=FLAKE_HOST: pkill git
    printf "{{ BLUE }}   SPECIAL {{ NORMAL }} NixOS#{{ host }}\n"
    nh os test {{ justfile_directory() }} --specialisation {{ spec_name }} -H {{ host }} {{ NOTIFY }}

switch host=FLAKE_HOST: pkill git
    printf "{{ BLUE }}  󰟁 SWITCH  {{ NORMAL }} NixOS#{{ host }}\n"
    nh os switch {{ justfile_directory() }} -H {{ host }} \
      && just notify 0 && just commit {{ host }} || just notify $?

boot host=FLAKE_HOST: git
    printf "{{ BLUE }}  󰜉 BOOT    {{ NORMAL }} NixOS#{{ host }}\n"
    nh os boot {{ justfile_directory() }} -H {{ host }} \
      && just notify 0 && just commit {{ host }} || just notify $?

test host=FLAKE_HOST: pkill git
    printf "{{ BLUE }}  󰙨 TEST    {{ NORMAL }} NixOS#{{ host }}\n"
    nh os test {{ justfile_directory() }} -H {{ host }} {{ NOTIFY }}

build host=FLAKE_HOST: git
    printf "{{ BLUE }}  󰲽 BUILD   {{ NORMAL }} NixOS#{{ host }}\n"
    nh os build {{ justfile_directory() }} -H {{ host }} {{ NOTIFY }}

remote action="switch" host="laptop": pkill git
    printf "{{ BLUE }}  󰢹 REMOTE  {{ NORMAL }} NixOS#{{ host }} (Forced offload)\n"
    nh os build {{ justfile_directory() }} -H {{ host }} -- --max-jobs 0
    just {{ action }} {{ host }}

dry host=FLAKE_HOST: git
    printf "{{ BLUE }}   DRY     {{ NORMAL }} NixOS#{{ host }}\n"
    nh os switch {{ justfile_directory() }} -H {{ host }} --dry {{ NOTIFY }}

legacy host=FLAKE_HOST: pkill git
    printf "{{ BLUE }}  󰟁 SWITCH  {{ NORMAL }} (L) NixOS#{{ host }}\n"
    sudo nixos-rebuild switch --flake {{ justfile_directory() }} \
      && just notify 0 && just commit {{ host }} || just notify $?

update host=FLAKE_HOST: pkill git
    #!/usr/bin/env bash
    set -euo pipefail
    printf "{{ BLUE }}   UPDATE  {{ NORMAL }} lazy.nvim\n"
    NVIM_APPNAME=lvim nvim --headless "+Lazy! sync" +qa &>/dev/null

    printf "{{ BLUE }}   UPDATE  {{ NORMAL }} vim.pack\n"
    nvim --headless +"lua vim.pack.update()" +w +qa &>/dev/null

    printf "{{ BLUE }}  󰟁 UPDATE  {{ NORMAL }} NixOS#{{ host }}\n"
    if nh os switch {{ justfile_directory() }} -H {{ host }} --update; then
      just notify 0
    else
      just notify $?
      exit 1
    fi

    just restart noctalia
    just commit {{ host }}

rollback gen="":
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ -z "{{ gen }}" ]]; then
      CURRENT_GEN=$(readlink /nix/var/nix/profiles/system | cut -d "-" -f 2)
      printf "{{ BLUE }}   ROLLBACK{{ NORMAL }} Generation $((CURRENT_GEN - 1))\n"
      nh os rollback {{ NOTIFY }}
    else
      printf "{{ BLUE }}   ROLLBACK{{ NORMAL }} Generation {{ gen }}\n"
      nh os rollback -t {{ gen }} {{ NOTIFY }}
    fi

clean keep_num="3":
    printf "{{ RED }}   CLEAN   {{ NORMAL }} Partial (Keeping: {{ keep_num }})\n"
    nh clean all --keep {{ keep_num }} {{ NOTIFY }}

nuke:
    printf "{{ RED }}   CLEAN   {{ NORMAL }} All\n"
    nh clean all --ask {{ NOTIFY }}

# WARN: Recipes for installing NixOS on a new machine
__disko host:
    echo "  DISKO   ."
    nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- \
      --mode destroy,format,mount ./hosts/{{ host }}/disk-config.nix

__nixos-anywhere host ip_addr:
    # Assume sops-keys is already in /tmp/sops-keys/root/.config/sops/age/keys.txt
    echo "  NIX-ANY {{ host }}"
    nix run github:nix-community/nixos-anywhere -- \
      --generate-hardware-config nixos-generate-config ./hosts/{{ host }}/hardware-configuration.nix \
      --flake .#{{ host }} \
      --extra-files /tmp/sops-keys \
      --target-host root@{{ ip_addr }}

__update-sops-keys:
    #!/usr/bin/env bash
    set -euo pipefail
    # First update new sops public key of current host in ./.sops.yaml 
    echo "  SOPS    Add Trusted host"
    for secret in ./secrets/*.yaml; do
      nix run nixpkgs#sops -- \
        --run "sops updatekeys --yes ${secret}"
    done
