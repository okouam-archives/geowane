require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "geocms_find_route" do

  before(:all) do
    PostGIS.define_function("geocms_get_angles")
    PostGIS.define_function("geocms_find_closest_edge")
    PostGIS.define_function("geocms_create_connector")
    PostGIS.define_function("geocms_find_route")
  end

  def execute(sql)
    ActiveRecord::Base.connection.execute("SELECT * FROM geocms_find_route(#{sql})")[0]
  end

end
