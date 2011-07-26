CREATE OR REPLACE FUNCTION routing.create_connector(IN road geometry, IN label character varying, IN next_road geometry, IN new_point geometry)
  RETURNS TABLE(a geometry, b character varying) AS
$BODY$
  DECLARE
  fraction float;
  left geometry;
  right geometry;
  BEGIN
    fraction = public.ST_Line_Locate_point(road, new_point);
    left = public.ST_Line_Substring(road, 0, fraction);
    right = public.ST_Line_Substring(road, fraction, 1);
    IF ST_Touches(next_road, left) AND ST_GeometryType(left) = 'ST_LineString' THEN
      RETURN QUERY SELECT left, label;
    ELSIF ST_GeometryType(right) = 'ST_LineString' THEN
      RETURN QUERY SELECT right, label;
    END IF;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;