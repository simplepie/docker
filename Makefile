##
# DO NOT EDIT THIS FILE MANUALLY!
#
# Instead, update the template file and re-run the appropriate dev-unify task.
##

#-------------------------------------------------------------------------------
# Global variables.

PHP_LAST=7.2
PHP_CURR=7.3
PHP_NEXT=7.4

PHP_LAST_EXT_DATE=20170718
PHP_CURR_EXT_DATE=20180731
PHP_NEXT_EXT_DATE=20190529

BUILD_DOCKER=docker build --compress --force-rm --squash
BUILD_COMPOSE=docker-compose build --pull --compress --parallel

COMPOSE_72=tests-72 coverage-72
COMPOSE_73=tests-73 coverage-73
COMPOSE_74=tests-74

TEST_QUICK=tests-72 tests-73 tests-74
TEST_COVER=coverage-72 coverage-73

IMAGES_72=simplepieng/base:$(PHP_LAST) simplepieng/test-coverage:$(PHP_LAST) simplepieng/test-runner:$(PHP_LAST)
IMAGES_73=simplepieng/base:$(PHP_CURR) simplepieng/test-coverage:$(PHP_CURR) simplepieng/test-runner:$(PHP_CURR)
IMAGES_74=simplepieng/base:$(PHP_NEXT) simplepieng/test-coverage:$(PHP_NEXT) simplepieng/test-runner:$(PHP_NEXT)

#-------------------------------------------------------------------------------
# Running `make` will show the list of subcommands that will run.

all:
	@cat Makefile | grep "^[a-z]" | sed 's/://' | awk '{print $$1}'

#-------------------------------------------------------------------------------
# Base Docker images so that we have some repeatability

.PHONY: base-72
base-72:
	$(BUILD_DOCKER) --tag simplepieng/base:$(PHP_LAST) --file build/base/Dockerfile-$(PHP_LAST) .

.PHONY: base-73
base-73:
	$(BUILD_DOCKER) --tag simplepieng/base:$(PHP_CURR) --file build/base/Dockerfile-$(PHP_CURR) .

.PHONY: base-74
base-74:
	$(BUILD_DOCKER) --tag simplepieng/base:$(PHP_NEXT) --file build/base/Dockerfile-$(PHP_NEXT) .

.PHONY: base-all
base-all: base-72 base-73 base-74

#-------------------------------------------------------------------------------
# Build all development focused containers.

.PHONY: build-all
build-all:
	$(BUILD_COMPOSE)

.PHONY: build-72
build-72:
	$(BUILD_COMPOSE) $(COMPOSE_72)

.PHONY: build-73
build-73:
	$(BUILD_COMPOSE) $(COMPOSE_73)

.PHONY: build-74
build-74:
	$(BUILD_COMPOSE) $(COMPOSE_74)

.PHONY: build-test
build-test:
	$(BUILD_COMPOSE) tests-72 tests-73 tests-74

.PHONY: build-coverage
build-coverage:
	$(BUILD_COMPOSE) coverage-72 coverage-73

#-------------------------------------------------------------------------------
# Clean Docker containers

