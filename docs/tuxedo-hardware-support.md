# TUXEDO hardware support integration

## Source repositories

- [tuxedo-drivers](https://github.com/Interested-Deving-1896/tuxedo-drivers) — read-only GitHub mirror of [TUXEDO's GitLab driver package](https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers). It builds external kernel modules against a selected kernel build tree and provides Debian/RPM package targets.
- [tuxedo_linux](https://github.com/Interested-Deving-1896/tuxedo_linux) — read-only GitHub mirror of TUXEDO's vendor kernel source. Its default branch is `tuxedo-6.5-22.04`; upstream work belongs at [TUXEDO's GitLab Linux project](https://gitlab.com/tuxedocomputers/development/packages/linux).

## Liquorix integration

Treat TUXEDO support as an optional external-module compatibility target. Do not merge the complete TUXEDO kernel tree into the Liquorix source or assume vendor-specific patches are compatible with the Liquorix/Zen patch set.

1. Pin the driver source revision and record its license/provenance.
2. Build against the exact Liquorix kernel headers/build output for each supported distro release and architecture.
3. Validate Kconfig, symbols, compiler/toolchain, module signing and ABI compatibility.
4. Produce a separate, versioned package/artifact with explicit dependency on the matching Liquorix kernel ABI.
5. Test in an isolated VM or supported TUXEDO hardware matrix before marking a device/kernel combination supported.

## Guardrails and status

No automatic kernel replacement, host module loading, Secure Boot or firmware changes, or release publication. The GitHub sources are mirrors; contribute fixes to the TUXEDO GitLab projects. The vendor's 6.5/22.04 branch does not establish compatibility with current Liquorix targets.

This document establishes the integration contract only. Driver porting, package generation and hardware validation remain unimplemented until backed by build and runtime evidence.
