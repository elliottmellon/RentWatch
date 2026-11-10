-- RentWatch database schema
-- Rerunnable: drops the view and all tables first, then recreates them.

DROP VIEW IF EXISTS match_candidate;
DROP TABLE IF EXISTS match;
DROP TABLE IF EXISTS watch_profile;
DROP TABLE IF EXISTS listing;
DROP TABLE IF EXISTS provider;
DROP TABLE IF EXISTS app_user;

CREATE TABLE app_user (
    id    SERIAL PRIMARY KEY,
    name  TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);

CREATE TABLE provider (
    id       SERIAL PRIMARY KEY,
    name     TEXT NOT NULL,
    base_url TEXT NOT NULL
);

CREATE TABLE listing (
    id          SERIAL PRIMARY KEY,
    provider_id INTEGER NOT NULL REFERENCES provider (id),
    address     TEXT NOT NULL,
    area        TEXT NOT NULL,
    rent        INTEGER NOT NULL CHECK (rent > 0),
    rooms       INTEGER NOT NULL CHECK (rooms BETWEEN 1 AND 6),
    size_m2     INTEGER CHECK (size_m2 > 0),
    status      TEXT NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'reserved', 'rented')),
    external_id TEXT NOT NULL,  -- the provider's own id for the listing, e.g. Kereby's card id
    url         TEXT,           -- link to the listing page; rented listings often have none
    posted_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (provider_id, external_id)
);

CREATE TABLE watch_profile (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER NOT NULL REFERENCES app_user (id) ON DELETE CASCADE,
    provider_id INTEGER NOT NULL REFERENCES provider (id),
    area        TEXT NOT NULL,
    max_rent    INTEGER NOT NULL CHECK (max_rent > 0),
    min_rooms   INTEGER NOT NULL CHECK (min_rooms BETWEEN 1 AND 6)
);

CREATE TABLE match (
    id               SERIAL PRIMARY KEY,
    listing_id       INTEGER NOT NULL REFERENCES listing (id) ON DELETE CASCADE,
    watch_profile_id INTEGER NOT NULL REFERENCES watch_profile (id) ON DELETE CASCADE,
    status           TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'seen', 'applied')),
    UNIQUE (listing_id, watch_profile_id)
);

-- Every available listing that fits a watch profile.
-- A listing fits when it comes from the profile's provider, is in the
-- profile's area, costs no more than max_rent and has at least min_rooms.
CREATE VIEW match_candidate AS
SELECT
    wp.id      AS watch_profile_id,
    wp.user_id,
    l.id       AS listing_id,
    l.address,
    l.area,
    l.rent,
    l.rooms,
    l.url
FROM watch_profile wp
JOIN listing l
    ON  l.provider_id = wp.provider_id
    AND l.area        = wp.area
    AND l.rent       <= wp.max_rent
    AND l.rooms      >= wp.min_rooms
WHERE l.status = 'available';
