-- Poc for the Routing API focused on trade areas.
--
-- This code will have to be suffled around in order to:
--   * split server and client extension code
--   * isolate configs
--   * add quota checks and usage tracking

-- * Requirements:
--  * Add your app_id and and app_code to cdb_conf table:
--      SELECT _cdb_configure_heremaps('your_app_id', 'your_app_code');
--
--  * Package and install the python library:
--      ```
--      cd lib/python/cdb
--      python setup.py sdist
--      pip install ./dist/cdb-0.0.1.tar.gz
--      ```


-- Helper to configure locally
CREATE OR REPLACE FUNCTION _cdb_configure_heremaps(app_id text, app_code text)
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
    import json
    import cdb.here.routing
    import cdb.here.types

    heremaps_conf = json.loads(plpy.execute("SELECT cartodb.CDB_Conf_GetConf('heremaps') AS conf", 1)[0]['conf'])
    app_id = heremaps_conf['app_id']
    app_code = heremaps_conf['app_code']

    client = cdb.here.routing.Client(app_id, app_code)

    #-- TODO: move this to a module function
    if start:
        lat = plpy.execute("SELECT ST_Y('%s') AS lat" % start)[0]['lat']
        lon = plpy.execute("SELECT ST_X('%s') AS lon" % start)[0]['lon']
        start_str = 'geo!%f,%f' % (lat, lon)
    else:
        start_str = None

    if destination:
        lat = plpy.execute("SELECT ST_Y('%s') AS lat" % destination)[0]['lat']
        lon = plpy.execute("SELECT ST_X('%s') AS lat" % destination)[0]['lon']
        destination_str = 'geo!%f,%f' % (lat, lon)
    else:
        destination_str = None

    #--plpy.notice('start_str = ' + start_str)

    resp = client.calculate_isodistance(start_str, destination_str, mode, distance)

    c = resp['response']['center']
    center = plpy.execute("SELECT CDB_LatLng (%f, %f) as center" % (c['latitude'], c['longitude']), 1)[0]['center']

    isolines = resp['response']['isoline']
    ret_rows = []
    for isoline in isolines:
        range = isoline['range']

        #-- TODO: will this return more than a polygon?
        assert len(isoline['component']) == 1

        polyline = isoline['component'][0]['shape']
        multipolygon = cdb.here.types.geo_polyline_to_multipolygon(polyline)
        ret_rows.append([center, range, multipolygon])

    return ret_rows
$$ LANGUAGE plpythonu;




-- Sample query (from quickstart)
SELECT * FROM cdb_isodistance(
  ST_PointFromText('POINT(-71.064544 42.28787)', 4326),
  NULL,
  'shortest;car;traffic:disabled',
   Array[1000,2000,3000]
);
