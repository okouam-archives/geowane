-- Function: geocms_find_route(double precision, double precision, double precision, double precision)

-- DROP FUNCTION geocms_find_route(double precision, double precision, double precision, double precision);

CREATE OR REPLACE FUNCTION geocms_find_route(IN x1 double precision, IN y1 double precision, IN x2 double precision, IN y2 double precision)
  RETURNS TABLE(a text, b character varying, d double precision, e double precision) AS
$BODY$
  DECLARE
    counter integer;
    segment record;
    neighbour geometry;
    start_point geometry;
    end_point geometry;
    new_point geometry;
    start_edge integer;
    end_edge integer;
    fraction float8;
    num_route_segments integer;
    start_angle float;
    end_angle float;
    main_cursor SCROLL CURSOR IS SELECT * from pgrouting_result;
    alignment_cursor SCROLL CURSOR IS SELECT * from corrected_route;
    directions_cursor SCROLL CURSOR IS SELECT * from aligned_route;
  BEGIN

    DROP TABLE IF EXISTS pgrouting_result;
    DROP TABLE IF EXISTS corrected_route;
    DROP TABLE IF EXISTS aligned_route;
    DROP TABLE IF EXISTS directed_result;
    CREATE LOCAL TEMPORARY TABLE pgrouting_result (geom text, label character varying(255));
    CREATE LOCAL TEMPORARY TABLE corrected_route (geom text, label character varying(255));
    CREATE LOCAL TEMPORARY TABLE aligned_route (geom text, label character varying(255));
    CREATE LOCAL TEMPORARY TABLE directed_result (geom text, label character varying(255), first_angle float, last_angle float);

    start_point = ST_SetSRID(ST_MakePoint(x1, y1), 4326);
    start_edge := GeoCMS_find_closest_edge(y1, x1);

    RAISE NOTICE '%', start_point;	
    RAISE NOTICE '%', start_edge;

    end_point = ST_SetSRID(ST_MakePoint(x2, y2), 4326);
    end_edge := GeoCMS_find_closest_edge(y2, x2);

    RAISE NOTICE '%', end_point;
    RAISE NOTICE '%', end_edge;	

    INSERT INTO pgrouting_result(geom, label) SELECT rt.the_geom, edges.label
    FROM edges, (SELECT gid, the_geom FROM shootingstar_sp('edges', start_edge, end_edge, 5000, 'length', true, true)) as rt
    WHERE edges.gid = rt.gid;   

    num_route_segments = count(label) FROM pgrouting_result;    
    counter := 1;

    RAISE NOTICE '%', num_route_segments;

    OPEN main_cursor;
    LOOP
    FETCH main_cursor INTO segment;
    EXIT WHEN NOT FOUND;
      RAISE NOTICE '%', ST_AsText(segment.geom);
      IF counter = 1 THEN
	new_point = ST_ClosestPoint(segment.geom, start_point);
	INSERT INTO corrected_route (geom, label) SELECT ST_SetSRID(ST_MakeLine(start_point, new_point), 4326), '';
	FETCH NEXT FROM main_cursor INTO segment;
	neighbour = segment.geom;
	FETCH PRIOR FROM main_cursor INTO segment; 
	INSERT INTO corrected_route(geom, label) SELECT * FROM geocms_create_connector(segment.geom, segment.label, neighbour, new_point);
      ELSIF counter = num_route_segments THEN
	new_point = ST_ClosestPoint(segment.geom, end_point);
	FETCH PRIOR FROM main_cursor INTO segment; 
	neighbour = segment.geom;
	FETCH NEXT FROM main_cursor INTO segment;
	INSERT INTO corrected_route (geom, label) SELECT * FROM geocms_create_connector(segment.geom, segment.label, neighbour, new_point);
	INSERT INTO corrected_route (geom, label) SELECT ST_SetSRID(ST_MakeLine(end_point, new_point), 4326), '';
      ELSE	
	INSERT INTO corrected_route (geom, label) SELECT segment.geom, segment.label;
      END IF;
      counter := counter + 1;
    END LOOP;
    CLOSE main_cursor;    

    neighbour = start_point;
    
    OPEN alignment_cursor;
    LOOP
    FETCH alignment_cursor INTO segment;
    EXIT WHEN NOT FOUND;
      RAISE NOTICE '%', ST_AsText(segment.geom);
      IF ST_Equals(PointN(segment.geom, 1), neighbour) THEN        
	new_point = segment.geom;
      ELSE
      	new_point = ST_Reverse(segment.geom);
      END IF;
     neighbour = PointN(new_point, ST_NumPoints(new_point));
      INSERT INTO aligned_route SELECT new_point, segment.label;
    END LOOP;
    CLOSE alignment_cursor;    

    OPEN directions_cursor;
    LOOP
    FETCH directions_cursor INTO segment;
    EXIT WHEN NOT FOUND;
      RAISE NOTICE '%', ST_AsText(segment.geom);
      SELECT * INTO start_angle, end_angle FROM geocms_get_angles(segment.geom);
      INSERT INTO directed_result SELECT segment.geom, segment.label, start_angle, end_angle;
    END LOOP;
    CLOSE directions_cursor;    

    RETURN QUERY SELECT ST_AsText(geom), label, first_angle, last_angle FROM directed_result;

  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;