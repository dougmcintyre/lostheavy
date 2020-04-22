PASS_GEN = $(shell export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
PASS_PATH = "secrets/passwords"

build: secrets
	@echo "Build..."

	@echo "Creating lostheavy network"
	@docker network create lostheavy-network
	
	@echo "Building images"
	@docker build --tag lostheavy-db:12 ./docker-images/lostheavy-db
	
	@echo "Running containers"
	@docker run -d --name lostheavy-db --net lostheavy-network -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) lostheavy-db:12
	@docker run -d --name keycloak --net lostheavy-network -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=$(KEYCLOAK_PASSWORD) -p 8080:8080 jboss/keycloak:latest
	@docker run -d --name mailhog --net lostheavy-network -p 8025:8025 mailhog/mailhog


secrets: clean
	$(shell mkdir secrets)

	@echo "Generating secrets"
	$(eval KEYCLOAK_PASSWORD := $(PASS_GEN))
	$(eval MAIL_PASSWORD := $(PASS_GEN))
	$(eval POSTGRES_PASSWORD := $(PASS_GEN))

	@echo "Storing secrets"
	$(shell echo "KEYCLOAK_PASSWORD=$(KEYCLOAK_PASSWORD)" >> $(PASS_PATH))
	$(shell echo "MAIL_PASSWORD=$(MAIL_PASSWORD)" >> $(PASS_PATH))
	$(shell echo "POSTGRES_PASSWORD=$(POSTGRES_PASSWORD)" >> $(PASS_PATH))

	@echo "Securing secrets"
	$(shell chmod 400 $(PASS_PATH))


clean:
	@echo "Purging secrets"
	@rm -fr secrets

	@echo "Stoping containers"
	@docker container stop lostheavy-db 2>/dev/null; true
	@docker container stop keycloak 2>/dev/null; true
	@docker container stop mailhog 2>/dev/null; true
	
	@echo "Purging containers"
	@docker container rm lostheavy-db 2>/dev/null; true
	@docker container rm keycloak 2>/dev/null; true
	@docker container rm mailhog 2>/dev/null; true

	@echo "Purging images"
	@docker image rm lostheavy-db 2>/dev/null; true

	@echo "Puring networks"
	@docker network rm lostheavy-network 2>/dev/null; true
	@sleep 2
	@echo "Finished clean."
