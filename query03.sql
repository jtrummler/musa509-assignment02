SELECT
    p.address AS parcel_address,
    p.geog AS parcel_geog,
    bs.stop_name,
    bs.geog AS stop_geog,
    ST_DISTANCE(p.geog, bs.geog) AS distance
FROM
    phl.pwd_parcels AS p
CROSS JOIN LATERAL (
        SELECT
            bs.stop_name,
            bs.geog
        FROM
            septa.bus_stops AS bs
        ORDER BY
            p.geog <-> geog
        LIMIT
            1
    ) AS bs
ORDER BY
    distance DESC;
