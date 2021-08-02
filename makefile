.SECONDEXPANSION:

export TF_CLI_CONFIG_FILE := $(CURDIR)/.terraformrc

SUBMODULES         := $(wildcard modules/*)
SUBMODULEMAKEFILES := $(foreach module,$(SUBMODULES),$(module)/makefile)
MAKESUBMODULES     := $(foreach module,$(SUBMODULES),$(module)/default)
CLEANSUBMODULES    := $(foreach module,$(SUBMODULES),$(module)/clean)
TFLINTRC           := ./.tflint.hcl
MODULEFILES        := $(wildcard *.tf)

.PHONY: default
default: modules

.PHONY: checkfmt
checkfmt: .fmt

.PHONY: fmt
fmt:
	terraform fmt -recursive

.PHONY: docs
docs: README.md

.PHONY: lint
lint: .lint

.lint: $(MODULEFILES) .lintinit
	tflint --config=$(TFLINTRC)
	@touch .lint

.lintinit: $(TFLINTRC)
	tflint --init --config=$(TFLINTRC)
	@touch .lintinit

README.md: $(MODULEFILES)
	terraform-docs markdown table . --output-file README.md

.fmt: $(MODULEFILES)
	terraform fmt -check
	@touch .fmt

.PHONY: init
init: .init

.PHONY: validate
validate: .validate
.init: versions.tf

	terraform init -backend=false
	@touch .init

.validate: .init $(MODULEFILES)
	AWS_DEFAULT_REGION=us-east-1 terraform validate
	@touch .validate

.PHONY: modules
modules: makefiles makemodules

.PHONY: makefiles
makefiles: $(SUBMODULEMAKEFILES)

$(SUBMODULEMAKEFILES): %/makefile: makefiles/terraform.mk
	cp "$<" "$@"

.PHONY: makemodules
makemodules: $(MAKESUBMODULES) checkfmt validate docs lint

$(MAKESUBMODULES): %/default: .terraformrc
	$(MAKE) -C "$*"

$(CLEANSUBMODULES): %/clean:
	$(MAKE) -C "$*" clean

.PHONY: clean
clean: $(CLEANSUBMODULES)
	rm -rf .fmt .init .lint .lintinit .terraform .validate

.terraformrc:
	mkdir -p .terraform-plugins
	echo 'plugin_cache_dir = "$(CURDIR)/.terraform-plugins"' > .terraformrc
