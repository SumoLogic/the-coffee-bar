################################################################################
# Build
################################################################################

IMAGE_NAME = the-coffee-bar
ECR_URL = public.ecr.aws/a4t4y2n3
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
