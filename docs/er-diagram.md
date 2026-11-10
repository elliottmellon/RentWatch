# RentWatch E-R diagram

Matches `database/schema.sql`. `er-diagram.png` is the same diagram as an image for the report.

```mermaid
erDiagram
    app_user ||--o{ watch_profile : "creates"
    provider ||--o{ watch_profile : "is watched in"
    provider ||--o{ listing : "publishes"
    listing ||--o{ match : "appears in"
    watch_profile ||--o{ match : "finds"

    app_user {
        int id PK
        text name
        text email UK
    }
    provider {
        int id PK
        text name
        text base_url
    }
    listing {
        int id PK
        int provider_id FK
        text address
        text area
        int rent
        int rooms
        int size_m2
        text status
        text external_id
        text url
        timestamp posted_at
    }
    watch_profile {
        int id PK
        int user_id FK
        int provider_id FK
        text area
        int max_rent
        int min_rooms
    }
    match {
        int id PK
        int listing_id FK
        int watch_profile_id FK
        text status
    }
```

## Relationships

| From | To | Type | On delete |
|---|---|---|---|
| app_user | watch_profile | One user has many watch profiles | Deleting a user deletes their profiles |
| provider | listing | One provider has many listings | Blocked while listings exist |
| provider | watch_profile | One provider is watched by many profiles | Blocked while profiles exist |
| listing | match | One listing can match many profiles | Deleting a listing deletes its matches |
| watch_profile | match | One profile can have many matches | Deleting a profile deletes its matches |

`match` links `listing` and `watch_profile` many-to-many. A listing and profile pair can only match once.

## Rules enforced by the database

- `app_user.email` is unique.
- `listing`: rent > 0, rooms 1 to 6, size_m2 > 0, status is available, reserved or rented, and `external_id` is unique per provider.
- `watch_profile`: max_rent > 0, min_rooms 1 to 6.
- `match.status` is new, seen or applied, and defaults to new.
