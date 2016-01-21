# Helper to deal with type conversion between HERE and PostGIS

import plpy

# Convert a HERE polyline shape to a PostGIS multipolygon
def geo_polyline_to_multipolygon(polyline):
    #-- mocked response
    return plpy.execute("SELECT ST_MPolyFromText('MULTIPOLYGON(((0 0 1,20 0 1,20 20 1,0 20 1,0 0 1),(5 5 3,5 7 3,7 7 3,7 5 3,5 5 3)))', 4326) as geom", 1)[0]['geom']


