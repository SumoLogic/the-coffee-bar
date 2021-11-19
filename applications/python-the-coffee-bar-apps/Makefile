TAG ?= pythonAppsv0.1.1-ot1.7.1-0.26b1
FINAL_TAG = $(REPO_URL):$(TAG)

.PHONY: build
build:
	DOCKER_BUILDKIT=1 docker build \
		--tag $(FINAL_TAG) \
		.

.PHONY: push
push:
	docker push $(FINAL_TAG)