.PHONY: dockerfile
dockerfile:
	find $$(pwd)/build -type f -name Dockerfile-$(PHP_LAST)* -not -path "*build/base*" | xargs -P $$(nproc) -I% bash -c 'sed -i -r "s/^FROM simplepieng\/base:([^\s]+)/FROM simplepieng\/base:$(PHP_LAST)/" %'
	find $$(pwd)/build -type f -name Dockerfile-$(PHP_LAST)* -not -path "*build/base*" | xargs -P $$(nproc) -I% bash -c 'sed -i -r "s/^ENV PHP_EXT_DATE ([^\s]+)/ENV PHP_EXT_DATE $(PHP_LAST_EXT_DATE)/" %'

	find $$(pwd)/build -type f -name Dockerfile-$(PHP_LAST)* -not -path "*build/base*" | xargs -P $$(nproc) -I% bash -c 'cp -fv % $$(echo % | sed -r "s/$(PHP_LAST)/$(PHP_CURR)/g")'
	find $$(pwd)/build -type f -name Dockerfile-$(PHP_CURR)* -not -path "*build/base*" | xargs -P $$(nproc) -I% bash -c 'sed -i -r "s/^FROM simplepieng\/base:$(PHP_LAST)/FROM simplepieng\/base:$(PHP_CURR)/" %'
	find $$(pwd)/build -type f -name Dockerfile-$(PHP_CURR)* -not -path "*build/base*" | xargs -P $$(nproc) -I% bash -c 'sed -i -r "s/^ENV PHP_EXT_DATE ([^\s]+)/ENV PHP_EXT_DATE $(PHP_CURR_EXT_DATE)/" %'

	find $$(pwd)/build -type f -name Dockerfile-$(PHP_CURR)* -not -path "*build/base*" | xargs -P $$(nproc) -I% bash -c 'cp -fv % $$(echo % | sed -r "s/$(PHP_CURR)/$(PHP_NEXT)/g")'
	find $$(pwd)/build -type f -name Dockerfile-$(PHP_NEXT)* -not -path "*build/base*" | xargs -P $$(nproc) -I% bash -c 'sed -i -r "s/^FROM simplepieng\/base:$(PHP_CURR)/FROM simplepieng\/base:$(PHP_NEXT)/" %'
	find $$(pwd)/build -type f -name Dockerfile-$(PHP_NEXT)* -not -path "*build/base*" | xargs -P $$(nproc) -I% bash -c 'sed -i -r "s/^ENV PHP_EXT_DATE ([^\s]+)/ENV PHP_EXT_DATE $(PHP_NEXT_EXT_DATE)/" %'

.PHONY: push-images
push-images:
	docker push simplepieng/base:$(PHP_LAST)
	docker push simplepieng/base:$(PHP_CURR)
	docker push simplepieng/base:$(PHP_NEXT)

	docker push simplepieng/test-runner:$(PHP_LAST)
	docker push simplepieng/test-runner:$(PHP_CURR)
	docker push simplepieng/test-runner:$(PHP_NEXT)

	docker push simplepieng/test-coverage:$(PHP_LAST)
	docker push simplepieng/test-coverage:$(PHP_CURR)
	# docker push simplepieng/test-coverage:$(PHP_NEXT)

.PHONY: clean-72
clean-72:
	docker image rm --force $(IMAGES_72)

.PHONY: clean-73
clean-73:
	docker image rm --force $(IMAGES_73)

.PHONY: clean-74
clean-74:
	docker image rm --force $(IMAGES_74)

.PHONY: clean-all
clean-all: clean-72 clean-73 clean-74

.PHONY: rmint
rmint:
	# Remove the intermediate Docker containers. All Docker image builds will start over from scratch.
	docker images | grep "<none>" | awk '{print $$3}' | xargs -P 2 -I% docker rmi -f %

#-------------------------------------------------------------------------------
# Git Tasks

.PHONY: tag
tag:
	@ if [ $$(git status -s -uall | wc -l) != 1 ]; then echo 'ERROR: Git workspace must be clean.'; exit 1; fi;

	@echo "This release will be tagged as: $$(cat ./VERSION)"
	@echo "This version should match your release. If it doesn't, re-run 'make version'."
	@echo "---------------------------------------------------------------------"
	@read -p "Press any key to continue, or press Control+C to cancel. " x;

	@echo " "
	@chag update $$(cat ./VERSION)
	@echo " "

	@echo "These are the contents of the CHANGELOG for this release. Are these correct?"
	@echo "---------------------------------------------------------------------"
	@chag contents
	@echo "---------------------------------------------------------------------"
	@echo "Are these release notes correct? If not, cancel and update CHANGELOG.md."
	@read -p "Press any key to continue, or press Control+C to cancel. " x;

	@echo " "

	git add .
	git commit -a -m "Preparing the $$(cat ./VERSION) release."
	chag tag --sign

.PHONY: version
version:
	@echo "Current version: $$(cat ./VERSION)"
	@read -p "Enter new version number: " nv; \
	printf "$$nv" > ./VERSION

