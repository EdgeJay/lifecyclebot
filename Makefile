clean:
	@rm -rf ./telegram/build/dev

start-tg-dev:
	@cd ./telegram && air

build-tg-dev: clean
	@GOOS=linux GOARCH=amd64 go build -v -a -o ./telegram/build/dev/bin/app ./telegram

build-plan-tg-dev: build-tg-dev tf-plan-dev

tf-init:
	@cd ./infra && terraform init

tf-init-dev:
	@cd ./infra && terraform workspace new dev && \
		terraform init

tf-plan-dev:
	@cd ./infra && terraform plan -var-file=dev.tfvars -out=tfplan

tf-apply-dev:
	@cd ./infra && terraform apply --auto-approve "tfplan"