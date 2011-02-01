class CommunesController < ApplicationController
  include Area

  def collection_sql
    "
      SELECT 
        countries.name as country_name, 
        regions.name as region_name, 
        cities.name as city_name, 
        commune_id as id, 
        communes.name as name, 
        count(*) as locations_count
      FROM topologies 
      JOIN countries ON countries.id = topologies.country_id
      JOIN regions ON regions.id = topologies.region_id
      JOIN cities ON cities.id = topologies.city_id
      JOIN communes ON communes.id = topologies.commune_id
      GROUP BY countries.name, regions.name, cities.name, commune_id, communes.name 
      ORDER BY countries.name, regions.name, cities.name, commune_id, communes.name 
    "
  end

end

  
