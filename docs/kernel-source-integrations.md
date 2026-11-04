# Kernel source integration map

This document records upstream kernel source relationships for Liquorix Unified Kernel without changing its existing Liquorix packaging/build pipeline.

## Source roles

| Project | Role | Integration policy |
|---|---|---|
| [torvalds/linux](https://github.com/torvalds/linux) | Canonical upstream Linux kernel source and vanilla baseline | Reference for kernel versions, source provenance, ABI/config comparisons, and future opt-in vanilla builds. |
| [Interested-Deving-1896/linux-merge](https://github.com/Interested-Deving-1896/linux-merge) | Downstream Linux integration tree with subsystem/development branches | Optional integration candidate. Require an explicit reviewed branch/ref and pinned commit; do not treat all branches as one stable release stream. |
| [damentz/liquorix-package](https://github.com/damentz/liquorix-package) | Existing Liquorix build/packaging infrastructure and patch series | Preserve as the current source of Liquorix packaging inputs. It is not replaced by either kernel source repository. |

## Safe integration contract

- Preserve the current distro-specific Docker/package build flow and its Liquorix upstream bootstrap.
- Keep the Liquorix patch series and packaging metadata distinct from the kernel source tree.
- Use torvalds/linux as the canonical vanilla reference for version alignment and patch-base validation.
- Use linux-merge only as an opt-in downstream source candidate after selecting a branch appropriate to the target kernel version and workload.
- Any future source selector must require an explicit source ID and branch/ref, resolve and record the immutable commit SHA, and keep source provenance in build metadata.
- Validate patch applicability, kernel configuration, architecture support, package scripts, and reproducibility before allowing either source into release builds.
- Never automatically merge the entire linux-merge branch set into mainline or Liquorix.

## Current implementation status

This change documents the source relationships only. The current build still bootstraps Liquorix packaging inputs from damentz/liquorix-package. No kernel source selection or build default is changed by this documentation.
