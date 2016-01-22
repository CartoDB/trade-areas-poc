# Helper to deal with type conversion between HERE and PostGIS

import plpy

# Convert a HERE polyline shape to a PostGIS multipolygon
def geo_polyline_to_multipolygon(polyline):
    coordinates = []
    for point in polyline:
        lat, lon = point.split(',')
        coordinates.append("%s %s" % (lon, lat))
    wkt_coordinates = ','.join(coordinates)

    geometry = plpy.execute("SELECT ST_MPolyFromText('MULTIPOLYGON(((%s)))', 4326) as geom" % wkt_coordinates, 1)[0]['geom']
    return geometry
