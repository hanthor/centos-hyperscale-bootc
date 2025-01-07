# centos-bootc

This repository uses the [Fedora bootc base-image](https://gitlab.com/fedora/bootc/base-images)
as a git submodule, and defines the CentOS Stream images.

## More information

- <https://docs.fedoraproject.org/en-US/bootc/>

## Building locally

As this repository uses [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) you must initialize them:

`git submodule update --init --recursive`

After that, you should be able to build with e.g.:

`podman build --security-opt=label=disable --cap-add=all --device /dev/fuse -t localhost/c9s .`

For more on why these capabilities are required, see the upstream docs in <https://gitlab.com/fedora/bootc/base-images>, especially the copy of `Containerfile` there.

## Build system information

The production build system is maintained [in a Konflux pipeline](https://console.redhat.com/preview/application-pipeline/workspaces/centos-bootc/applications/centos-bootc-c10s).

## Badges

| Badge                   | Description          | Service      |
| ----------------------- | -------------------- | ------------ |
| [![Renovate][1]][2]     | Dependencies         | Renovate     |
| [![Pre-commit][3]][4]   | Static quality gates | pre-commit   |

[1]: https://img.shields.io/badge/renovate-enabled-brightgreen?logo=renovate
[2]: https://renovatebot.com
[3]: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit
[4]: https://pre-commit.com/
