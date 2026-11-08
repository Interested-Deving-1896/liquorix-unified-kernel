# Liquorix Unified Build System
#
# Usage:
#   make                          # show available targets
#   make build-debian RELEASE=trixie
#   make build-ubuntu RELEASE=noble
#   make build-arch
#   make build-fedora
#   make KERNEL_VERSION=6.12.1 build-gentoo
#   make install
#
# Variables:
#   PROCS          parallel jobs (default: nproc/2, min 2)
#   BUILD          build number (default: 1)
#   DISTRO         distro name — required for per-release targets
#   RELEASE        release codename — required for Debian/Ubuntu targets
#   ARCH           target architecture: x86_64|arm64|riscv64 (default: host)
#   KERNEL_VERSION kernel version for Gentoo builds (e.g. 6.12.1)

NPROC  := $(shell nproc 2>/dev/null || echo 4)
PROCS  := $(shell echo $$(( $(NPROC) / 2 > 2 ? $(NPROC) / 2 : 2 )))
BUILD  := 1
DISTRO         :=
RELEASE        :=
ARCH           := $(shell uname -m | sed 's/aarch64/arm64/')
FEDORA_RELEASE   := 42
OPENSUSE_RELEASE := tumbleweed

SCRIPTS := scripts

require-release = \
	$(if $(DISTRO),,$(error DISTRO is required)) \
	$(if $(RELEASE),,$(error RELEASE is required, e.g. make $@ DISTRO=debian RELEASE=trixie))

.PHONY: help \
	install \
	build-debian build-ubuntu build-arch build-fedora build-gentoo build \
	bootstrap-debian bootstrap-ubuntu bootstrap-arch bootstrap-fedora \
	clean \
	bdfs-module

help: ## Show available targets
	@echo "Liquorix Unified Build System"
	@echo ""
	@echo "Usage: make [target] [VARIABLE=value ...]"
	@echo ""
	@echo "Variables:"
	@printf "  %-18s %s\n" "PROCS=$(PROCS)"  "parallel jobs (nproc/2, min 2)"
	@printf "  %-18s %s\n" "BUILD=$(BUILD)"  "build number"
	@printf "  %-18s %s\n" "ARCH=$(ARCH)"    "target architecture"
	@printf "  %-18s %s\n" "RELEASE="           "release codename (Debian/Ubuntu)"
	@printf "  %-18s %s\n" "FEDORA_RELEASE=42"          "Fedora release number"
	@printf "  %-18s %s\n" "OPENSUSE_RELEASE=tumbleweed" "openSUSE release"
	@printf "  %-18s %s\n" "KERNEL_VERSION="    "kernel version (Gentoo)"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-z][a-z-]+:.*##' $(MAKEFILE_LIST) | \
		awk -F ':.*## ' '{ printf "  %-22s %s\n", $$1, $$2 }'

# ── Install ───────────────────────────────────────────────────────────────────

install: ## Install Liquorix on the current system (auto-detects distro)
	sudo KERNEL_VERSION=$(KERNEL_VERSION) $(SCRIPTS)/install.sh

# ── Build — per distro ────────────────────────────────────────────────────────

build-debian: ## Build .deb packages (needs RELEASE=<codename>, e.g. trixie)
	$(if $(RELEASE),,$(error RELEASE is required, e.g. make $@ RELEASE=trixie))
	$(SCRIPTS)/build.sh --distro debian --release $(RELEASE) --arch $(ARCH) --jobs $(PROCS) --build $(BUILD)

build-ubuntu: ## Build .deb packages for Ubuntu (needs RELEASE=<codename>, e.g. noble)
	$(if $(RELEASE),,$(error RELEASE is required, e.g. make $@ RELEASE=noble))
	$(SCRIPTS)/build.sh --distro ubuntu --release $(RELEASE) --arch $(ARCH) --jobs $(PROCS) --build $(BUILD)

build-arch: ## Build Arch Linux .pkg.tar.zst
	$(SCRIPTS)/build.sh --distro arch --arch $(ARCH) --jobs $(PROCS)

build-fedora: ## Build Fedora RPM packages (FEDORA_RELEASE=42)
	FEDORA_RELEASE=$(FEDORA_RELEASE) $(SCRIPTS)/build.sh --distro fedora --arch $(ARCH) --jobs $(PROCS) --build $(BUILD)

