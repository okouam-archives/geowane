DROP FUNCTION IF EXISTS geocms_find_closest_edge(double precision, double precision);

CREATE OR REPLACE FUNCTION geocms_find_closest_edge(IN x double precision, IN y double precision) RETURNS integer AS
$BODY$
BEGIN
	RETURN gid FROM roads	
	WHERE the_geom && ST_SetSRID(ST_MakeBox2D(ST_MakePoint(y - 2, x - 2), ST_MakePoint(y + 2, x +2)), 4326)
	ORDER BY distance(the_geom, ST_SetSRID(ST_MakePoint(y, x), 4326)) LIMIT 1;
END;
$BODY$ LANGUAGE plpgsql VOLATILE;

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

CREATE OR REPLACE FUNCTION geocms_find_route(IN x1 double precision, IN y1 double precision, IN x2 double precision, IN y2 double precision)
  RETURNS TABLE(a text, b character varying, d double precision, e double precision) AS
$BODY$
  DECLARE
    count integer;
    segment record;
    start_point geometry;
    end_point geometry;
    new_point geometry;
    start_edge integer;
    end_edge integer;
    fraction float8;
    upper_bound integer;
    route_segments geometry[];
    start_angle float;
    end_angle float;
    main_cursor CURSOR (a integer, b integer) IS
	SELECT rt.the_geom, roads.label
	FROM roads, (SELECT gid, the_geom FROM shootingstar_sp('roads', a, b, 5000, 'length', true, true)) as rt
	WHERE roads.gid = rt.gid;
  BEGIN

    DROP TABLE IF EXISTS tmp;
    CREATE LOCAL TEMPORARY TABLE tmp
    (m_geometry text, m_name character varying(255), m_start_angle float, m_end_angle float);

    start_point = ST_SetSRID(ST_MakePoint(y1, x1), 4326);
    start_edge := GeoCMS_find_closest_edge(x1, y1);

    end_point = ST_SetSRID(ST_MakePoint(y2, x2), 4326);
    end_edge := GeoCMS_find_closest_edge(x2, y2);

    SELECT ST_Accum(rt.the_geom) INTO route_segments
    FROM roads, (SELECT gid, the_geom FROM shootingstar_sp('roads', start_edge, end_edge, 5000, 'length', true, true)) as rt
    WHERE roads.gid = rt.gid;

    upper_bound := array_upper(route_segments, 1);
    count := 1;

    OPEN main_cursor(start_edge, end_edge);

    LOOP
    FETCH main_cursor INTO segment;
    EXIT WHEN NOT FOUND;
      IF count = 1 THEN
	new_point = ST_ClosestPoint(segment.the_geom, start_point);
	INSERT INTO tmp SELECT ST_AsText(ST_MakeLine(start_point, new_point)), '', null, null;
	INSERT INTO tmp SELECT * FROM geocms_create_connector(segment.the_geom, segment.label, route_segments[2], route_segments, new_point);
      ELSIF count = upper_bound THEN
	new_point = ST_ClosestPoint(segment.the_geom, end_point);
	INSERT INTO tmp SELECT * FROM geocms_create_connector(segment.the_geom, segment.label, route_segments[upper_bound - 1], route_segments, new_point);
	INSERT INTO tmp SELECT ST_AsText(ST_MakeLine(end_point, new_point)), '', null, null;
      ELSE
	SELECT * INTO start_angle, end_angle FROM geocms_get_angles(segment.the_geom);
	INSERT INTO tmp SELECT ST_AsText(segment.the_geom), segment.label, start_angle, end_angle;
      END IF;
      count := count + 1;
    END LOOP;
    CLOSE main_cursor;

    RETURN QUERY SELECT * FROM tmp;

  END;
$BODY$ LANGUAGE plpgsql;

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
