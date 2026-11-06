# Liquorix Unified Kernel KUMBE provider adapter

This document defines the provider boundary for KUMBE discovery and dry-run integration. It does not implement patch application, source migration, packaging, or kernel validation.

## Provider identity and source inputs

Liquorix source is assembled from at least two independently versioned inputs:

- Vanilla kernel source tarball from kernel.org, selected by `KERNEL_MAJOR`.
- Liquorix package archive from `damentz/liquorix-package`, selected by `KERNEL_MAJOR` and `LQX_REL`.

The current implementation is visible in `scripts/lib/build-common.sh` (`fetch_sources`, `apply_patches`, and `select_config`) and `scripts/build.sh`. The `scripts/lkf-build.sh` hook separately resolves an upstream package branch via `git ls-remote`.

## Adapter requirements

1. Treat the vanilla kernel tarball and Liquorix package archive as separate provenance records. A branch name or version string alone is not an immutable source identity.
2. Record cryptographic digests for downloaded archives and verify upstream signatures/checksums when published. If no trusted signature/checksum exists, report that limitation rather than inventing a commit identity.
3. Record the Liquorix package release/ref and exact patch-series contents from `linux-liquorix/debian/patches/series`, including each patch's digest and ordering.
4. Record architecture-specific config provenance: upstream x86_64 config versus repository-maintained arm64/riscv64 configs. Do not assume those config sources are interchangeable.
5. Keep distro packaging, signing, reproducibility, and architecture support as separate validation dimensions.
6. Keep legacy/EOL targets explicitly best-effort and require human approval for security-sensitive or semantic ports.

## Existing execution boundary

`fetch_sources` downloads and extracts source archives; `apply_patches` applies the selected `zen/` and `lqx/` entries directly with `patch -Np1`. KUMBE discovery must not call either function. Its dry-run must inspect cached inputs or resolve metadata without mutating the build tree. An isolated apply stage must verify patch identity, preflight each patch, preserve the original source and patch queue, and stop on ambiguous results.

## Initial adapter stages

- **Stage 0 — inventory:** source archive URLs, release identifiers, SHA-256 digests, package archive identity, patch order/hashes, architecture config source, and packaging profile.
- **Stage 1 — dry run:** target compatibility and dependency plan without extraction or mutation.
- **Stage 2 — isolated apply:** disposable source tree, verified archive inputs, patch preflight, and explicit approvals.
- **Stage 3 — validation:** distro/architecture builds, module checks, package signing, reproducibility, and runtime/boot evidence where available.

No kernel source, patch, package, or signing configuration is changed by this documentation.