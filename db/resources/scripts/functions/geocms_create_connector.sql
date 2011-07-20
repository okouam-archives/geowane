CREATE OR REPLACE FUNCTION geocms_create_connector(road geometry, label character varying(255), next_road geometry, route geometry[], new_point geometry)
RETURNS TABLE(a text, b character varying, d double precision, e double precision) AS
$BODY$
  DECLARE
  fraction float;
  left geometry;
  right geometry;
  start_angle float;
  end_angle float;
  BEGIN
    fraction = ST_Line_Locate_point(road, new_point);
    left = ST_Line_Substring(road, 0, fraction);
    right = ST_Line_Substring(road, fraction, 1);
    IF ST_Touches(next_road, left) AND ST_GeometryType(left) = 'ST_LineString' THEN
      SELECT * INTO start_angle, end_angle FROM geocms_get_angles(left);
      RETURN QUERY SELECT ST_AsText(left), label, start_angle, end_angle;
    ELSIF ST_GeometryType(right) = 'ST_LineString' THEN
      SELECT * INTO start_angle, end_angle FROM geocms_get_angles(right);
      RETURN QUERY SELECT ST_AsText(right), label, start_angle, end_angle;
    END IF;
  END;
$BODY$ LANGUAGE plpgsql;
