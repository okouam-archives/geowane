
CREATE OR REPLACE FUNCTION geocms_find_closest_edge(x double precision, y double precision)
  RETURNS integer AS
$BODY$
  BEGIN
    RETURN gid FROM edges
    WHERE the_geom && ST_SetSRID(ST_MakeBox2D(ST_MakePoint(y - 2, x - 2), ST_MakePoint(y + 2, x +2)), 4326)
    ORDER BY distance(the_geom, ST_SetSRID(ST_MakePoint(y, x), 4326)) LIMIT 1;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;