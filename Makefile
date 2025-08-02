# Makefile for AWS Security Group Terraform Module

.PHONY: help init plan apply destroy validate fmt clean test

# Default target
help:
	@echo "Available targets:"
	@echo "  init      - Initialize Terraform"
	@echo "  plan      - Plan Terraform changes"
	@echo "  apply     - Apply Terraform changes"
	@echo "  destroy   - Destroy Terraform resources"
	@echo "  validate  - Validate Terraform configuration"
	@echo "  fmt       - Format Terraform code"
	@echo "  clean     - Clean up Terraform files"
	@echo "  test      - Run tests"

# Initialize Terraform
init:
	terraform init

# Plan Terraform changes
plan:
	terraform plan

# Apply Terraform changes
apply:
	terraform apply -auto-approve

# Destroy Terraform resources
destroy:
	terraform destroy -auto-approve

# Validate Terraform configuration
validate:
	terraform validate

# Format Terraform code
fmt:
	terraform fmt -recursive

# Clean up Terraform files
clean:
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate
	rm -f terraform.tfstate.backup

# Run tests
test:
	@echo "Running Terraform tests..."
	@if [ -f "test/main.tf" ]; then \
		cd test && terraform init && terraform plan; \
	else \
		echo "No test configuration found"; \
	fi

# Run integration tests
test-integration:
	@echo "Running integration tests..."
	@cd examples/basic && terraform init && terraform plan
	@cd examples/advanced && terraform init && terraform plan

# Check for security issues
security-check:
	@echo "Running security checks..."
	@if command -v tflint >/dev/null 2>&1; then \
		tflint; \
	else \
		echo "tflint not installed. Install with: go install github.com/terraform-linters/tflint/cmd/tflint@latest"; \
	fi
	@if command -v tfsec >/dev/null 2>&1; then \
		tfsec .; \
	else \
		echo "tfsec not installed. Install with: go install github.com/aquasecurity/tfsec/cmd/tfsec@latest"; \
	fi
	@if command -v checkov >/dev/null 2>&1; then \
		checkov -d .; \
	else \
		echo "checkov not installed. Install with: pip install checkov"; \
	fi

# Run all checks
check: validate fmt security-check
	@echo "All checks completed"

# Example-specific targets
example-basic:
	cd examples/basic && terraform init && terraform plan

example-advanced:
	cd examples/advanced && terraform init && terraform plan

# Documentation
docs:
	@echo "Generating documentation..."
	@if command -v terraform-docs >/dev/null 2>&1; then \
		terraform-docs markdown table . > README.md; \
	else \
		echo "terraform-docs not installed. Install with: go install github.com/terraform-docs/terraform-docs/cmd/terraform-docs@latest"; \
	fi 