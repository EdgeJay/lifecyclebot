start-tg-dev:
	@cd ./telegram && air

tf-init:
	@cd ./infra && terraform init

tf-init-dev:
	@cd ./infra && terraform workspace new dev && \
		terraform init

tf-plan-dev:
	@cd ./infra && terraform plan -var-file=dev.tfvars -out=plan_outfile_dev

tf-apply-dev:
	@cd ./infra && terraform apply --auto-approve "plan_outfile_dev"