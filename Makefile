AZURE_MODULES_PATH=modules/azure

azure_modules=$(shell find $(AZURE_MODULES_PATH) -not -path '*/\.*' -name main.tf -exec dirname {} \;)

hclfmt: ## Format hcl files
	@terragrunt hclfmt

hclfmt-check: ## Check whether hcl files are formatted
	@terragrunt hclfmt --check

fmt: $(addsuffix /fmt,$(azure_modules)) ## Format all tf files

modules/azure/%/fmt: modules/azure/%/*.tf ## Format tf files for module
	@printf "Performing terraform fmt on %s...\n" $(@D)
	@cd $(@D); terraform fmt;

fmt-check: $(addsuffix /fmt-check,$(azure_modules)) ## Format all tf files

modules/azure/%/fmt-check: modules/azure/%/*.tf ## Format tf files for module
	@printf "Check if terraform files are formatted on %s...\n" $(@D)
	@cd $(@D); terraform fmt --check;

tflint: $(addsuffix /tflint,$(azure_modules)) ## Perform tflint for all modules

modules/azure/%/tflint: modules/azure/%/*.tf
	@printf "Performing tflint on %s...\n" $(@D)
	@cd $(@D); tflint $(tflint_config) --init; tflint $(tflint_config);

detect-secrets/baseline-create:
	detect-secrets scan > .secrets.baseline

detect-secrets/baseline-update:
	detect-secrets scan --baseline .secrets.baseline

detect-secrets/scan:
	detect-secrets scan .