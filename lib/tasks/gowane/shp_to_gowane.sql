truncate table locations;
truncate table communes;
truncate table cities;
truncate table regions;
truncate table events;

insert into cities (name)
  select distinct city from poi_external
  where city not in (select name from cities) and city is not null;

insert into regions (name)
  select distinct region from poi_external
  where region not in (select name from regions) and region is not null;

insert into communes (name)
select name from cities where name not like 'Abidjan';

insert into locations(feature, name, region_id, city_id, category_id, longitude, latitude, status, commune_id)
select the_geom, poi_external."label", regions.id, cities.id, categories.id, ST_X(the_geom), ST_Y(the_geom), 'unchecked', communes.id
	FROM poi_external
		JOIN categories ON categories.numeric_code = poi_external."type"
		JOIN cities ON cities."name" like poi_external.city
		JOIN regions ON regions."name" = poi_external.region
		LEFT JOIN communes ON communes."name" = poi_external.city;

INSERT INTO events (action, location_id, cms_user_id, occured_on)
SELECT 'unchecked', locations.id, cms_users.id, now()
FROM locations, cms_users where cms_users.login = 'administrator'

update locations set searchable_name = lower(name);

update locations 
	set searchable_name = searchable_name || ', ' || lower(cities.name)
	FROM cities where cities.id = locations.city_id;

update locations
	set searchable_name = searchable_name || ', ' || lower(communes.name)
	FROM communes where communes.id = locations.commune_id;

DROP TABLE poi_external;