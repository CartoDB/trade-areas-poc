-- Poc for the Routing API focused on trade areas.
--
-- This code will have to be suffled around in order to:
--   * split server and client extension code
--   * isolate configs
--   * add quota checks and usage tracking

-- * Requirements:
--  * Add your app_id and and app_code to cdb_conf table:
--      SELECT cdb_configure_heremaps('your_app_id', 'your_app_code');
--
--  * Package and install the python library:
--      ```
--      cd lib/python/cdb
--      python setup.py sdist
--      pip install ./dist/cdb-0.0.1.tar.gz
--      ```


-- Helper to configure locally
CREATE OR REPLACE FUNCTION cdb_configure_heremaps(app_id text, app_code text)
RETURNS void AS $$
DECLARE
    conf json;
BEGIN
    conf := format('{"app_id": "%s", "app_code": "%s"}', app_id, app_code);
    PERFORM cartodb.CDB_Conf_SetConf('heremaps', conf);
END
$$ LANGUAGE plpgsql;



-- Type used for return value
CREATE TYPE isoline AS (
    center geometry(Geometry,4326),
    range integer,
    the_geom geometry(Geometry,4326)
);



-- The important function that should drive the API
CREATE OR REPLACE FUNCTION cdb_isodistance(
    start geometry(Geometry,4326),
    destination geometry(Geometry,4326),
    mode text,
    distance integer[]
) RETURNS SETOF isoline AS $$
    import cdb.here.routing

    #--TODO: get config

    #--TODO: move instantiation somewhere else

    #--client = cdb.here.routing.Client()

    #--mocked response
    return []
$$ LANGUAGE plpythonu;




-- Sample query (from quickstart)
SELECT * FROM cdb_isodistance(
  ST_PointFromText('POINT(-71.064544 42.28787)', 4326),
  NULL,
  'shortest;car;traffic:disabled',
   Array[1000,2000,3000]
);
