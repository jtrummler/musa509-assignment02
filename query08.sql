SELECT COUNT(census.geoid) AS count_block_groups
FROM census.blockgroups_2020 AS census
INNER JOIN azavea.neighborhoods AS n ON n.name = 'UNIVERSITY_CITY' AND ST_INTERSECTS(n.geog, census.geog);
