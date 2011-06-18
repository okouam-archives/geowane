DROP FUNCTION IF EXISTS find_closest_edge(double precision, double precision, double precision, double precision);

CREATE OR REPLACE FUNCTION find_closest_edge(x1 double precision, y1 double precision, x2 double precision, y2 double precision) RETURNS TABLE(a text, b character varying(255))
AS $$
DECLARE
	count integer;
	segment record;
	start_point geometry;
	end_point geometry;
	start_edge integer;
	end_edge integer;
	connector geometry;
BEGIN

	DROP TABLE IF EXISTS tmp;
	CREATE LOCAL TEMPORARY TABLE tmp (m_Geometry text, m_Name character varying(255));

	start_point = ST_SetSRID(ST_MakePoint(y1, x1), 4326);

	start_edge := gid
	FROM  roads	
	WHERE the_geom && ST_SetSRID(ST_MakeBox2D(ST_MakePoint(y1 - 2, x1 - 2), ST_MakePoint(y1 + 2, x1 +2)), 4326)
	ORDER BY distance(the_geom, start_point) LIMIT 1;

	end_point = ST_SetSRID(ST_MakePoint(y2, x2), 4326);
	
	end_edge := gid
	FROM roads
	WHERE the_geom && ST_SetSRID(ST_MakeBox2D(ST_MakePoint(y2 - 2, x2 - 2), ST_MakePoint(y2 + 2, x2 +2)), 4326)
	ORDER BY distance(the_geom, end_point) LIMIT 1;

	RAISE NOTICE 'Retrieve start and end edges for the route.';

	-- Align edges
	count := 0;
	FOR segment IN SELECT rt.the_geom, roads.label 
	FROM roads, (SELECT gid, the_geom FROM shootingstar_sp('roads', start_edge, end_edge, 5000, 'length', true, true)) as rt WHERE roads.gid = rt.gid
	LOOP
		IF count = 0 THEN	
			INSERT INTO tmp (m_Geometry, m_Name) SELECT ST_AsText(segment.the_geom), segment.label;
		ELSE	
			IF NOT ST_PointN(segment.the_geom, 0) = connector THEN
				INSERT INTO tmp (m_Geometry, m_Name) SELECT ST_AsText(ST_Reverse(segment.the_geom)), segment.label;
			ELSE
				INSERT INTO tmp (m_Geometry, m_Name) SELECT ST_AsText(segment.the_geom), segment.label;
			END IF;
		END IF;
		count := count + 1;
		connector := ST_PointN(segment.the_geom, ST_NPoints(segment.the_geom));
	END LOOP;

	-- Create Start Edge

	-- Create End Edge

	RETURN QUERY SELECT * FROM tmp;
	
END;
$$ LANGUAGE plpgsql;
