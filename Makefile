default: build

.PHONY: build publish

#
# Depdendency targets
#
BAZAAR_VERSION ?= 0.4.33
temp/bazaar-$(BAZAAR_VERSION).linux:
	mkdir -p temp
	wget --directory-prefix temp \
		https://github.com/cf-platform-eng/bazaar/releases/download/$(BAZAAR_VERSION)/bazaar-$(BAZAAR_VERSION).linux

OPS_MANIFEST_VERSION ?= 2.6.0-internalDev.93
OPS_MANIFEST_FILE_NAME = $(shell pivnet product-files --product-slug pivotal-ops-manifest --release-version $(OPS_MANIFEST_VERSION) --format=json | jq -r '.[0].aws_object_key' | xargs basename)
OPS_MANIFEST_FILE_ID = $(shell pivnet product-files --product-slug pivotal-ops-manifest --release-version $(OPS_MANIFEST_VERSION) --format=json | jq -r '.[0].id')
temp/ops-manifest.gem:
	mkdir -p temp
	touch temp/$(OPS_MANIFEST_FILE_NAME)
	pivnet download-product-files \
		--accept-eula \
		--product-slug pivotal-ops-manifest \
		--release-version $(OPS_MANIFEST_VERSION) \
		--product-file-id $(OPS_MANIFEST_FILE_ID) \
		--download-dir temp
	mv temp/$(OPS_MANIFEST_FILE_NAME) temp/ops-manifest.gem

PKS_VERSION ?= 1.4.0
PKS_FILE_NAME = $(shell pivnet product-files --product-slug pivotal-container-service --release-version $(PKS_VERSION) --format=json | jq -r '.[] | select(.name=="PKS CLI - Linux") | .aws_object_key' | xargs basename)
PKS_FILE_ID = $(shell pivnet product-files --product-slug pivotal-container-service --release-version $(PKS_VERSION) --format=json | jq -r '.[] | select(.name=="PKS CLI - Linux") | .id')
temp/pks:
	mkdir -p temp
	touch temp/$(PKS_FILE_NAME)
	pivnet download-product-files \
		--accept-eula \
		--product-slug pivotal-container-service \
		--release-version $(PKS_VERSION) \
		--product-file-id $(PKS_FILE_ID) \
		--download-dir temp
	mv temp/$(PKS_FILE_NAME) temp/pks

#
# Docker image targets
#
temp/phony/cfplatformeng/test-bazaar-ci: Dockerfile.base
	docker build . --file Dockerfile.base --tag gcr.io/fe-rabbit-mq-tile-ci/base-test-image:latest
	mkdir -p temp/phony/cfplatformeng && touch temp/phony/cfplatformeng/test-bazaar-ci

build: temp/bazaar-$(BAZAAR_VERSION).linux temp/ops-manifest.gem temp/pks temp/phony/cfplatformeng/test-bazaar-ci

publish: build
	echo "WARNING: this image contains files that are not fit for public release.  DO NOT PUBLISH PUBLICLY"
	docker push gcr.io/fe-rabbit-mq-tile-ci/base-test-image:latest

run: build
	docker run -it gcr.io/fe-rabbit-mq-tile-ci/base-test-image:latest bash
