# API contract

What the C# Web API offers and what the Angular app can expect back. Backend and frontend both build to this, so they can work at the same time.

Follows the course pattern: `[Route("api/[controller]")]`, so `ListingController` answers on `/api/Listing`. JSON uses camelCase (ASP.NET's default).

## Endpoints

| Method | URL | Does | Returns |
|---|---|---|---|
| GET | `/api/Listing` | All listings, newest first | `200` + list of Listing |
| GET | `/api/Listing/{id}` | One listing | `200` + Listing, or `404` |
| POST | `/api/Listing` | Add a listing by hand | `200`, or `400` |
| PUT | `/api/Listing` | Edit a listing (id in the body) | `200`, `400` or `404` |
| DELETE | `/api/Listing/{id}` | Delete a listing | `204`, or `404` |
| GET | `/api/WatchProfile` | All watch profiles | `200` + list of WatchProfile |
| GET | `/api/WatchProfile/user/{userId}` | One user's watch profiles | `200` + list of WatchProfile |
| GET | `/api/WatchProfile/{id}` | One watch profile | `200` + WatchProfile, or `404` |
| POST | `/api/WatchProfile` | Create a watch profile | `200`, or `400` |
| PUT | `/api/WatchProfile` | Edit a watch profile (id in the body) | `200`, `400` or `404` |
| DELETE | `/api/WatchProfile/{id}` | Delete a watch profile | `204`, or `404` |
| GET | `/api/Match/user/{userId}` | Listings that fit any of the user's profiles | `200` + list of Match |
| GET | `/api/Provider` | Landlords, for dropdowns | `200` + list of Provider |
| GET | `/api/AppUser` | Users, for a "who am I" picker (no login) | `200` + list of AppUser |

`Listing` and `WatchProfile` are the two entities with full CRUD, which the exam requires.

## JSON shapes

**Listing**

```json
{
  "id": 1,
  "providerId": 1,
  "providerName": "Kereby Udlejning",
  "address": "Gammel Kongevej 112, 3. tv",
  "area": "Frederiksberg",
  "rent": 12500,
  "rooms": 2,
  "sizeM2": 68,
  "status": "available",
  "externalId": "90101",
  "url": "https://kereby.dk/bolig/...",
  "postedAt": "2026-11-02T09:14:00"
}
```

- Sent on POST and PUT: `providerId`, `address`, `area`, `rent`, `rooms`, `sizeM2`, `status`, `url`, plus `id` on PUT.
- Filled in by the database, so leave them out of forms: `providerName`, `externalId`, `postedAt`.
- `sizeM2` and `url` may be `null`.

**WatchProfile**

```json
{
  "id": 1,
  "userId": 1,
  "providerId": 1,
  "providerName": "Kereby Udlejning",
  "area": "Frederiksberg",
  "maxRent": 13000,
  "minRooms": 2
}
```

- Sent on POST and PUT: `userId`, `providerId`, `area`, `maxRent`, `minRooms`, plus `id` on PUT.

**Match**

```json
{
  "watchProfileId": 1,
  "userId": 1,
  "listingId": 1,
  "address": "Gammel Kongevej 112, 3. tv",
  "area": "Frederiksberg",
  "rent": 12500,
  "rooms": 2,
  "url": "https://kereby.dk/bolig/..."
}
```

**Provider:** `{ "id": 1, "name": "Kereby Udlejning", "baseUrl": "https://kereby.dk/bolig/" }`

**AppUser:** `{ "id": 1, "name": "Maja Holm", "email": "maja.holm@example.com" }`

## Allowed values

The frontend should offer these as dropdowns, so users cannot type something the database rejects.

| Field | Allowed |
|---|---|
| `area` | Frederiksberg, Nørrebro, Østerbro, Vesterbro, Amager, Indre By, Valby, Hellerup |
| `status` | available, reserved, rented |
| `rooms`, `minRooms` | 1 to 6 |
| `rent`, `maxRent`, `sizeM2` | Above 0 |
| `providerId` | An id from `GET /api/Provider` |
| `userId` | An id from `GET /api/AppUser` |

## When the database says no

The database enforces the rules above too. When it rejects a save, Npgsql throws a `PostgresException`. The API should answer `400 Bad Request` instead of crashing:

| `SqlState` | Means | Example |
|---|---|---|
| `23514` | A check rule failed | rent of 0, 7 rooms, unknown status |
| `23503` | A foreign key points at nothing | `providerId` 99 |
| `23502` | A required field is missing | no address |
