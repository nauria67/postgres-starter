# Database setup

This gives you a Postgres database so you can start on the problem right away. The API and frontend are yours to build, in any language and framework. You do not need to install any migration tool.

## Start the database

You need Docker with Compose. From this folder:

```
docker compose up -d db
```

Connection details:

| Setting  | Value       |
| -------- | ----------- |
| Host     | `localhost` |
| Port     | `5432`      |
| User     | `postgres`  |
| Password | `postgres`  |
| Database | `app`       |

Connection string: `postgres://postgres:postgres@localhost:5432/app`

## Check the connection

To confirm the database is up and accepting connections with these credentials:

```
psql "postgres://postgres:postgres@localhost:5432/app" -c "select 1"
```

You should see a result table containing `1`. If you do not have `psql` installed, run the same check inside the container:

```
docker compose exec db psql -U postgres -d app -c "select 1"
```

## Create your schema with a migration

The database starts empty. Creating the schema is part of the exercise, and it must be done through a migration that you write.

1. Add a SQL file to the `migrations/` folder, for example `migrations/001_init.sql`, containing your tables, constraints and indexes.
2. Apply it:

   ```
   docker compose run --rm migrate
   ```

3. Start your server only after the migration has run.

Each file is applied once, in filename order, inside a transaction. If a file has an error, nothing from that file is kept and the command reports the error. Applied files are recorded and not run again, so to change the schema after applying, add a new file such as `002_...sql` instead of editing an applied one.

## Try SQL in the shell

Open an interactive SQL shell:

```
docker compose exec db psql -U postgres -d app
```

At the `app=#` prompt, type SQL and end every statement with a semicolon. If the prompt changes to `app-#`, psql is waiting for the rest of the statement, so type `;` and press Enter.

```
CREATE TABLE scratch (id SERIAL PRIMARY KEY, name TEXT NOT NULL);
INSERT INTO scratch (name) VALUES ('hello');
SELECT * FROM scratch;
DROP TABLE scratch;
```

To exit the shell, type `\q` and press Enter (or press `Ctrl+D` on an empty line).

Other handy shortcuts: `\dt` lists tables and `\d table_name` shows a table's columns and constraints.

Anything you run in the shell is not saved as a migration. Put your real schema in a file under `migrations/`.

## Useful commands

```
docker compose exec db psql -U postgres -d app   # open a SQL shell
docker compose down -v                            # stop and wipe all data for a clean start
docker compose down                               # stop, keep the data
```

After `down -v`, run `docker compose up -d db` and then `docker compose run --rm migrate` again to rebuild the schema from your files.