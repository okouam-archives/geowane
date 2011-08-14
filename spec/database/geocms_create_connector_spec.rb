require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "geocms_create_connector" do

  before(:all) do
    PostGIS.define_function("routing.get_angles")
    PostGIS.define_function("routing.create_connector")
  end

  def execute(sql)
    ActiveRecord::Base.connection.execute("SELECT * FROM routing.create_connector(#{sql})")[0]
  end

  describe "when the new point is at a endpoint"  do

  end

  describe "when the new point is not at an endpoint" do

  end

  describe "when the next road is the same as the connecting road" do

  end

end
