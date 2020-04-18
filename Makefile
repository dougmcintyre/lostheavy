PASS_GEN = $(shell export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
PATH_PASSWORDS = "secrets/passwords"

build: secrets
	@echo "Build..."
	@docker network create lostheavy-network
	@docker build --tag lostheavy-db:12 ./docker-images/lostheavy-db
	@docker run -d --name lostheavy-db --net lostheavy-network -e POSTGRES_DB=keycloak -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) lostheavy-db:12

secrets: clean
	$(shell mkdir secrets)

	@echo "Generating secrets"
	$(eval KEYCLOAK_PASSWORD := $(PASS_GEN))
	$(eval MAIL_PASSWORD := $(PASS_GEN))
	$(eval POSTGRES_PASSWORD := $(PASS_GEN))

	@echo "Storing secrets"
	$(shell echo "export KEYCLOAK_PASSWORD=$(KEYCLOAK_PASSWORD)" >> $(PATH_PASSWORDS))
	$(shell echo "export MAIL_PASSWORD=$(MAIL_PASSWORD)" >> $(PATH_PASSWORDS))
	$(shell echo "export POSTGRES_PASSWORD=$(POSTGRES_PASSWORD)" >> $(PATH_PASSWORDS))

	@echo "Securing secrets"
	$(shell chmod 400 $(PATH_PASSWORDS))

clean:
	@echo "Purging secrets"
	@rm -fr secrets

	@echo "Stoping containers"
	@docker container stop lostheavy-db 2>/dev/null; true

	@echo "Purging containers"
	@docker container rm lostheavy-db 2>/dev/null; true

	@echo "Purging images"
	@docker image rm lostheavy-db 2>/dev/null; true

	@echo "Puring networks"
	@docker network rm lostheavy-network 2>/dev/null; true

	@echo "Finished clean."
