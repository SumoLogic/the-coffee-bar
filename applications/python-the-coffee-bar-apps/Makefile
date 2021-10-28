TAG ?= pythonAppsv0.1.0-ot1.5.0-0.24b0
FINAL_TAG = $(REPO_URL):$(TAG)

.PHONY: build
build:
	DOCKER_BUILDKIT=1 docker build \
		--tag $(FINAL_TAG) \
		.

.PHONY: push
push:
	docker push $(FINAL_TAG)
