docker run -d --name artisell_postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=artisell -v postgres_data:/var/lib/postgresql -p 5433:5432 postgres
docker exec -it artisell_postgres psql -U postgres -d artisell -c "CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT);"
docker exec -it artisell_postgres psql -U postgres -d artisell -c "INSERT INTO users (name) VALUES ('Frederic');"
docker stop artisell_postgres
docker rm artisell_postgres
docker run -d --name artisell_postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=artisell -v postgres_data:/var/lib/postgresql -p 5433:5432 postgres
docker exec -it artisell_postgres psql -U postgres -d artisell -c "SELECT * FROM users;"
# id |   name
#----+----------
#  1 | Frederic
#(1 row)
docker volume ls
#DRIVER    VOLUME NAME
#local     3bfffe8ae03ffe6295c02ac899638ccf9e1c55886fa1a3e11e290a3cd4761075
#local     3e32d40c04459a1f131bf6cc6966c384f41302ee13a39a73339b78313a6765b4
#local     a2db453c69564da8859a697052b21fcdff76ce0b932aebb7b0223c7c3d08e592
#local     cbc6b55da058f90b9074979b3ff934754a708a58cfda20779e3e8dcf5506e7e2
#local     cefa6c90594cecd40215df473dc7114a59fc87b5b090ade138dfa802fe8014e4
#local     postgres_data
docker volume inspect postgres_data
#[
#    {
#        "CreatedAt": "2026-08-24T14:26:12Z",
#        "Driver": "local",
#        "Labels": null,
#        "Mountpoint": "/var/lib/docker/volumes/postgres_data/_data",
#        "Name": "postgres_data",
#        "Options": null,
#        "Scope": "local"
#    }
#]
docker stop artisell_postgres
docker rm artisell_postgres
docker volume rm postgres_data
docker run -d --name artisell_postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=artisell -v postgres_data:/var/lib/postgresql -p 5433:5432 postgres
# plus de table users