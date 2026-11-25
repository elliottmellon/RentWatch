-- Save one listing from a provider. Used by the scraper.
--
-- New listing (provider_id + external_id not seen before): inserted.
-- Known listing: its details are updated, e.g. when a flat goes from
-- available to reserved or the rent changes. posted_at keeps the time
-- we first saw it.
--
-- The @names are parameters the scraper fills in with Npgsql.

INSERT INTO listing (provider_id, external_id, address, area, rent, rooms, size_m2, status, url)
VALUES (@providerId, @externalId, @address, @area, @rent, @rooms, @sizeM2, @status, @url)
ON CONFLICT (provider_id, external_id) DO UPDATE SET
    address = EXCLUDED.address,
    area    = EXCLUDED.area,
    rent    = EXCLUDED.rent,
    rooms   = EXCLUDED.rooms,
    size_m2 = EXCLUDED.size_m2,
    status  = EXCLUDED.status,
    url     = EXCLUDED.url
RETURNING id;
