WITH neighborhood_areas AS (
    SELECT
        name,
        ST_AREA(geog::geography) / 1000000 AS area_sq_km
    FROM
        azavea.neighborhoods
),

stop_counts AS (
    SELECT
        nb.name AS neighborhood_name,
        SUM(CASE WHEN bs.wheelchair_boarding = 0 THEN 1 ELSE 0 END) AS zero_count,
        SUM(CASE WHEN bs.wheelchair_boarding = 1 THEN 1 ELSE 0 END) AS one_count,
        SUM(CASE WHEN bs.wheelchair_boarding = 2 THEN 1 ELSE 0 END) AS two_count,
        SUM(CASE WHEN bs.wheelchair_boarding = 0 THEN 1 ELSE 0 END) + SUM(CASE WHEN bs.wheelchair_boarding = 2 THEN 1 ELSE 0 END) AS num_bus_stops_inaccessible,
        SUM(CASE WHEN bs.wheelchair_boarding = 1 THEN 1 ELSE 0 END) AS num_bus_stops_accessible
    FROM
        septa.bus_stops AS bs
    INNER JOIN
        azavea.neighborhoods AS nb
        ON
            ST_INTERSECTS(nb.geog, bs.geog)
    GROUP BY
        nb.name
),

neighborhood_ratings AS (
    SELECT
        sc.neighborhood_name AS neighborhood_name,
        sc.num_bus_stops_inaccessible,
        sc.num_bus_stops_accessible,
        ROUND((sc.one_count::numeric * 1 + sc.two_count::numeric * 0.5) / na.area_sq_km::numeric, 1) AS accessibility_rating
    FROM
        neighborhood_areas AS na
    INNER JOIN
        stop_counts AS sc
        ON
            na.name = sc.neighborhood_name
)

SELECT
    neighborhood_name,
    accessibility_rating,
    num_bus_stops_accessible,
    num_bus_stops_inaccessible
FROM
    neighborhood_ratings
ORDER BY
    accessibility_rating DESC
LIMIT 5;
