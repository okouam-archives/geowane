CREATE OR REPLACE FUNCTION geocms_get_angles(IN segment geometry)
  RETURNS TABLE(start_azimut double precision, end_azimut double precision) AS
$BODY$
  DECLARE
    num_points integer;
    start_points geometry[];
    end_points geometry[];
    start_angle double precision;
    end_angle double precision;
  BEGIN
    num_points = ST_NumPoints(segment);
    start_points = ARRAY[ST_PointN(segment, 1), ST_PointN(segment, 2)];
    start_angle = ST_Azimuth(start_points[1], start_points[2]) / (2*pi()) * 360;
    end_points = ARRAY[ST_PointN(segment, num_points - 1), ST_PointN(segment, num_points)];
    end_angle = ST_Azimuth(end_points[1], end_points[2]) / (2*pi()) * 360;
    RETURN QUERY SELECT start_angle, end_angle;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;