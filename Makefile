AZURE_MODULES_PATH=modules/azure

azure_modules=$(shell find $(AZURE_MODULES_PATH) -not -path '*/\.*' -name main.tf -exec dirname {} \;)

hclfmt: ## Format hcl files
	@terragrunt hclfmt

fmt: $(addsuffix /fmt,$(azure_modules)) ## Format tf files

modules/azure/%/fmt: modules/azure/%/*.tf
	@printf "Performing terraform fmt on %s...\n" $(@D)
	@cd $(@D); terraform fmt;
