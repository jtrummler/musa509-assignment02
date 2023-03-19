SELECT
    r.route_short_name,
    t.trip_headsign,
    ST_LENGTH(ST_MAKELINE(ST_MAKEPOINT(s.shape_pt_lon, s.shape_pt_lat) ORDER BY s.shape_pt_sequence)) AS shape_length,
    ST_MAKELINE(ST_MAKEPOINT(s.shape_pt_lon, s.shape_pt_lat) ORDER BY s.shape_pt_sequence) AS shape_geog
FROM
    septa.bus_shapes AS s
JOIN
    septa.bus_trips AS t ON s.shape_id = t.shape_id
JOIN
    septa.bus_routes AS r ON t.route_id = r.route_id
GROUP BY
    r.route_short_name, t.trip_headsign
ORDER BY
    shape_length DESC
LIMIT 2;
