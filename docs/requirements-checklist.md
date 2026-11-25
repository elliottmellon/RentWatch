# Requirements checklist

Every requirement from the Project and Exam Guide, and what in RentWatch covers it. Tick a box when it is built and merged to `main`.

## Database (PostgreSQL)

| Done | Requirement | Covered by | Owner |
|---|---|---|---|
| ✅ | Schema with several related tables | `app_user`, `provider`, `listing`, `watch_profile` | Elliott |
| ✅ | Primary keys and foreign keys | Every table has an `id` key; `listing` and `watch_profile` link to `provider` and `app_user` | Elliott |
| ✅ | At least 10 test records | `seed.sql`: 22 rows, including 13 listings | Elliott |

## Backend (C# Web API)

| Done | Requirement | Covered by | Owner |
|---|---|---|---|
| ☐ | CRUD for at least two entities | `ListingController` and `WatchProfileController` | Rose and Niklas |
| ☐ | Correct use of GET, POST, PUT, DELETE | Endpoints in `api-contract.md` | Rose and Niklas |
| ☐ | Bad data answers `400`, not a crash | Catch `PostgresException` (see `api-contract.md`) | Rose and Niklas |

## Frontend (Angular)

| Done | Requirement | Covered by | Owner |
|---|---|---|---|
| ☐ | At least four components | Suggested: `listing-list`, `listing-form`, `watch-profile-list`, `watch-profile-form`, `match-list` | Rose and Niklas |
| ☐ | Services that call the backend | `ListingService`, `WatchProfileService`, `MatchService` | Rose and Niklas |
| ☐ | A form with two-way data binding | `watch-profile-form` (`[(ngModel)]` on area, max rent, min rooms) | Rose and Niklas |
| ☐ | Basic validation on form fields | Max rent above 0, rooms 1 to 6, area and provider required (see "Allowed values" in `api-contract.md`) | Rose and Niklas |

## Scraper (our extra)

| Done | Requirement | Covered by | Owner |
|---|---|---|---|
| ☐ | Save query that inserts new and updates known listings | `database/save_listing.sql` (pull request #5) | Elliott |
| ☐ | C# console app that reads Kereby and saves listings | `scraper/` | Elliott |

## Report (max 10 pages + 5-page appendix)

| Done | Requirement | Owner |
|---|---|---|
| ☐ | Abstract, max 150 words | All |
| ☐ | Introduction: the idea | All |
| ☐ | Design choices: database | Elliott |
| ☐ | Design choices: backend | Rose and Niklas |
| ☐ | Design choices: frontend | Rose and Niklas |
| ☐ | Project management | All |
| ☐ | Testing | All |
| ☐ | At least one code snippet we are proud of, and why | All |
| ☐ | Appendix: screenshots, E-R diagram | All |

## Submission and exam

| Done | Requirement |
|---|---|
| ☐ | Zip of all code, including `schema.sql` and `seed.sql` |
| ☐ | Zip has no `node_modules`, `bin`, `obj` or other large folders (aim for 5 to 15 MB) |
| ☐ | Each of us can run the app on our own laptop and demo it |
| ☐ | Each of us can explain every part, not only our own: the oral exam is individual |
