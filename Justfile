# NOTE: https://just.systems

# just global settings
set quiet

# Systems information
FLAKE_HOST := "desktop"

# ANSI color codes
C_RED := "\\033[1;31m"
C_GREEN := "\\033[1;32m"
C_BLUE := "\\033[1;34m"
C_NONE := "\\033[0m"

# Commands macro
NOTIFY := "&& just notify 0 || just notify $?"
COMMIT := "&& just notify 0 && just commit || just notify $?"

default:
    just --list

pkill app_name="zen-beta":
    #!/usr/bin/env bash
    set -euo pipefail
    if pgrep "{{ app_name }}" >/dev/null 2>&1; then
      printf "{{ C_RED }}   PKILL?  {{ C_NONE }} {{ app_name }} [y/N]: "
      read -r answer

      if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        pkill {{ app_name }}
        printf "{{ C_RED }}  󱒼 KILLED  {{ C_NONE }} {{ app_name }}\n"
      else
        printf "{{ C_BLUE }}  󰜺 SKIPPED {{ C_NONE }} {{ app_name }}\n"
      fi
    fi

restart app_name="noctalia":
    #!/usr/bin/env bash
    set -euo pipefail
    if pgrep "{{ app_name }}" >/dev/null 2>&1; then
      printf "{{ C_RED }}   RESTART?{{ C_NONE }} {{ app_name }} [Y/n]: "
      read -r answer

      if [[ "$answer" == "n" || "$answer" == "N" ]]; then
        printf "{{ C_BLUE }}  󰜺 SKIPPED {{ C_NONE }} {{ app_name }}\n"
      else
        printf "{{ C_RED }}  󱒼 KILLED  {{ C_NONE }} {{ app_name }}\n";
        pkill "{{ app_name }}"

        printf "{{ C_BLUE }}   RESTART {{ C_NONE }} {{ app_name }}\n"
        {{ app_name }} >/dev/null 2>&1 & disown

        sleep 3
      fi
    fi

git:
    printf "{{ C_GREEN }}   GIT     {{ C_NONE }} *\n"
    git add -A

notify exit_code="0" context="system":
    #!/usr/bin/env bash
    set -euo pipefail

    # Context path
    if [[ "{{ context }}" == "system" ]]; then
      APP_NAME="System Task"
      ICON="{{ justfile_directory() }}/images/logos/nixos-colorful.png"
      SUCC_TITLE="Task Completed"
      SUCC_BODY="The operation finished successfully without errors."
      FAIL_TITLE="Task Failed (Code: {{ exit_code }})"
      FAIL_BODY="The operation was aborted. Check your terminal for the error."
    else
      APP_NAME="Git"
      ICON="{{ justfile_directory() }}/images/icons/git.png"
      SUCC_TITLE="Push Successful"
      SUCC_BODY="All commits have been safely pushed to the remote repository."
      FAIL_TITLE="Push Rejected (Code: {{ exit_code }})"
      FAIL_BODY="Check the terminal for upstream conflicts or network issues."
    fi

    IS_GUI_RUNNING() {
      pgrep "noctalia" &>/dev/null
    }

    # Warning notification
    if [[ "{{ exit_code }}" -ne 0 ]]; then
      printf "{{ C_RED }}   FAILED  {{ C_NONE }} Task\n" 
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
    printf "{{ C_GREEN }}   SUCCESS {{ C_NONE }} Task\n"
    if IS_GUI_RUNNING; then
      nix run nixpkgs#libnotify -- \
        --transient \
          -a "$APP_NAME" \
          -i "$ICON" \
          "$SUCC_TITLE" \
          "$SUCC_BODY"
    fi
    exit 0

