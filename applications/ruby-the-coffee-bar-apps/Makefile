BASE_TAG = rubyAppsv0.2.1-ot1.4.0-0.60.0-0.26.3

ifndef GITHUB_HEAD_REF
	TAG = $(BASE_TAG)
else
	TAG = $(BASE_TAG)-dev-$(GITHUB_HEAD_REF)
endif

FINAL_TAG = $(REPO_URL):$(TAG)

.PHONY: build
build:
	DOCKER_BUILDKIT=1 docker build \
		--tag $(FINAL_TAG) \
		.

.PHONY: push
push:
	docker push $(FINAL_TAG)
