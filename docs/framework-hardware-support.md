# Framework hardware and architecture support — Liquorix Unified Kernel

## Upstream source map

Framework Computer publishes multiple distinct source and documentation projects. Treat each as an independently versioned, read-only upstream input; do not assume the whole organisation is one driver package.

- [Framework Linux documentation](https://github.com/FrameworkComputer/linux-docs) — Linux installation, device and firmware guidance.
- [Framework Laptop 12 documentation](https://github.com/FrameworkComputer/Framework-Laptop-12), [Laptop 13 documentation](https://github.com/FrameworkComputer/Framework-Laptop-13), and [Laptop 16 documentation](https://github.com/FrameworkComputer/Framework-Laptop-16) — model-specific mainboard, component and module documentation. Hardware revisions must remain distinct.
- [framework-system](https://github.com/FrameworkComputer/framework-system) — cross-platform Rust libraries and tools for interacting with Framework system features. Its published package availability is distribution/version dependent; verify current package metadata before enabling installation.
- [inputmodule-rs](https://github.com/FrameworkComputer/inputmodule-rs) and [InputModules](https://github.com/FrameworkComputer/InputModules) — host tools and firmware for Framework Laptop 16 input modules. The upstream documentation describes USB ACM serial control and Linux udev permissions; device access must be opt-in and least-privilege.
- [EmbeddedController](https://github.com/FrameworkComputer/EmbeddedController) — embedded-controller firmware source. Treat firmware build/flash as a separate, high-risk workflow.
- [ExpansionCards](https://github.com/FrameworkComputer/ExpansionCards) and [ExpansionBay](https://github.com/FrameworkComputer/ExpansionBay) — modular hardware references, not generic kernel drivers.

Framework's GitHub repositories are upstream source references. Preserve their individual licenses, notices, version pins and contribution rules. Do not mirror binaries or firmware blindly.

## Integration contract

1. Identify the exact Framework product family, generation/revision and relevant device identifiers. Never infer that Laptop 12, 13, 16, Desktop and individual expansion modules share one support profile.
2. Collect hardware inventory using read-only probes. Record DMI/product identity, PCI/USB IDs, ACPI/platform devices, kernel release/config, firmware versions where safely readable, and evidence provenance. Redact serial numbers and other unique identifiers from logs.
3. Classify each feature separately: kernel driver, upstream Linux driver/configuration, user-space tool, firmware, EC/UEFI operation, expansion/input module, or documentation-only support.
4. Pin each source revision and license. Resolve whether a feature is already supported by the distribution kernel before adding an out-of-tree module or vendor patch.
5. Build user-space tools and external modules in isolated CI against an explicit distro release, architecture, compiler/toolchain and kernel ABI. Record dependencies, signatures, SBOM/provenance and reproducible build evidence.
6. Make package installation and device permissions explicit opt-ins. Keep firmware/EC/UEFI flashing, Secure Boot changes and kernel replacement in separate protected workflows with independent approval and recovery procedures.
7. Test on a model/revision matrix. VM tests can validate packaging and non-hardware logic but cannot prove physical device support.

## Project responsibility

PROJECT_ROLE

## Safety and compatibility

- Do not import an entire vendor kernel tree into Liqxanmod, Liquorix or XanMod. Keep upstream kernel trees, patch stacks and external modules separate.
- Do not assume a driver is required simply because a Framework repository exists; prefer maintained in-tree Linux support when verified.
- Do not run privileged firmware/EC update tools, flash firmware, alter BIOS/UEFI settings, change Secure Boot, load/unload modules on a developer host, or replace the running kernel as part of discovery or CI.
- Do not grant broad access to /dev/ttyACM* or add permissive udev rules. If an input module is supported, scope rules to verified USB vendor/product identifiers and the minimum required group/permissions.
- Treat model-specific documentation and firmware as versioned, licensed inputs; preserve upstream attribution and do not redistribute where terms do not permit.
- Unsupported, unknown and not-yet-tested combinations must remain explicit; never label documentation-only support as operationally supported.

## Implementation status

This document establishes source provenance, project boundaries and a validation plan. It does not claim that Framework devices have been detected, that any module or package has been built, or that firmware/input-module/kernel behavior has passed hardware tests. Those claims require CI artifacts and physical-device evidence for the exact model/revision and software stack.
