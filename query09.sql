WITH mey AS (
    SELECT *
    FROM phl.pwd_parcels
    WHERE address = '220-30 S 34TH ST'
),

bg AS (
    SELECT *
    FROM census.blockgroups_2020
    WHERE statefp = '42' AND countyfp = '101' -- Pennsylvania state code and Philadelphia county code
)

SELECT bg.geoid::text AS geo_id
FROM mey, bg
WHERE ST_INTERSECTS(
    ST_TRANSFORM(CAST(mey.geog AS geometry), 32129),
    ST_TRANSFORM(CAST(bg.geog AS geometry), 32129)
)
LIMIT 1;