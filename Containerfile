FROM quay.io/centos/centos:stream10 as builder
# skip gpgcheck due to gpgcheck="" in cachi2.repo
RUN dnf -y --nogpgcheck install rpm-ostree selinux-policy-targeted
ARG MANIFEST=centos-stream-tier1.yaml
COPY . /src
RUN /src/preflight.sh
WORKDIR /src
RUN rm -vf /src/*.repo
# make locally cached deps cachi2.repo available in the build context
RUN cp -v /etc/yum.repos.d/*.repo /src
# ``rpm-ostree compose`` looks for repofiles in that same directory as the MANIFEST file is in
RUN --mount=type=cache,target=/workdir --mount=type=bind,rw=true,src=.,dst=/buildcontext,bind-propagation=shared \
      rpm-ostree compose image --cachedir=/workdir --format=ociarchive --initialize --image-config=centos-bootc-config.json ${MANIFEST} /buildcontext/out.ociarchive

FROM oci-archive:./out.ociarchive
# Need to reference builder here to force ordering. But since we have to run
# something anyway, we might as well cleanup after ourselves.
RUN --mount=type=bind,from=builder,src=.,target=/var/tmp --mount=type=bind,rw=true,src=.,dst=/buildcontext,bind-propagation=shared rm /buildcontext/out.ociarchive

# This is updated by renovate
LABEL redhat.compose-id="CentOS-Stream-10-20250217.0"

LABEL containers.bootc="1" \
      bootc.diskimage-builder="quay.io/centos-bootc/bootc-image-builder" \
      redhat.id="centos" \
      redhat.version-id="10"
