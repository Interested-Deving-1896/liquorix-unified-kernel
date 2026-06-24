# liquorix-unified-kernel

[![Built with Ona](https://ona.com/build-with-ona.svg)](https://app.ona.com/#https://github.com/Interested-Deving-1896/liquorix-unified-kernel)

<!-- AI:start:what-it-does -->
This project provides a unified build and installation system for the Liquorix kernel, designed to work across multiple Linux distributions and architectures. It simplifies the process of building and installing the Liquorix kernel by offering a consistent interface and customizable options for different environments. It is intended for developers and system administrators who need to build or deploy the Liquorix kernel on various platforms.
<!-- AI:end:what-it-does -->

## Architecture

<!-- AI:start:architecture -->
The Liquorix Unified Kernel project consists of a modular build system designed to support multiple Linux distributions and architectures. The key components include a `Makefile` that defines build and installation targets, a `scripts` directory containing helper scripts, and configuration files for various distributions and architectures. The build process is controlled via `make` commands, with variables such as `DISTRO`, `RELEASE`, `ARCH`, and `KERNEL_VERSION` specifying the target environment. The project also includes GitHub workflows for CI/CD automation.

Directory structure:
```plaintext
.
├── .github/             # GitHub Actions workflows
├── configs/             # Configuration files for supported distributions
├── docs/                # Documentation files
├── packaging/           # Packaging scripts and metadata
├── remixes/             # Custom kernel remixes
├── scripts/             # Helper scripts for build and install processes
├── Makefile             # Main build system entry point
├── README.md            # Project documentation
├── LICENSE              # License information
└── VERSION              # Current version of the project
```
<!-- AI:end:architecture -->

## Install

<!-- Add installation instructions here. This section is yours — the AI will not modify it. -->

```bash
git clone https://github.com/Interested-Deving-1896/liquorix-unified-kernel.git
cd liquorix-unified-kernel
```

## Usage

<!-- Add usage examples here. This section is yours — the AI will not modify it. -->

## Configuration

<!-- Document configuration options here. This section is yours — the AI will not modify it. -->

## CI

<!-- AI:start:ci -->
The repository uses GitHub Actions for continuous integration. Below is a summary of the workflows and their purposes:

- **build.yml**: Builds the Liquorix kernel for supported distributions and architectures. No secrets required.
- **release.yml**: Creates and publishes release artifacts. Requires `GITHUB_TOKEN` for authentication.
- **cleanup-pollution.yml**: Cleans up temporary files and artifacts from previous runs. No secrets required.
- **mirror-releases.yml**: Mirrors release artifacts to external storage. Requires `MIRROR_STORAGE_KEY`.
- **sync-to-gitlab.yml**: Synchronizes the repository with a GitLab mirror. Requires `GITLAB_TOKEN`.
- **rate-limit-status.yml**: Monitors and reports GitHub API rate limits. No secrets required.
- **token-health.yml**: Validates the health of API tokens. Requires `GITHUB_TOKEN` and `GITLAB_TOKEN`.

Refer to the `.github/workflows` directory for detailed configurations. Ensure required secrets are added in the repository settings under "Secrets and variables."
<!-- AI:end:ci -->

## Mirror chain

<!-- AI:start:mirror-chain -->
This repo is maintained in [`Interested-Deving-1896/liquorix-unified-kernel`](https://github.com/Interested-Deving-1896/liquorix-unified-kernel) and mirrored through:

```
Interested-Deving-1896/liquorix-unified-kernel  ──►  OpenOS-Project-OSP/liquorix-unified-kernel  ──►  OpenOS-Project-Ecosystem-OOC/liquorix-unified-kernel
```

Changes flow downstream automatically via the hourly mirror chain in
[`fork-sync-all`](https://github.com/Interested-Deving-1896/fork-sync-all).
Direct commits to OSP or OOC are detected and opened as PRs back to `Interested-Deving-1896`.
<!-- AI:end:mirror-chain -->

## Contributors

<!-- AI:start:contributors -->
[@Interested-Deving-1896](https://github.com/Interested-Deving-1896): 300 commits  
[@web-flow](https://github.com/web-flow): 1 commit  
[@ona-agent](https://github.com/ona-agent): 1 commit  

*Note: This repository appears to be a mirror. Please refer to the upstream source for additional details.*
<!-- AI:end:contributors -->

## Origins

<!-- AI:start:origins -->
_Original project — no upstream fork._
<!-- AI:end:origins -->

## Resources

<!-- AI:start:resources -->
| File | Description |
|---|---|
| [.gitlab/merge_request_templates/Default.md](https://github.com/Interested-Deving-1896/liquorix-unified-kernel/blob/main/.gitlab/merge_request_templates/Default.md) | GitLab MR template |
| [config/gitlab-subgroups.yml](https://github.com/Interested-Deving-1896/liquorix-unified-kernel/blob/main/config/gitlab-subgroups.yml) | GitLab subgroup map |
<!-- AI:end:resources -->

## License

<!-- AI:start:license -->
<!-- License not detected — add a LICENSE file to this repo. -->
<!-- AI:end:license -->
