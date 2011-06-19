DROP FUNCTION IF EXISTS GeoCMS_find_closest_edge(double precision, double precision);

CREATE OR REPLACE FUNCTION GeoCMS_find_closest_edge(IN x double precision, IN y double precision) RETURNS integer AS 
$BODY$
BEGIN
	RETURN gid FROM roads	
	WHERE the_geom && ST_SetSRID(ST_MakeBox2D(ST_MakePoint(y - 2, x - 2), ST_MakePoint(y + 2, x +2)), 4326)
	ORDER BY distance(the_geom, ST_SetSRID(ST_MakePoint(y, x), 4326)) LIMIT 1;
END;
$BODY$ LANGUAGE plpgsql VOLATILE;

----------------------

DROP FUNCTION IF EXISTS GeoCMS_find_route(double precision, double precision, double precision, double precision);

CREATE OR REPLACE FUNCTION find_route(IN x1 double precision, IN y1 double precision, IN x2 double precision, IN y2 double precision)
  RETURNS TABLE(a text, b character varying) AS
$BODY$
DECLARE
	count integer;
	segment record;
	left_segment geometry;
	right_segment geometry;
	start_point geometry;
	end_point geometry;
	new_point geometry;
	start_edge integer;
	end_edge integer;
	connector geometry;
	fraction float8;
	upper_bound integer;
	segments geometry[];
BEGIN

	DROP TABLE IF EXISTS tmp;
	CREATE LOCAL TEMPORARY TABLE tmp (m_Geometry text, m_Name character varying(255), m_gid integer);

	start_point = ST_SetSRID(ST_MakePoint(y1, x1), 4326); 
	RAISE NOTICE '%', ST_AsText(start_point);
	start_edge := GeoCMS_find_closest_edge(x1, y1);
	RAISE NOTICE '%', ST_AsText(the_geom) FROM roads WHERE gid = start_edge;
	
	end_point = ST_SetSRID(ST_MakePoint(y2, x2), 4326);	
	RAISE NOTICE '%', ST_AsText(end_point);
	end_edge := GeoCMS_find_closest_edge(x2, y2);
	RAISE NOTICE '%', ST_AsText(the_geom) FROM roads WHERE gid = end_edge;

	INSERT INTO tmp SELECT rt.the_geom, roads.label, roads.gid 
	FROM roads, (SELECT gid, the_geom FROM shootingstar_sp('roads', start_edge, end_edge, 5000, 'length', true, true)) as rt WHERE roads.gid = rt.gid;

	SELECT ST_Accum(m_Geometry) INTO segmentcom99123s FROM tmp;
	upper_bound := array_upper(segments, 1);

	TRUNCATE TABLE tmp;

	count := 1;
	FOR segment IN SELECT rt.the_geom, roads.label 
	FROM roads, (SELECT gid, the_geom FROM shootingstar_sp('roads', start_edge, end_edge, 5000, 'length', true, true)) as rt WHERE roads.gid = rt.gid
	LOOP
		IF count = 1 THEN	
			new_point = ST_ClosestPoint(segment.the_geom, start_point);	
			fraction = ST_Line_Locate_point(segment.the_geom, new_point);			
			left_segment = ST_Line_Substring(segment.the_geom, 0, fraction);		
			right_segment = ST_Line_Substring(segment.the_geom, fraction, 1);
			
			INSERT INTO tmp (m_Geometry, m_Name) SELECT ST_AsText(ST_MakeLine(start_point, new_point)), '';
			IF ST_Touches(segments[2], left_segment) THEN
				IF ST_GeometryType(left_segment) = 'ST_LineString' THEN
					INSERT INTO tmp (m_Geometry, m_Name) SELECT ST_AsText(left_segment), '';
				END IF;
				connector := ST_PointN(left_segment, 0);
			ELSE
				IF ST_GeometryType(right_segment) = 'ST_LineString' THEN
					INSERT INTO tmp (m_Geometry, m_Name) SELECT ST_AsText(right_segment), '';
				END IF;
				connector := ST_PointN(right_segment, ST_NPoints(right_segment));
			END IF;
		ELSIF count = upper_bound THEN
			new_point = ST_ClosestPoint(segment.the_geom, end_point);	
			fraction = ST_Line_Locate_point(segment.the_geom, new_point);			
			left_segment = ST_Line_Substring(segment.the_geom, 0, fraction);		
			right_segment = ST_Line_Substring(segment.the_geom, fraction, 1);
			
			INSERT INTO tmp (m_Geometry, m_Name) SELECT ST_AsText(ST_MakeLine(end_point, new_point)), '';
			IF ST_Touches(segments[upper_bound -1], left_segment) THEN
				IF ST_GeometryType(left_segment) = 'ST_LineString' THEN
					INSERT INTO tmp (m_Geometry, m_Name) SELECT ST_AsText(left_segment), '';
				END IF;
				connector := ST_PointN(left_segment, 0);
			ELSE
				IF ST_GeometryType(right_segment) = 'ST_LineString' THEN
					INSERT INTO tmp (m_Geometry, m_Name) SELECT ST_AsText(right_segment), '';
				END IF;
				connector := ST_PointN(right_segment, ST_NPoints(right_segment));
			END IF;			
		ELSE	
			INSERT INTO tmp (m_Geometry, m_Name) SELECT ST_AsText(segment.the_geom), segment.label;			
		END IF;
		connector := ST_PointN(segment.the_geom, ST_NPoints(segment.the_geom));
		count := count + 1;
	END LOOP;

	RETURN QUERY SELECT m_Geometry, m_Name FROM tmp;
	
END;
$BODY$ LANGUAGE plpgsql VOLATILE;
