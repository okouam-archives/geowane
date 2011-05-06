class BoundariesController < ApplicationController

  def index
    @depth = params[:depth].to_i
    sql = %{
SELECT
#{t(@depth)},
SUM(CASE WHEN status = 'new' THEN 1 ELSE 0 END) as new_locations,
SUM(CASE WHEN status = 'invalid' THEN 1 ELSE 0 END) as invalid_locations,
SUM(CASE WHEN status = 'corrected' THEN 1 ELSE 0 END) as corrected_locations,
SUM(CASE WHEN status = 'audited' THEN 1 ELSE 0 END) as audited_locations,
SUM(CASE WHEN status = 'field_checked' THEN 1 ELSE 0 END) as field_checked_locations,
SUM(CASE WHEN my_tags_count < 1 THEN 1 ELSE 0 END) as uncategorized_locations,
count(*) as total_locations
FROM
  locations
  JOIN
  (SELECT
  locations.id,
  count(distinct tags.category_id) as my_tags_count
  FROM locations
  LEFT JOIN tags
  ON tags.location_id = locations.id
  GROUP BY
  locations.id) AS L ON locations.id = L.id
#{z(@depth)} GROUP BY #{y(@depth)} ORDER BY #{h(@depth)}
}
    @collection = Boundary.find_by_sql(sql)
  end

  private

  def x(depth)
    sql = []
    for i in 0..depth do
      sql << "level_#{i}"
    end
    sql.join(",")
  end

  def y(depth)
    sql = []
    for i in 0..depth do
      sql << "level_#{i}.name, level_#{i}.id"
    end
    sql.join(",")
  end

  def h(depth)
    sql = []
    for i in 0..depth do
      sql << "level_#{i}.name"
    end
    sql.join(",")
  end

  def z(depth)
    sql = []
    for i in 0..depth do
      sql << "LEFT JOIN boundaries as level_#{i} ON locations.level_#{i} = level_#{i}.id"
    end
    sql.join(" ")
  end

  def t(depth)
    sql = []
    for i in 0..depth do
      sql << "level_#{i}.name as level_#{i}, level_#{i}.id as level_#{i}_id"
    end
    sql.join(",")
  end

end