-- RentWatch test data (fictional)
-- Rerunnable: empties all tables and resets ids before inserting.
-- Rent is in DKK per month.

TRUNCATE match, watch_profile, listing, provider, app_user RESTART IDENTITY CASCADE;

INSERT INTO provider (name, base_url) VALUES
    ('Kereby Udlejning', 'https://kereby.dk/bolig/'),       -- id 1
    ('Nordlys Bolig',    'https://nordlysbolig.example');   -- id 2

INSERT INTO app_user (name, email) VALUES
    ('Maja Holm',  'maja.holm@example.com'),    -- id 1
    ('Jonas Berg', 'jonas.berg@example.com'),   -- id 2
    ('Sofie Lind', 'sofie.lind@example.com');   -- id 3

INSERT INTO listing (provider_id, address, area, rent, rooms, size_m2, status, external_id, url, posted_at) VALUES
    (1, 'Gammel Kongevej 112, 3. tv',    'Frederiksberg', 12500, 2,  68, 'available', '90101', 'https://kereby.dk/bolig/gammel-kongevej-112-3-tv-1850-frederiksberg-c/', '2026-11-02 09:14'),  -- id 1
    (1, 'Falkoner Allé 41, 2. th',       'Frederiksberg',  9800, 1,  42, 'reserved',  '90102', 'https://kereby.dk/bolig/falkoner-alle-41-2-th-2000-frederiksberg/',       '2026-11-02 14:30'),  -- id 2
    (1, 'Howitzvej 18, 4. tv',           'Frederiksberg', 15900, 3,  96, 'rented',    '90103', NULL,                                                                       '2026-11-03 10:05'),  -- id 3
    (1, 'Jægersborggade 27, 1. th',      'Nørrebro',      11200, 2,  61, 'available', '90104', 'https://kereby.dk/bolig/jaegersborggade-27-1-th-2200-kobenhavn-n/',        '2026-11-03 16:45'),  -- id 4
    (1, 'Classensgade 9, 2. tv',         'Østerbro',      14800, 3,  92, 'available', '90105', 'https://kereby.dk/bolig/classensgade-9-2-tv-2100-kobenhavn-o/',            '2026-11-04 08:20'),  -- id 5
    (1, 'Istedgade 88, 3. th',           'Vesterbro',     10400, 2,  58, 'reserved',  '90106', 'https://kereby.dk/bolig/istedgade-88-3-th-1650-kobenhavn-v/',              '2026-11-04 11:10'),  -- id 6
    (2, 'Blågårdsgade 14, st. tv',       'Nørrebro',       8900, 1,  38, 'available', 'NB-2001', 'https://nordlysbolig.example/bolig/2001',                               '2026-11-04 13:55'),  -- id 7
    (2, 'Nørrebrogade 160, 5. th',       'Nørrebro',      13500, 3,  88, 'available', 'NB-2002', 'https://nordlysbolig.example/bolig/2002',                               '2026-11-05 09:40'),  -- id 8
    (2, 'Nordre Frihavnsgade 33, 1. tv', 'Østerbro',      12200, 2,  64, 'available', 'NB-2003', 'https://nordlysbolig.example/bolig/2003',                               '2026-11-05 15:25'),  -- id 9
    (2, 'Enghavevej 50, 4. th',          'Vesterbro',      9600, 2,  55, 'rented',    'NB-2004', NULL,                                                                     '2026-11-06 10:00'),  -- id 10
    (2, 'Amagerbrogade 205, 2. tv',      'Amager',         8700, 2,  57, 'available', 'NB-2005', 'https://nordlysbolig.example/bolig/2005',                               '2026-11-06 12:35'),  -- id 11
    (2, 'Holmbladsgade 70, 3. th',       'Amager',        11900, 3,  84, 'available', 'NB-2006', 'https://nordlysbolig.example/bolig/2006',                               '2026-11-07 09:05'),  -- id 12
    (1, 'Lergravsvej 12, 1. tv',         'Amager',         7900, 1,  40, 'rented',    '90107', NULL,                                                                       '2026-11-07 17:50');  -- id 13

INSERT INTO watch_profile (user_id, provider_id, area, max_rent, min_rooms) VALUES
    (1, 1, 'Frederiksberg', 13000, 2),   -- id 1: Maja, Kereby
    (2, 2, 'Nørrebro',      14000, 1),   -- id 2: Jonas, Nordlys
    (3, 1, 'Østerbro',      15000, 3),   -- id 3: Sofie, Kereby
    (1, 2, 'Amager',        12000, 2);   -- id 4: Maja, Nordlys

-- Every match fits its profile on provider, area, rent and rooms.
INSERT INTO match (listing_id, watch_profile_id, status) VALUES
    (1,  1, 'seen'),      -- Gammel Kongevej: 12500 <= 13000, 2 rooms
    (7,  2, 'new'),       -- Blågårdsgade: 8900 <= 14000, 1 room
    (8,  2, 'applied'),   -- Nørrebrogade: 13500 <= 14000, 3 rooms
    (5,  3, 'new'),       -- Classensgade: 14800 <= 15000, 3 rooms
    (11, 4, 'new'),       -- Amagerbrogade: 8700 <= 12000, 2 rooms
    (12, 4, 'seen');      -- Holmbladsgade: 11900 <= 12000, 3 rooms
