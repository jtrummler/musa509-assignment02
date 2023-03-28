SELECT
 s.stop_id,
 s.stop_name,
 CONCAT(ROUND(ST_DISTANCE(s.geog, p.geog)), ' meters from my apartment') AS stop_desc,
 s.stop_lon,
 s.stop_lat
FROM septa.rail_stops AS s, phl.pwd_parcels AS p
WHERE p.address = '322 S 43RD ST'
ORDER BY stop_desc DESC;
