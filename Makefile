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
