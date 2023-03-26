# Assignment 02

**Due: 29 March 2023**

This assignment will work a bit differently than assignment #1. To complete this assigment you will need to do the following:
1.  Fork this repository to your own account.
2.  Clone your fork to your local machine.
3.  Complete the assignment according to the instructions below.
4.  Push your changes to your fork.
5.  Submit a pull request to the original repository. Opening your pull request will be equivalent to you submitting your assignment. You will only need to open one pull request for this assignment. **If you make additional changes to your fork, they will automatically show up in the pull request you already opened.** Your pull request should have your name in the title (e.g. `Assignment 02 - Mjumbe Poe`).

----------------

## Instructions

Write a query to answer each of the questions below.
* Your queries should produce results in the format specified by each question.
* Write your query in a SQL file corresponding to the question number (e.g. a file named _query06.sql_ for the answer to question #6).
* Each SQL file should contain a single query that retrieves data from the database (i.e. a `SELECT` query).
* Any SQL that does things other than retrieve data (e.g. SQL that creates indexes or update columns) should be in the _db_structure.sql_ file.
* Some questions include a request for you to discuss your methods. Update this README file with your answers in the appropriate place.

There are several datasets that are prescribed for you to use in this part. Your datasets tables be named:
*   `septa.bus_stops` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases) -- Use the file for February 26, 2023)
    *   In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE septa.bus_stops (
            stop_id TEXT,
            stop_name TEXT,
            stop_lat DOUBLE PRECISION,
            stop_lon DOUBLE PRECISION,
            location_type TEXT,
            parent_station TEXT,
            zone_id TEXT,
            wheelchair_boarding INTEGER
        );
        ```
*   `septa.bus_routes` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases))
    *   In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE septa.bus_routes (
            route_id TEXT,
            route_short_name TEXT,
            route_long_name TEXT,
            route_type TEXT,
            route_color TEXT,
            route_text_color TEXT,
            route_url TEXT
        );
        ```
*   `septa.bus_trips` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases))
    *  In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE septa.bus_trips (
            route_id TEXT,
            service_id TEXT,
            trip_id TEXT,
            trip_headsign TEXT,
            block_id TEXT,
            direction_id TEXT,
            shape_id TEXT
        );
        ```
*   `septa.bus_shapes` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases))
    *   In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE septa.bus_shapes (
            shape_id TEXT,
            shape_pt_lat DOUBLE PRECISION,
            shape_pt_lon DOUBLE PRECISION,
            shape_pt_sequence INTEGER
        );
        ```
*   `septa.rail_stops` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases))
    *   In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE septa.rail_stops (
            stop_id TEXT,
            stop_name TEXT,
            stop_desc TEXT,
            stop_lat DOUBLE PRECISION,
            stop_lon DOUBLE PRECISION,
            zone_id TEXT,
            stop_url TEXT
        );
        ```
*   `phl.pwd_parcels` ([OpenDataPhilly](https://opendataphilly.org/dataset/pwd-stormwater-billing-parcels))
    *   In the tests, this data will be loaded in with a geography column named `geog`, and all field names will be lowercased. If you use `ogr2ogr` to load the file, I recommend you use the following options:
        ```bash
        ogr2ogr \
            -f "PostgreSQL" \
            PG:"host=localhost port=$PGPORT dbname=$PGNAME user=$PGUSER password=$PGPASS" \
            -nln phl.pwd_parcels \
            -nlt MULTIPOLYGON \
            -t_srs EPSG:4326 \
            -lco GEOMETRY_NAME=geog \
            -lco GEOM_TYPE=GEOGRAPHY \
            -overwrite \
            "${DATA_DIR}/phl_pwd_parcels/PWD_PARCELS.shp"
        ```
        _(remember to replace the variables with the appropriate values, and replace the backslashes (`\`) with backticks (`` ` ``) if you're using PowerShell)_
