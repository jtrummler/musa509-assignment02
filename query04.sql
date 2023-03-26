WITH shapes AS (
    SELECT
        shape_id,
        ST_MAKELINE(
            ST_MAKEPOINT(shape_pt_lon, shape_pt_lat)
            ORDER BY shape_pt_sequence
        ) AS shape_geog,
        ST_LENGTH(
            ST_MAKELINE(
                ST_MAKEPOINT(shape_pt_lon, shape_pt_lat)
                ORDER BY shape_pt_sequence
            )::geography
        ) AS shape_length
    FROM
        septa.bus_shapes
    GROUP BY
        shape_id
),

trips AS (
    SELECT
        route_id,
        trip_headsign,
        shape_id
    FROM
        septa.bus_trips
    GROUP BY
        route_id,
        trip_headsign,
        shape_id
)

SELECT
    br.route_short_name,
    bt.trip_headsign,
    s.shape_geog::geography,
    s.shape_length
FROM
    septa.bus_routes AS br
INNER JOIN
    trips AS bt
    ON
        br.route_id = bt.route_id
INNER JOIN
    shapes AS s
    ON
        bt.shape_id = s.shape_id
GROUP BY
    br.route_short_name,
    bt.trip_headsign,
    s.shape_geog::geography,
    s.shape_length
ORDER BY
    s.shape_length DESC
LIMIT
    2;
