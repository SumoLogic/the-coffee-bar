BASE_TAG = rubyAppsv0.2.1-ot1.5.0-0.62.1-0.28.1

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