*   `azavea.neighborhoods` ([Azavea's GitHub](https://github.com/azavea/geo-data/tree/master/Neighborhoods_Philadelphia))
    * In the tests, this data will be loaded in with a geography column named `geog`, and all field names will be lowercased. If you use `ogr2ogr` to load the file, I recommend you use the following options:
        ```bash
        ogr2ogr \
            -f "PostgreSQL" \
            PG:"host=localhost port=$PGPORT dbname=$PGNAME user=$PGUSER password=$PGPASS" \
            -nln azavea.neighborhoods \
            -nlt MULTIPOLYGON \
            -lco GEOMETRY_NAME=geog \
            -lco GEOM_TYPE=GEOGRAPHY \
            -overwrite \
            "${DATA_DIR}/Neighborhoods_Philadelphia.geojson"
        ```
        _(remember to replace the variables with the appropriate values, and replace the backslashes (`\`) with backticks (`` ` ``) if you're using PowerShell)_
*   `census.blockgroups_2020` ([Census TIGER FTP](https://www2.census.gov/geo/tiger/TIGER2020/BG/) -- Each state has it's own file; Use file number `42` for PA)
    *   In the tests, this data will be loaded in with a geography column named `geog`, and all field names will be lowercased. If you use `ogr2ogr` to load the file, I recommend you use the following options:
        ```bash
        ogr2ogr \
            -f "PostgreSQL" \
            PG:"host=localhost port=$PGPORT dbname=$PGNAME user=$PGUSER password=$PGPASS" \
            -nln census.blockgroups_2020 \
            -nlt MULTIPOLYGON \
            -lco GEOMETRY_NAME=geog \
            -lco GEOM_TYPE=GEOGRAPHY \
            -overwrite \
            "$DATADIR/census_blockgroups_2020/tl_2020_42_bg.shp"
        ```
        _(remember to replace the variables with the appropriate values, and replace the backslashes (`\`) with backticks (`` ` ``) if you're using PowerShell)_
  *   `census.population_2020` ([Census Explorer](https://data.census.gov/table?t=Populations+and+People&g=0500000US42101$1500000&y=2020&d=DEC+Redistricting+Data+(PL+94-171)&tid=DECENNIALPL2020.P1))  
      * In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE census.population_2020 (
            geoid TEXT,
            geoname TEXT,
            total INTEGER
        );
        ```
      * Note that the file from the Census Explorer will have more fields than those three. You may have to do some data preprocessing to get the data into the correct format.

**Note, when tests aren't passing, I do take logic for solving problems into account _for partial credit_ when grading. When in doubt, write your thinking for solving the problem even if you aren't able to get a full response.**

## Questions

1.  Which **eight** bus stop have the largest population within 800 meters? As a rough estimation, consider any block group that intersects the buffer as being part of the 800 meter buffer.

| stop_name | estimated_pop_800m | geog |
| --- | --- | --- |
| Lombard St & 18th St | 57936 | 0101000020E610000044A51133FBCA52C01B2FDD2406F94340 |
| Rittenhouse Sq & 18th St | 57571 | 0101000020E61000003C2F151BF3CA52C07E74EACA67F94340 |
| Snyder Av & 9th St | 57412 | 0101000020E61000001E1840F850CA52C0BE50C07630F64340 |
| 19th St & Lombard St | 57019 | 0101000020E6100000D68C0C7217CB52C0DBF813950DF94340 |
| Lombard St & 19th St | 57019 | 0101000020E61000004968CBB914CB52C0E2E995B20CF94340 |
| Locust St & 16th St | 56309 | 0101000020E6100000E068C70DBFCA52C00B992B836AF94340 |
| 16th St & Locust St | 56309 | 0101000020E6100000B2666490BBCA52C0410E4A9869F94340 |
| South St & 19th St | 55789 | 0101000020E61000005DA626C11BCB52C065A54929E8F84340 |


2.  Which **eight** bus stops have the smallest population above 500 people _inside of Philadelphia_ within 800 meters of the stop (Philadelphia county block groups have a geoid prefix of `42101` -- that's `42` for the state of PA, and `101` for Philadelphia county)?

| stop_name | estimated_pop_800m | geog |
| --- | --- | --- |
| Delaware Av & Venango St | 593 | 0101000020E6100000E0BDA3C684C552C02EE3A6069AFD4340 |
| Delaware Av & Tioga St | 593 | 0101000020E610000023A30392B0C552C0A0504F1F81FD4340 |
| Delaware Av & Castor Av | 593 | 0101000020E61000002AE3DF675CC552C07EC4AF58C3FD4340 |
| Northwestern Av & Stenton Av | 655 | 0101000020E61000006021736550CE52C05858703FE00B4440 |
| Stenton Av & Northwestern Av | 655 | 0101000020E6100000F6ECB94C4DCE52C09D9CA1B8E30B4440 |
| Bethlehem Pk & Chesney Ln | 655 | 0101000020E6100000B8E9CF7EA4CD52C0151DC9E53F0C4440 |
| Bethlehem Pk & Chesney Ln | 655 | 0101000020E6100000211E8997A7CD52C094F77134470C4440 |
| Delaware Av & Wheatsheaf Ln | 684 | 0101000020E610000072FBE59315C552C07C0A80F10CFE4340 |

3.  Using the Philadelphia Water Department Stormwater Billing Parcels dataset, pair each parcel with its closest bus stop. The final result should give the parcel address, bus stop name, and distance apart in meters. Order by distance (largest on top).

    _Your query should run in under two minutes._

    >_**HINT**: This is a [nearest neighbor](https://postgis.net/workshops/postgis-intro/knn.html) problem.

    **Structure:**
    ```sql
    (
        address text,  -- The address of the parcel
        stop_name text,  -- The name of the bus stop
        distance double precision  -- The distance apart in meters
    )
    ```

4.  Using the `bus_shapes`, `bus_routes`, and `bus_trips` tables from GTFS bus feed, find the **two** routes with the longest trips.

| route_short_name | trip_headsign | shape_geog | length |
| --- | --- | --- | --- |
| 130 | Bucks County Community College | line | 46505.40383430579 |
| 128 | Oxford Valley Mall | line | 43659.17731871104 |

5.  Rate neighborhoods by their bus stop accessibility for wheelchairs. Use Azavea's neighborhood dataset from OpenDataPhilly along with an appropriate dataset from the Septa GTFS bus feed. Use the [GTFS documentation](https://gtfs.org/reference/static/) for help. Use some creativity in the metric you devise in rating neighborhoods.

My accessibility metric assigns the following point value to each bus stop:

If wheelchair_boarding = 0 (unable to board with wheelchair), it receives 0 points (entirely inaccessible).  
If wheelchair_boarding = 1 (able to board with wheelchair), it receives 1 point (entirely accessible).  
If wheelchair_boarding = 2 (stop nearby has wheelchair boarding), it receives 0.5 point (inaccessible stop, with local accessible option).  

These values are calculated per stop within each neighborhood, and are divided by the area in sq km of each neighborhood.

There are a few limitations to this method. First, neighborhoods are not disadvantaged by inaccessibility as it does not subtract from their score, thus neighborhoods with several inaccessible stops can mediate their score by havung several accessible stops. This ultimately may result in a metric that speaks to greater network accessibility and general density of stops per areal unit of a neighborhood. Additionally, the 0.5 point metric for local accessible stops is an arbitrary measure to analyze wheelchair boarding accessibility, and does not guarantee the nearby stop with wheelchair boarding is within the neighborhood.  

6.  What are the _top five_ neighborhoods according to your accessibility metric?

| neighborhood_name | accessibility_rating | num_bus_stops_accessible | num_bus_stops_inaccessible |
| --------------- | --------------- | --------------- | --------------- |
| NEWBOLD | 86.2 | 45 | 4 |
| WASHINGTON_SQUARE | 85.9 | 72 | 3 |
| SPRING_GARDEN | 76.3 | 47 | 2 |
| HAWTHORNE | 76.0 | 30 | 0 |
| FRANCISVILLE | 74.9 | 41 | 0 |

7.  What are the _bottom five_ neighborhoods according to your accessibility metric?

| neighborhood_name | accessibility_rating | num_bus_stops_accessible | num_bus_stops_inaccessible |
| --------------- | --------------- | --------------- | --------------- |
| WEST_TORRESDALE | 1.8 | 1 | 0 |
| NAVY_YARD | 1.9 | 14 | 0 |
| AIRPORT | 2.1 | 20 | 0 |
| INDUSTRIAL | 2.7 | 29 | 2 |
| CRESTMONT_FARMS | 3.0 | 1 | 0 |

8.  With a query, find out how many census block groups Penn's main campus fully contains. Discuss which dataset you chose for defining Penn's campus.

| count_block_groups |
| ------------------ |
| 37 |

    **Structure (should be a single value):**
    ```sql
    (
        count_block_groups integer
    )
    ```

    **Discussion:**

9. With a query involving PWD parcels and census block groups, find the `geo_id` of the block group that contains Meyerson Hall. `ST_MakePoint()` and functions like that are not allowed.

    **Structure (should be a single value):**
    ```sql
    (
        geo_id text
    )
    ```

10. You're tasked with giving more contextual information to rail stops to fill the `stop_desc` field in a GTFS feed. Using any of the data sets above, PostGIS functions (e.g., `ST_Distance`, `ST_Azimuth`, etc.), and PostgreSQL string functions, build a description (alias as `stop_desc`) for each stop. Feel free to supplement with other datasets (must provide link to data used so it's reproducible), and other methods of describing the relationships. SQL's `CASE` statements may be helpful for some operations.

    **Structure:**
    ```sql
    (
        stop_id integer,
        stop_name text,
        stop_desc text,
        stop_lon double precision,
        stop_lat double precision
    )
    ```

   As an example, your `stop_desc` for a station stop may be something like "37 meters NE of 1234 Market St" (that's only an example, feel free to be creative, silly, descriptive, etc.)

   >**Tip when experimenting:** Use subqueries to limit your query to just a few rows to keep query times faster. Once your query is giving you answers you want, scale it up. E.g., instead of `FROM tablename`, use `FROM (SELECT * FROM tablename limit 10) as t`.
