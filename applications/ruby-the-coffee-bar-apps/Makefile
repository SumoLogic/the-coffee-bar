TAG ?= rubyAppsv0.0.1-ot1.0.0-0.21.3-0.20.5
FINAL_TAG = $(REPO_URL):$(TAG)

.PHONY: build
build:
	DOCKER_BUILDKIT=1 docker build \
		--tag $(FINAL_TAG) \
		.

.PHONY: push
push:
	docker push $(FINAL_TAG)
