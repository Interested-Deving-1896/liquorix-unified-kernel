# Btrfs-DwarFS Framework (BDFS) integration for Liquorix Unified Kernel

BDFS currently provides an out-of-tree module named `btrfs_dwarfs.ko`, built
with `CONFIG_BTRFS_DWARFS` and registering filesystem type `bdfs_blend`.
It is not an in-tree `fs/bdfs/` implementation, and this integration does not
claim standalone root-filesystem support.

## Why an explicit kernel tree is required

The normal Liquorix package build fetches and builds source inside Docker using
the upstream `damentz/liquorix-package` build flow. The repository does not
currently expose a persistent, configured kernel source/build tree from that
workflow for a follow-on external module build. Therefore this target does not
pretend it can compile BDFS from the package artifact directory alone.

## Build BDFS against a configured Liquorix tree

Provide a configured kernel source/build tree with generated headers and a
final `.config`, plus a BDFS checkout containing
`integrations/kernels/build-module.sh` (introduced by BDFS PR #18):

```sh
make bdfs-module \
  KERNEL_BUILD_DIR=/path/to/configured/liquorix/kernel/tree \
  BDFS_DIR=/path/to/btrfs-dwarfs-framework
```

The default output is `artifacts/bdfs/btrfs_dwarfs.ko`. The target only builds
and stages the module; it does not install or load it, alter kernel defaults,
package it into Liquorix releases, change rootfs boot parameters, or run
privileged operations.

## Remaining gates

- Establish how to retain or export the configured source/build tree from each
  supported Liquorix package build without bypassing its upstream packaging.
- Compile against supported Liquorix kernel versions and architectures.
- Package with correct kernel-version dependencies and module-signing policy.
- Test load/unload and `bdfs_blend` mount/unmount on disposable VMs.
- Validate initramfs and recovery independently before any boot/rootfs changes.
