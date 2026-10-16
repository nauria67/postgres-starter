# Trial Management Service: database setup

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
| User     | `trials`    |
| Password | `trials`    |
| Database | `trials`    |

Connection string: `postgres://trials:trials@localhost:5432/trials`

## Create your schema with a migration

The database starts empty. Creating the schema is part of the exercise, and it must be done through a migration that you write.

1. Add a SQL file to the `migrations/` folder, for example `migrations/001_init.sql`, containing your tables, constraints and indexes.
2. Apply it:

   ```
   docker compose run --rm migrate
   ```

3. Start your server only after the migration has run.

Each file is applied once, in filename order, inside a transaction. If a file has an error, nothing from that file is kept and the command reports the error. Applied files are recorded and not run again, so to change the schema after applying, add a new file such as `002_...sql` instead of editing an applied one.

## Useful commands

```
docker compose exec db psql -U trials -d trials   # open a SQL shell
docker compose down -v                            # stop and wipe all data for a clean start
docker compose down                               # stop, keep the data
```

After `down -v`, run `docker compose up -d db` and then `docker compose run --rm migrate` again to rebuild the schema from your files.
