all:
	go build .

run:
	. ./env-local.sh && ./api-demo

docker_build: main.go
	. ./env-local.sh && docker build -t go-api-demo .

docker_run: # docker_build
	. ./env-local.sh; \
		docker run -it --rm --name my-running-app -e APP_PGCONFIG=$${APP_PGCONFIG} -p "$${APP_PORT}:$${APP_PORT}" go-api-demo

compose: FORCE
	. ./env-compose.sh && docker compose up || true

FORCE: ;
