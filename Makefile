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

# Run tests (placeholder for future test implementation)
test:
	@echo "Running tests..."
	@echo "Tests not implemented yet"

# Check for security issues
security-check:
	@echo "Running security checks..."
	@if command -v tflint >/dev/null 2>&1; then \
		tflint; \
	else \
		echo "tflint not installed. Install with: go install github.com/terraform-linters/tflint/cmd/tflint@latest"; \
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