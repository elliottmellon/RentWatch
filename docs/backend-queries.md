# Backend queries

The tested SQL behind every endpoint in `api-contract.md`. Copy it into the repositories; no need to write SQL from scratch.

Follows the course pattern: one repository per table, built on `BaseRepository` (`GetData`, `InsertData`, `UpdateData`, `DeleteData`). Every value goes in as an `@` parameter, never pasted into the SQL text. That is what protects the app against SQL injection.

```csharp
cmd.CommandText = "DELETE FROM listing WHERE id = @id";
cmd.Parameters.AddWithValue("@id", id);
```

Columns come back in snake_case (`max_rent`); the C# model properties use PascalCase (`MaxRent`) and ASP.NET turns them into camelCase JSON (`maxRent`).

## ListingRepository

**GetListings**: `GET /api/Listing`

```sql
SELECT l.id, l.provider_id, p.name AS provider_name, l.address, l.area,
       l.rent, l.rooms, l.size_m2, l.status, l.external_id, l.url, l.posted_at
FROM listing l
JOIN provider p ON p.id = l.provider_id
ORDER BY l.posted_at DESC;
```

**GetListingById**: `GET /api/Listing/{id}`

```sql
SELECT l.id, l.provider_id, p.name AS provider_name, l.address, l.area,
       l.rent, l.rooms, l.size_m2, l.status, l.external_id, l.url, l.posted_at
FROM listing l
JOIN provider p ON p.id = l.provider_id
WHERE l.id = @id;
```

**InsertListing**: `POST /api/Listing`

Listings added by hand get an `external_id` starting with `manual-`, so they never clash with scraped ones.

```sql
INSERT INTO listing (provider_id, external_id, address, area, rent, rooms, size_m2, status, url)
VALUES (@providerId, 'manual-' || gen_random_uuid(), @address, @area, @rent, @rooms, @sizeM2, @status, @url);
```

**UpdateListing**: `PUT /api/Listing`

```sql
UPDATE listing
SET provider_id = @providerId, address = @address, area = @area, rent = @rent,
    rooms = @rooms, size_m2 = @sizeM2, status = @status, url = @url
WHERE id = @id;
```

**DeleteListing**: `DELETE /api/Listing/{id}`

```sql
DELETE FROM listing WHERE id = @id;
```

## WatchProfileRepository

**GetWatchProfiles**: `GET /api/WatchProfile`

```sql
SELECT wp.id, wp.user_id, wp.provider_id, p.name AS provider_name,
       wp.area, wp.max_rent, wp.min_rooms
FROM watch_profile wp
JOIN provider p ON p.id = wp.provider_id
ORDER BY wp.id;
```

**GetWatchProfilesByUser**: `GET /api/WatchProfile/user/{userId}`

```sql
SELECT wp.id, wp.user_id, wp.provider_id, p.name AS provider_name,
       wp.area, wp.max_rent, wp.min_rooms
FROM watch_profile wp
JOIN provider p ON p.id = wp.provider_id
WHERE wp.user_id = @userId
ORDER BY wp.id;
```

**GetWatchProfileById**: `GET /api/WatchProfile/{id}`

```sql
SELECT wp.id, wp.user_id, wp.provider_id, p.name AS provider_name,
       wp.area, wp.max_rent, wp.min_rooms
FROM watch_profile wp
JOIN provider p ON p.id = wp.provider_id
WHERE wp.id = @id;
```

**InsertWatchProfile**: `POST /api/WatchProfile`

```sql
INSERT INTO watch_profile (user_id, provider_id, area, max_rent, min_rooms)
VALUES (@userId, @providerId, @area, @maxRent, @minRooms);
```

**UpdateWatchProfile**: `PUT /api/WatchProfile`

```sql
UPDATE watch_profile
SET user_id = @userId, provider_id = @providerId, area = @area,
    max_rent = @maxRent, min_rooms = @minRooms
WHERE id = @id;
```

**DeleteWatchProfile**: `DELETE /api/WatchProfile/{id}`

```sql
DELETE FROM watch_profile WHERE id = @id;
```

## MatchRepository

**GetMatchesByUser**: `GET /api/Match/user/{userId}`

Reads the `match_candidate` view, which works out the matches on every call.

```sql
SELECT watch_profile_id, user_id, listing_id, address, area, rent, rooms, url
FROM match_candidate
WHERE user_id = @userId
ORDER BY rent;
```

## ProviderRepository

**GetProviders**: `GET /api/Provider`

```sql
SELECT id, name, base_url FROM provider ORDER BY name;
```

## AppUserRepository

**GetAppUsers**: `GET /api/AppUser`

```sql
SELECT id, name, email FROM app_user ORDER BY name;
```

## Scraper

The scraper saves listings with `database/save_listing.sql`. The API does not use it.
