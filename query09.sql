WITH mh AS (
    SELECT *
    FROM phl.pwd_parcels
    WHERE address = '220-30 S 34TH ST'
),

bg AS (
    SELECT *
    FROM census.blockgroups_2020
    WHERE statefp = '42' AND countyfp = '101' -- Pennsylvania state code and Philadelphia county code
)

SELECT bg.geoid AS geo_id
FROM mh, bg
WHERE ST_INTERSECTS(
    ST_TRANSFORM(CAST(mh.geog AS geometry), 32129),
    ST_TRANSFORM(CAST(bg.geog AS geometry), 32129)
)
LIMIT 1;
