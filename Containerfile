# In order to make a base image as part of a Dockerfile, this container build uses
# nested containerization, so you must build with e.g.
# podman build --security-opt=label=disable --cap-add=all --device /dev/fuse <...>

# Note that because of how cachi2 manages the repo files, we can't
# do the separate "repos container" pattern.
FROM quay.io/centos/centos:stream10 as builder
# skip gpgcheck due to gpgcheck="" in cachi2.repo
RUN dnf -y --nogpgcheck install rpm-ostree selinux-policy-targeted
ARG MANIFEST=standard
COPY . /src
WORKDIR /src
# Sanity testing
RUN echo starting build
RUN --mount=type=cache,target=/workdir --mount=type=bind,rw=true,src=.,dst=/buildcontext,bind-propagation=shared \
      /src/build.sh

# This pulls in the rootfs generated in the previous step
FROM oci-archive:./out.ociarchive
# Need to reference builder here to force ordering. But since we have to run
# something anyway, we might as well cleanup after ourselves.
RUN --mount=type=bind,from=builder,src=.,target=/var/tmp --mount=type=bind,rw=true,src=.,dst=/buildcontext,bind-propagation=shared rm -v /buildcontext/out.ociarchive
# This is updated by renovate
LABEL redhat.compose-id="CentOS-Stream-10-20250417.0"

# Note for now we are also keeping the legacy ostree.bootable label too
# so we can do direct upgrades from old bootc in RHEL 9.4.
LABEL containers.bootc="1" \
      ostree.bootable="1" \
      org.opencontainers.image.version=10 \
      bootc.diskimage-builder="quay.io/centos-bootc/bootc-image-builder" \
      redhat.id="centos" \
      redhat.version-id="10"
# https://pagure.io/fedora-kiwi-descriptions/pull-request/52
ENV container=oci
# Make systemd the default
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
