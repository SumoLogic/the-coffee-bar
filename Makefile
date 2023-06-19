################################################################################
# Build
################################################################################

IMAGE_NAME = the-coffee-bar
ECR_URL = public.ecr.aws/sumologic
REPO_URL = $(ECR_URL)/$(IMAGE_NAME)

#-------------------------------------------------------------------------------
.PHONY: build-dotnet-apps
build-dotnet-apps:
	REPO_URL=${REPO_URL} $(MAKE) -C ./applications/dotnet-core-the-coffee-bar-app build

.PHONY: push-dotnet-apps
push-dotnet-apps:
	REPO_URL=${REPO_URL} $(MAKE) -C ./applications/dotnet-core-the-coffee-bar-app push

#-------------------------------------------------------------------------------
.PHONY: build-clicker
build-clicker:
	REPO_URL=${REPO_URL} $(MAKE) -C ./applications/js-the-coffee-bar-ui-clicker build

.PHONY: push-clicker
push-clicker:
	REPO_URL=${REPO_URL} $(MAKE) -C ./applications/js-the-coffee-bar-ui-clicker push

#-------------------------------------------------------------------------------
.PHONY: build-python-apps
build-python-apps:
	REPO_URL=${REPO_URL} $(MAKE) -C ./applications/python-the-coffee-bar-apps build

.PHONY: push-python-apps
push-python-apps:
	REPO_URL=${REPO_URL} $(MAKE) -C ./applications/python-the-coffee-bar-apps push

#-------------------------------------------------------------------------------
.PHONY: build-ruby-apps
build-ruby-apps:
	REPO_URL=${REPO_URL} $(MAKE) -C ./applications/ruby-the-coffee-bar-apps build

.PHONY: push-ruby-apps
push-ruby-apps:
	REPO_URL=${REPO_URL} $(MAKE) -C ./applications/ruby-the-coffee-bar-apps push

#-------------------------------------------------------------------------------
.PHONY: build-frontend
build-frontend:
	REPO_URL=${REPO_URL} $(MAKE) -C ./applications/the-coffee-bar-frontend build

.PHONY: push-frontend
push-frontend:
	REPO_URL=${REPO_URL} $(MAKE) -C ./applications/the-coffee-bar-frontend push

#-------------------------------------------------------------------------------

.PHONY: build-all
build-all:
	$(MAKE) build-frontend
	$(MAKE) build-dotnet-apps
	$(MAKE) build-clicker
	$(MAKE) build-python-apps
	$(MAKE) build-ruby-apps
	$(MAKE) build-frontend

#-------------------------------------------------------------------------------
.PHONY: _login
_login:
	aws ecr-public get-login-password --region us-east-1 \
	| docker login --username AWS --password-stdin $(ECR_URL)

.PHONY: login
login:
	$(MAKE) _login \
		ECR_URL="$(ECR_URL)"

PHONY: generate-chart
CHART_NAME := sumologic-the-coffee-bar
generate-chart: kustomize ## Copy kustomize built resources to the helm chart
	$(KUSTOMIZE) build config/production > deployments/helm/$(CHART_NAME)/templates/generated.yaml

.PHONY: update-chart-version
update-chart-version:
	@echo "Updating chart version..."
	@current_version=$$(grep "version:" ./deployments/helm/$(CHART_NAME)/Chart.yaml | awk '{print $$2}') ; \
	major_version=$$(echo $$current_version | cut -d. -f1) ; \
	minor_version=$$(echo $$current_version | cut -d. -f2) ; \
	patch_version=$$(echo $$current_version | cut -d. -f3) ; \
	new_minor_version=$$((minor_version + 1)) ; \
	new_version="$$major_version.$$new_minor_version.$$patch_version" ; \
	sed -i '' -E "s/version: [[:alnum:].-]+/version: $$new_version/" ./deployments/helm/$(CHART_NAME)/Chart.yaml ; \
	echo "Updated chart version to $$new_version"

.PHONY: package-chart publish-chart
package-chart:
	@echo "Packaging chart..."
	@helm package ./deployments/helm/$(CHART_NAME) -d ./deployments/helm/charts/packages/
	@echo "Chart packaged successfully."

publish-chart:
	@echo "Publishing chart..."
	@helm repo index --merge ./deployments/helm/charts/index.yaml ./deployments/helm/charts/
	@echo "Chart published successfully."

.PHONY: release-chart
release-chart: update-chart-version package-chart publish-chart

## Location to install dependencies to
LOCALBIN ?= $(shell pwd)/bin
$(LOCALBIN):
	mkdir -p $(LOCALBIN)

## Tool Binaries
KUSTOMIZE ?= $(LOCALBIN)/kustomize
CONTROLLER_GEN ?= $(LOCALBIN)/controller-gen
ENVTEST ?= $(LOCALBIN)/setup-envtest

## Tool Versions
KUSTOMIZE_VERSION ?= v3.8.7
CONTROLLER_TOOLS_VERSION ?= v0.11.1

KUSTOMIZE_INSTALL_SCRIPT ?= "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"
.PHONY: kustomize
kustomize: $(KUSTOMIZE) ## Download kustomize locally if necessary. If wrong version is installed, it will be removed before downloading.
$(KUSTOMIZE): $(LOCALBIN)
	@if test -x $(LOCALBIN)/kustomize && ! $(LOCALBIN)/kustomize version | grep -q $(KUSTOMIZE_VERSION); then \
		echo "$(LOCALBIN)/kustomize version is not expected $(KUSTOMIZE_VERSION). Removing it before installing."; \
		rm -rf $(LOCALBIN)/kustomize; \
	fi
	test -s $(LOCALBIN)/kustomize || { curl -Ss $(KUSTOMIZE_INSTALL_SCRIPT) | bash -s -- $(subst v,,$(KUSTOMIZE_VERSION)) $(LOCALBIN); }
