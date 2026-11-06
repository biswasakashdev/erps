
build:
	docker build --no-cache \
		--build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
		--build-arg=FRAPPE_BRANCH=version-16 \
		--secret=id=apps_json,src=apps.json \
		--tag=biswasakash/sterling-erp:latest \
		--file=Dockerfile .

compose:
	docker compose --env-file build.env \
		-f compose.yaml \
		-f overrides/compose.mariadb.yaml \
		-f overrides/compose.redis.yaml \
		-f overrides/compose.noproxy.yaml \
		config > compose.prod.yaml

run:
	docker compose -f compose.prod.yaml up -d
down:
	docker compose -f compose.prod.yaml down

site-config:
	docker compose exec backend bench new-site localhost \
		--mariadb-root-password 123 \
		--admin-password admin

install-app:
	docker compose exec backend bench --site localhost install-app erpnext

