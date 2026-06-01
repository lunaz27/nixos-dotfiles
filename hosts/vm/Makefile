# Systems information & Macros
HOST = vm
NIX_FILES = $(shell find . -name '*.nix')
NOTIFY = ; status=$$?; bash ../../scripts/statusNotify.sh $$status; exit $$status

# ANSI color codes
C_RED   := \033[1;31m
C_GREEN := \033[1;32m
C_BLUE  := \033[1;34m
C_YELLOW := \033[1;33m
C_NONE := \033[0m

all: run ## Default option: run

git:
	@printf "$(C_GREEN)   GIT     $(C_NONE) *\n"
	@git add -A


run: git .is-vm-built ## Run NixOS VM
	@sudo QEMU_KERNEL_PARAMS=console=ttyS0 ./result/bin/run-nixos-vm -nographic; reset

.is-vm-built: $(NIX_FILES) ## Build NixOS VM
	@printf "$(C_BLUE)   BUILD   $(C_NONE) ${HOST}\n"
	@nh os build-vm -f '<nixpkgs/nixos>' -- -I nixos-config=/home/suwapotta/nixos-dotfiles/hosts/vm/configuration.nix
	@touch .is-vm-built $(NOTIFY)

iso: git ## Build vm iso
	# @printf "$(C_BLUE)   ISO     $(C_NONE) ${HOST}\n"
	# @nh os build-image --image-variant iso -f '<nixpkgs/nixos>' -- -I nixos-config=/home/suwapotta/nixos-dotfiles/hosts/vm/configuration.nix

clean: ## Ignore this option
	@printf "$(C_YELLOW)   NOTE    $(C_NONE) Please use $(C_RED)\`nh clean\`$(C_NONE) command\n"
	@bash ../../scripts/statusNotify.sh 1

help: ## Show this help message
	@printf "$(C_GREEN)Available commands:$(C_NONE)\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(C_BLUE)%-15s$(C_NONE) %s\n", $$1, $$2}'

.PHONY: all git run iso clean help
