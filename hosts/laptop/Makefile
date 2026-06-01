# Systems information & Macros
FLAKE_HOST = laptop
NOTIFY = ; status=$$?; bash ../../scripts/statusNotify.sh $$status; exit $$status

# ANSI color codes
C_RED   := \033[1;31m
C_GREEN := \033[1;32m
C_BLUE  := \033[1;34m
C_NONE := \033[0m

all: switch

qemu: ## Switch to qemu/kvm virtualisation
	@printf "$(C_BLUE)   SPECIAL $(C_NONE) NixOS#${FLAKE_HOST}\n"
	@nh os test --specialisation Virtualisation -H ${FLAKE_HOST} $(NOTIFY)

switch: git ## Build new NixOS generation
	@printf "$(C_BLUE)  󰟁 SWITCH  $(C_NONE) NixOS#${FLAKE_HOST}\n"
	@nh os switch . -H ${FLAKE_HOST} $(NOTIFY)
	@bash ../../scripts/autoCommit.sh

boot: git ## Add new NixOS generation boot entry
	@printf "$(C_BLUE)  󰜉 BOOT    $(C_NONE) NixOS#${FLAKE_HOST}\n"
	@nh os boot . -H ${FLAKE_HOST} $(NOTIFY)

dry: git ## Print steps for building new generation
	@printf "$(C_BLUE)   DRY     $(C_NONE) NixOS#${FLAKE_HOST}\n"
	@nh os switch . -H ${FLAKE_HOST} --dry $(NOTIFY)

test: git ## Run temporary NixOS generation until poweroff
	@printf "$(C_BLUE)  󰙨 TEST    $(C_NONE) NixOS#${FLAKE_HOST}\n"
	@nh os test . -H ${FLAKE_HOST} $(NOTIFY)

build-vm: git ## Build NixOS Virtual Machine
	@printf "$(C_BLUE)   VM      $(C_NONE) NixOS#${FLAKE_HOST}\n"
	@nh os build-vm . -H ${FLAKE_HOST} $(NOTIFY)

build-iso: git ## Build NixOS iso image
	@printf "$(C_BLUE)  󰗮 ISO     $(C_NONE) NixOS#${FLAKE_HOST}\n"
	@nh os build-image -H ${FLAKE_HOST} --image-variant iso $(NOTIFY)

legacy: git ## Run legacy nixos-rebuild switch
	@printf "$(C_BLUE)  󰟁 SWITCH  $(C_NONE) (L) NixOS#${FLAKE_HOST}\n"
	@sudo nixos-rebuild switch --flake ${CURDIR}#${FLAKE_HOST} $(NOTIFY)
	@bash ../../scripts/autoCommit.sh

clean: ## Clear all devshells binary and keep 3 latest NixOS generation
	@printf "$(C_RED)   CLEAN   $(C_NONE) Partial\n"
	@nh clean all --keep 3 $(NOTIFY)

nuke: ## Keep only current NixOS generation (not recommended)
	@printf "$(C_RED)   CLEAN   $(C_NONE) All\n"
	@nh clean all --ask $(NOTIFY)

update: git ## Update flake.lock + neovim plugins and building new NixOS generation
	@printf "$(C_BLUE)   UPDATE  $(C_NONE) lazy.nvim\n"
	@NVIM_APPNAME=lvim nvim --headless "+Lazy! sync" +qa &>/dev/null
	@printf "$(C_BLUE)   UPDATE  $(C_NONE) vim.pack\n"
	@nvim --headless +"lua vim.pack.update()" +w +qa &>/dev/null
	@printf "$(C_BLUE)  󰟁 UPDATE  $(C_NONE) NixOS#${FLAKE_HOST}\n"
	@nh os switch . -H ${FLAKE_HOST} --update
	@bash ../../scripts/autoCommit.sh
	@if pgrep ".quickshell-wra" >/dev/null 2>&1; then \
		printf "$(C_RED)   PKILL?  $(C_NONE) noctalia-shell [Y/n]: "; \
		\
		read answer; \
		if [ "$$answer" == "n" ] && [ "$$answer" == "N" ]; then \
			kill -15 $$(pgrep ".quickshell-wra") 2>/dev/null || true; \
			nohup noctalia-shell >/dev/null 2>&1 & \
			printf "$(C_BLUE)   RESTART $(C_NONE) noctalia-shell\n"; \
			sleep 3; \
		else \
			printf "$(C_BLUE)  󰜺 SKIPPED $(C_NONE) noctalia-shell\n"; \
		fi; \
	fi $(NOTIFY)

safety: ## Safety measure for zen-beta browser
	@if pgrep "zen-beta" >/dev/null 2>&1; then \
		printf "$(C_RED)   PKILL?  $(C_NONE) zen-beta [y/N]: "; \
		\
		read answer; \
		if [ "$$answer" != "y" ] && [ "$$answer" != "Y" ]; then \
			printf "$(C_BLUE)  󰜺 SKIPPED $(C_NONE) zen-beta\n"; \
		else \
			pkill zen-beta; \
			printf "$(C_RED)  󱒼 KILLED  $(C_NONE) zen-beta\n"; \
		fi; \
	fi

git: safety ## Make all files visible to Nix
	@printf "$(C_GREEN)   GIT     $(C_NONE) *\n"
	@git add -A

help: ## Show this help message
	@printf "$(C_GREEN)Available commands:$(C_NONE)\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(C_BLUE)%-15s$(C_NONE) %s\n", $$1, $$2}'

.PHONY: all qemu switch boot dry test build-vm build-iso legacy clean nuke update safety git help
