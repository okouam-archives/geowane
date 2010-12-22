class Statistics

  def initialize
    @connection = ActiveRecord::Base.connection
  end

  def refresh(type)
    self.send type
  end

  def categories
    @connection.execute %{
      UPDATE categories 
	    SET total_locations = statistics.locations_count,
	    new_locations = statistics.new,
	    invalid_locations = statistics.invalid,
	    corrected_locations = statistics.corrected,
	    audited_locations = statistics.audited,
	    field_checked_locations = statistics.field_checked
         FROM
         (SELECT       
		    categories.id,
	          categories.tags_count as locations_count, 
	          SUM(CASE WHEN status = 'new' THEN 1 ELSE 0 END) as "new",
                  SUM(CASE WHEN status = 'invalid' THEN 1 ELSE 0 END) as invalid,
                  SUM(CASE WHEN status = 'corrected' THEN 1 ELSE 0 END) as corrected,
                  SUM(CASE WHEN status = 'audited' THEN 1 ELSE 0 END) as audited,
                  SUM(CASE WHEN status = 'field_checked' THEN 1 ELSE 0 END) as field_checked
          FROM categories 
          JOIN tags ON tags.category_id = categories.id
          JOIN locations ON locations.id = tags.location_id
          GROUP BY categories.id, categories.tags_count
          UNION
          SELECT 
	    categories.id, 0, 0, 0, 0, 0, 0
	    FROM categories WHERE categories.id NOT IN (SELECT category_id FROM tags)) as statistics
         WHERE statistics.id = categories.id
    }
  end

  def areas
    ["countries", "regions", "cities", "communes"].each do |level|
      @connection.execute %{
      UPDATE #{level} SET 
	      new_locations = "new", 
	      invalid_locations = invalid,
	      corrected_locations = corrected, 
	      field_checked_locations = field_checked, 
	      audited_locations = audited,
	      total_locations = locations_count
      FROM
          (SELECT #{level}.id,
              SUM(CASE WHEN status = 'new' THEN 1 ELSE 0 END) as "new",
              SUM(CASE WHEN status = 'invalid' THEN 1 ELSE 0 END) as invalid,
              SUM(CASE WHEN status = 'corrected' THEN 1 ELSE 0 END) as corrected,
              SUM(CASE WHEN status = 'audited' THEN 1 ELSE 0 END) as audited,
              SUM(CASE WHEN status = 'field_checked' THEN 1 ELSE 0 END) as field_checked,
              count(*) as locations_count
            FROM topologies 
            JOIN #{level} ON #{level}.id = topologies.#{level.singularize}_id
            JOIN locations ON locations.id = topologies.location_id
            GROUP BY #{level}.id) as statistics
      WHERE 
        statistics.id = #{level}.id;
      UPDATE #{level} SET uncategorized_locations = uncategorized 
      FROM (SELECT #{level.singularize}_id, count(*) as uncategorized
            FROM topologies 
            JOIN locations ON locations.id = topologies.location_id
            WHERE tags_count < 1
            GROUP BY #{level.singularize}_id) as statistics
            where statistics.#{level.singularize}_id = #{level}.id;
      }
    end
  end

  def cache_counters

  end

  def counters
  end

end
