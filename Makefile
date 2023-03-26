clean:
	@rm -rf ./telegram/build/dev

start-tg-dev:
	@cd ./telegram && air

build-tg-dev: clean
	@GOOS=linux GOARCH=amd64 go build -v -a -o ./telegram/build/dev/bin/app ./telegram

build-plan-tg-dev: build-tg-dev tg-plan-dev

tg-init:
	@cd ./infra && terraform init

tg-init-dev:
	@cd ./infra && terraform workspace new dev && \
		terraform init

tg-plan-dev:
	@cd ./infra && terraform plan -var-file=dev.tfvars -out=tfplan

tg-apply-dev:
	@cd ./infra && terraform apply --auto-approve "tfplan"
	@make tg-post-deploy

tg-post-deploy:
	@go run ./deploy -w="`terraform -chdir=infra output -raw telegram_bot_api_url`" \
		-t="`terraform -chdir=infra output -raw telegram_bot_token`"