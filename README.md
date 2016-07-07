# References
- https://github.com/kiasaki/docker-alpine-postgres
- https://hub.docker.com/_/postgres/

# Usage

Start PostgreSQL server with database 'dbname' a database user 'auser' protected by 'secretpwd', listening on port 5432 running this command:
    
    docker run -p 5432:5432 --name appname-postgres -e POSTGRES_USER=auser POSTGRES_PASSWORD=secretpwd -e POSTGRES_DB=dbname -d alpine-postgresql

Link to other container to the PostgreSQL container you just created

    docker run --name appname-app --link appname-postgres:postgres -d application-that-uses-postgres

Your app will now be able to access POSTGRES_PORT_5432_TCP_ADDR and POSTGRES_PORT_5432_TCP_PORT environment variables.

# Commands

build:

	docker build -t alpine-postgresql --rm=true .

debug:

	docker run -i -t --entrypoint=sh alpine-postgresql

run:

    docker run -p 5432:5432 --name postgresql_instance -e POSTGRES_PASSWORD=secretpwd -i -P alpine-postgresql

# License

TODO
