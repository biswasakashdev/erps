
build:
	docker build --no-cache \
		--build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
 		--build-arg=FRAPPE_BRANCH=version-15 \
 		--secret=id=apps_json,src=apps.json \
		--tag=painsantanu/sterling-erp:latest \
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
	docker compose -f compose.prod.yaml exec backend bench new-site localhost \
		--mariadb-root-password 123 \
 		--mariadb-user-host-login-scope='172.%.%.%' \
		--admin-password admin

install-app:
	docker compose -f compose.prod.yaml exec backend bench --site localhost install-app erpnext

delete-vols:
	docker volume rm modified-erp_db-data modified-erp_redis-queue-data modified-erp_sites

update-erp:
	docker compose -f compose.prod.yaml cp hooks.py  frontend:/home/frappe/frappe-bench/apps/erpnext/erpnext/hooks.py
	
	docker compose -f compose.prod.yaml exec frontend rm /home/frappe/frappe-bench/assets/erpnext/images/erpnext-logo-blue.png
	
	docker compose -f compose.prod.yaml exec frontend rm /home/frappe/frappe-bench/assets/erpnext/images/erpnext-logo.svg
	
	docker compose -f compose.prod.yaml exec frontend rm /home/frappe/frappe-bench/assets/erpnext/images/erpnext-favicon.svg
	
	docker compose -f compose.prod.yaml exec frontend rm /home/frappe/frappe-bench/assets/erpnext/images/erpnext-video-placeholder.jpg
	
	docker compose -f compose.prod.yaml cp erp-logo.png frontend:/home/frappe/frappe-bench/assets/erpnext/images/erpnext-logo.png
	
	docker compose -f compose.prod.yaml cp erp-logo.png frontend:/home/frappe/frappe-bench/assets/erpnext/images/erpnext-favicon.png
	
	docker compose -f compose.prod.yaml cp erp-logo.png frontend:/home/frappe/frappe-bench/assets/erpnext/images/erpnext-logo.png
	
	docker compose -f compose.prod.yaml cp erp-logo.png frontend:/home/frappe/frappe-bench/assets/erpnext/images/erpnext-logo-blue.png

