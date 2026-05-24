#!/usr/bin/env bash

GEN=$(readlink /nix/var/nix/profiles/system | cut -d "-" -f 2)
MESS="[ AUTO ] NixOS Generation $GEN"
DESC="Saved latest generation $GEN at $(date -u +%Y-%m-%d\ %H:%M:%S)."

C_GREEN="\033[1;32m"
C_BLUE="\033[1;34m"
C_NONE="\033[0m"

git add -A "$HOME/nixos-dotfiles"

if git diff --quiet --cached; then
  printf "%b   SKIPPED  %b Auto-commit\n" "${C_BLUE}" "${C_NONE}"
  exit 0
fi

git commit -m "$MESS" -m "$DESC" &>/dev/null
printf "%b   COMMIT  %b Latest Generation\n" "${C_GREEN}" "${C_NONE}"
