/*

This file contains the SQL commands to prepare the database for your queries.
Before running this file, you should have created your database, created the
schemas (see below), and loaded your data into the database.

Creating your schemas
---------------------

You can create your schemas by running the following statements in PG Admin:

    create schema if not exists septa;
    create schema if not exists phl;
    create schema if not exists census;

Also, don't forget to enable PostGIS on your database:

    create extension if not exists postgis;

Loading your data
-----------------

After you've created the schemas, load your data into the database specified in
the assignment README.

Finally, you can run this file either by copying it all into PG Admin, or by
running the following command from the command line:

    psql -U postgres -d <YOUR_DATABASE_NAME> -f db_structure.sql

*/

-- Add a column to the septa.bus_stops table to store the geometry of each stop.
alter table septa.bus_stops
add column if not exists geog geography;

update septa.bus_stops
set geog = st_makepoint(stop_lon, stop_lat)::geography;

-- Create an index on the geog column.
create index if not exists septa_bus_stops__geog__idx
on septa.bus_stops using gist(geog);

-- Create a new column in census.population_2020 to remove "1500000US" string from geoid
alter table census.population_2020 add column id text;
update census.population_2020 set id = replace(geoid, '1500000US', '');
alter table census.population_2020 drop column geoid;
alter table census.population_2020 rename column id to geoid;

-- Update geogprahy column to 4326 in census.blockgroups_2020
alter table census.blockgroups_2020 add column newgeog geography(geometry, 4326);
update census.blockgroups_2020 set newgeog = st_transform(geog::geometry, 4326)::geography;
alter table census.blockgroups_2020 drop column geog;
alter table census.blockgroups_2020 rename column newgeog to geog;

-- Update geogprahy column to 4326 in phl.pwd_parcels
alter table phl.pwd_parcels add column newgeog geography(geometry, 4326);
update phl.pwd_parcels set newgeog = st_transform(geog::geometry, 4326)::geography;
alter table phl.pwd_parcels drop column geog;
alter table phl.pwd_parcels rename column newgeog to geog;

-- Create an index for septa.bus_stops
create index if not exists septa_bus_stops__geog__idx
on septa.bus_stops using gist(geog);

-- Create geography column for septa.rail_stops
--ALTER TABLE septa.rail_stops
--ADD COLUMN geog geography(Point, 4326);
--UPDATE septa.rail_stops
--SET geog = ST_SetSRID(ST_MakePoint(stop_lon, stop_lat), 4326);
