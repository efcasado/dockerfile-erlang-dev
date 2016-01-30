###========================================================================
### File: Makefile
###
### Author(s):
###     - Enrique Fernandez <enrique.fernandez@erlang-solutions.com>
###========================================================================
.PHONY: all push $(PUSH_TARGETS) clean clean-all $(CLEAN_TARGETS)


##=========================================================================
## Settings
##=========================================================================
REGISTRY ?= efcasado


##=========================================================================
## Macros
##=========================================================================
PROJECT       := erlang-dev
DKR           := $(shell which docker)
VERSIONS      := $(basename $(notdir $(wildcard vars/*.yml)))
PUSH_TARGETS  := $(patsubst %, push-%, $(VERSIONS))
CLEAN_TARGETS := $(patsubst %, clean-%, $(VERSIONS))

##=========================================================================
## Targets
##=========================================================================
all: $(VERSIONS)

$(VERSIONS):
	mkdir -p $@
	mustache vars/$@.yml Dockerfile.in > $@/Dockerfile
	$(DKR) build -t $(PROJECT):$@ $@

push: $(PUSH_TARGETS)

push-%:
	$(DKR) tag -f $(PROJECT):$* $(REGISTRY)/$(PROJECT):$*
	$(DKR) push $(REGISTRY)/$(PROJECT):$*

clean:
	rm -rf $(VERSIONS)

clean-all: $(CLEAN_TARGETS) clean

clean-%:
	-$(DKR) rmi -f $(PROJECT)-$*
