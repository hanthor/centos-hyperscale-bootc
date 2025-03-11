.PHONY: build
build:
	rpm-ostree compose image --format=ociarchive --initialize --image-config=centos-bootc-config.json centos-stream-tier1.yaml dest.oci-archive

.PHONY: lockfile
lockfile:
ifdef CI
	git submodule update --init --recursive
endif
	for VARIANT in minimal standard tier-x; do \
		FULL_PATH="fedora-bootc/$$VARIANT"; \
		cp -a "$$FULL_PATH" .; \
	done
	rpm-lockfile-prototype rpms.in.yaml
