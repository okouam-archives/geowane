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

  def cache_counters
    @connection.execute %{
      UPDATE categories SET tags_count = (SELECT COUNT(*) FROM tags WHERE category_id = categories.id);
      UPDATE locations SET tags_count = (SELECT COUNT(*) FROM tags WHERE location_id = locations.id);
    }
  end

  def collectors
  end

end
