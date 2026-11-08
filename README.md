# RentWatch

RentWatch lets students save rental search alerts and track matching Copenhagen listings.

## Folders

| Folder      | What it holds                         | Owner   |
|-------------|---------------------------------------|---------|
| `database/` | `schema.sql` (tables), `seed.sql` (test data) | Elliott |
| `backend/`  | C# Web API (Npgsql)                   | TBD     |
| `frontend/` | Angular app                           | TBD     |
| `docs/`     | Report material, diagrams             | All     |

## Run it on a fresh laptop

You need git, PostgreSQL, the .NET SDK and Node with the Angular CLI.

```bash
# 1. Clone
git clone https://github.com/elliottmellon/rentwatch.git
cd rentwatch

# 2. Create the database
createdb rentwatch

# 3. Create tables, then add test data
psql -d rentwatch -f database/schema.sql
psql -d rentwatch -f database/seed.sql

# 4. Start the API (once the backend exists)
cd backend && dotnet run

# 5. Start Angular (once the frontend exists, in a new terminal)
cd frontend && npm install && ng serve
```

Put your database password in `backend/**/appsettings.Development.json`. Git ignores that file, so it never gets committed.

## Team rules

- `main` always runs.
- Work on a branch named after the part and task, e.g. `db/schema`, `api/listings`, `ui/watch-form`.
- Open a pull request when done. One teammate approves before merging.
