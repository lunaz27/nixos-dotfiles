#!/usr/bin/env bash

EXIT_CODE="${1:-0}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICON_PATH="$SCRIPT_DIR/../images/logos/nixos-colorful.png"

C_RED="\033[1;31m"
C_GREEN="\033[1;32m"
C_RESET="\033[0m"

IS_GUI_RUNNING() {
  pgrep "noctalia" &>/dev/null
}

# Warning notification
if [[ "$EXIT_CODE" -ne 0 ]]; then
  printf '%b   FAILED  %b Task\n' "$C_RED" "$C_RESET"

  if IS_GUI_RUNNING; then
    nix run nixpkgs#libnotify -- \
      --transient \
      -u critical \
      -a "System Task" \
      -i "$ICON_PATH" \
      "Task Failed (Code: $EXIT_CODE)" \
      "The operation was aborted. Check your Kitty terminal for the error."
  fi

  exit 1
fi

# Success notification
printf '%b   SUCCESS %b Task\n' "$C_GREEN" "$C_RESET"

if IS_GUI_RUNNING; then
  nix run nixpkgs#libnotify -- \
    --transient \
    -a "System Task" \
    -i "$ICON_PATH" \
    "Task Completed" \
    "The operation finished successfully without errors."
fi

exit 0
