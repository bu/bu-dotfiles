
postgres:
	docker run --detach --publish 5432:5432 --env POSTGRES_PASSWORD=ab3057c2 --network dev --name postgres postgres:alpine

pgadmin:
	docker run --detach --name pgadmin --publish 8051:80 --env PGADMIN_DEFAULT_EMAIL=bu@bu.idv.tw --network dev --env PGADMIN_DEFAULT_PASSWORD=ab3057c2 dpage/pgadmin4