commit: git
    #!/usr/bin/env bash
    set -euo pipefail
    GEN=$(readlink /nix/var/nix/profiles/system | cut -d "-" -f 2)
    MESS="[ {{ FLAKE_HOST }} ] NixOS Generation $GEN"
    DESC="Saved latest generation $GEN at $(date -u +%Y-%m-%d\ %H:%M:%S)."

    if git diff --quiet --cached; then
      printf "{{ C_BLUE }}   SKIPPED  {{ C_NONE }} Auto-commit\n"
      exit 0
    fi

    git commit -m "$MESS" -m "$DESC" &>/dev/null
    printf "{{ C_GREEN }}   COMMIT  {{ C_NONE }} Latest Generation\n"

push:
    printf "{{ C_BLUE }}   PUSH    {{ C_NONE }} Github\n"
    git push -v && just notify 0 push || just notify $? push

# Virtualisation/Gaming
specialisation spec_name="Virtualisation" host=FLAKE_HOST: pkill git
    printf "{{ C_BLUE }}   SPECIAL {{ C_NONE }} NixOS#{{ host }}\n"
    nh os test {{ justfile_directory() }} --specialisation {{ spec_name }} -H {{ host }} {{ NOTIFY }}

switch host=FLAKE_HOST: pkill git
    printf "{{ C_BLUE }}  󰟁 SWITCH  {{ C_NONE }} NixOS#{{ host }}\n"
    nh os switch {{ justfile_directory() }} -H {{ host }} {{ COMMIT }}

boot host=FLAKE_HOST: pkill git
    printf "{{ C_BLUE }}  󰜉 BOOT    {{ C_NONE }} NixOS#{{ host }}\n"
    nh os boot {{ justfile_directory() }} -H {{ host }} {{ COMMIT }}

test host=FLAKE_HOST: pkill git
    printf "{{ C_BLUE }}  󰙨 TEST    {{ C_NONE }} NixOS#{{ host }}\n"
    nh os test {{ justfile_directory() }} -H {{ host }} {{ NOTIFY }}

dry host=FLAKE_HOST: pkill git
    printf "{{ C_BLUE }}   DRY     {{ C_NONE }} NixOS#{{ host }}\n"
    nh os switch {{ justfile_directory() }} -H {{ host }} --dry {{ NOTIFY }}

legacy host=FLAKE_HOST: pkill git
    printf "{{ C_BLUE }}  󰟁 SWITCH  {{ C_NONE }} (L) NixOS#{{ host }}\n"
    sudo nixos-rebuild switch --flake {{ justfile_directory() }} {{ COMMIT }}

update host=FLAKE_HOST: pkill git
    #!/usr/bin/env bash
    set -euo pipefail
    printf "{{ C_BLUE }}   UPDATE  {{ C_NONE }} lazy.nvim\n"
    NVIM_APPNAME=lvim nvim --headless "+Lazy! sync" +qa &>/dev/null

    printf "{{ C_BLUE }}   UPDATE  {{ C_NONE }} vim.pack\n"
    nvim --headless +"lua vim.pack.update()" +w +qa &>/dev/null

    printf "{{ C_BLUE }}  󰟁 UPDATE  {{ C_NONE }} NixOS#{{ host }}\n"
    if nh os switch {{ justfile_directory() }} -H {{ host }} --update; then
      just notify 0
    else
      just notify $?
      exit 1
    fi

    just restart noctalia
    just commit

rollback gen="":
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ -z "{{ gen }}" ]]; then
      CURRENT_GEN=$(readlink /nix/var/nix/profiles/system | cut -d "-" -f 2)
      printf "{{ C_BLUE }}   ROLLBACK{{ C_NONE }} Generation $((CURRENT_GEN - 1))\n"
      nh os rollback {{ NOTIFY }}
    else
      printf "{{ C_BLUE }}   ROLLBACK{{ C_NONE }} Generation {{ gen }}\n"
      nh os rollback -t {{ gen }} {{ NOTIFY }}
    fi

clean keep_num="3":
    printf "{{ C_RED }}   CLEAN   {{ C_NONE }} Partial (Keeping: {{ keep_num }})\n"
    nh clean all --keep {{ keep_num }} {{ NOTIFY }}

nuke:
    printf "{{ C_RED }}   CLEAN   {{ C_NONE }} All\n"
    nh clean all --ask {{ NOTIFY }}