build-opensuse: ## Build openSUSE RPM packages (OPENSUSE_RELEASE=tumbleweed)
	OPENSUSE_RELEASE=$(OPENSUSE_RELEASE) $(SCRIPTS)/build.sh --distro opensuse --arch $(ARCH) --jobs $(PROCS) --build $(BUILD)

build-gentoo: ## Build Gentoo kernel with genkernel (needs KERNEL_VERSION=x.y.z)
	$(if $(KERNEL_VERSION),,$(error KERNEL_VERSION is required, e.g. make $@ KERNEL_VERSION=6.12.1))
	KERNEL_VERSION=$(KERNEL_VERSION) $(SCRIPTS)/build.sh --distro gentoo --arch $(ARCH) --jobs $(PROCS)

build: ## Build for a single release (needs DISTRO= and RELEASE= for deb targets)
	$(SCRIPTS)/build.sh --distro $(DISTRO) $(if $(RELEASE),--release $(RELEASE),) --arch $(ARCH) --jobs $(PROCS) --build $(BUILD)

# ── Btrfs-DwarFS Framework (BDFS) external module ─────────────────────────────
# Liquorix builds kernel packages inside Docker, so callers must supply a
# configured source/build tree when they want to compile the external module.
BDFS_DIR ?= $(shell \
	if [ -f "$(CURDIR)/../btrfs-dwarfs-framework/integrations/kernels/build-module.sh" ]; then \
		echo "$(CURDIR)/../btrfs-dwarfs-framework"; \
	elif [ -f "$(CURDIR)/../../btrfs-dwarfs-framework/integrations/kernels/build-module.sh" ]; then \
		echo "$(CURDIR)/../../btrfs-dwarfs-framework"; \
	else echo ""; fi)
KERNEL_BUILD_DIR ?=
BDFS_ARTIFACT_DIR ?= $(CURDIR)/artifacts/bdfs

bdfs-module: ## Build and stage BDFS .ko against an explicitly configured kernel tree
	@[ -n "$(BDFS_DIR)" ] || { echo "Set BDFS_DIR=/path/to/btrfs-dwarfs-framework"; exit 1; }
	@[ -f "$(BDFS_DIR)/integrations/kernels/build-module.sh" ] || { echo "BDFS external-module helper not found; use the BDFS integration branch or a revision with the helper merged."; exit 1; }
	@[ -n "$(KERNEL_BUILD_DIR)" ] || { echo "Set KERNEL_BUILD_DIR=/path/to/configured/liquorix/kernel/tree. This repository's package build uses Docker and does not expose a persistent configured source tree by default."; exit 1; }
	@[ -f "$(KERNEL_BUILD_DIR)/Makefile" ] && [ -f "$(KERNEL_BUILD_DIR)/.config" ] || { echo "Configured kernel tree not found at $(KERNEL_BUILD_DIR)."; exit 1; }
	bash "$(BDFS_DIR)/integrations/kernels/build-module.sh" "$(KERNEL_BUILD_DIR)" "$(BDFS_ARTIFACT_DIR)"

# ── Bootstrap Docker images ───────────────────────────────────────────────────
# bootstrap-* targets fetch upstream Dockerfiles + container scripts from
# damentz/liquorix-package, then build the Docker images.

bootstrap-debian: ## Fetch upstream scripts and build Debian Docker images
	$(SCRIPTS)/bootstrap.sh debian

bootstrap-ubuntu: ## Fetch upstream scripts and build Ubuntu Docker images
	$(SCRIPTS)/bootstrap.sh ubuntu

bootstrap-arch: ## Fetch upstream scripts and build Arch Linux Docker image
	$(SCRIPTS)/bootstrap.sh arch

bootstrap-fedora: ## Fetch upstream scripts and build Fedora Docker images
	$(SCRIPTS)/bootstrap.sh fedora

bootstrap-opensuse: ## Build openSUSE Docker images
	$(SCRIPTS)/bootstrap.sh opensuse

bootstrap-all: ## Bootstrap all distros
	$(SCRIPTS)/bootstrap.sh

# ── Cleanup ───────────────────────────────────────────────────────────────────

clean: ## Remove build artifacts and Liquorix Docker images
	rm -rf artifacts/
	docker images --format '{{.Repository}}:{{.Tag}}' \
		| grep '^liquorix-build-' \
		| xargs -r docker rmi || true
