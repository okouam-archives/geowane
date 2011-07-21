require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "geocms_create_connector" do

  before(:all) do
    PostGIS.define_function("geocms_get_angles")
  end

  def execute(sql)
    ActiveRecord::Base.connection.execute("SELECT * FROM geocms_create_connector(#{sql})")[0]
  end

  it "returns an empty result if the geometry is NULL" do
    result = execute("NULL")
    result["start_azimut"].should be_nil
    result["end_azimut"].should be_nil
  end

  it "returns an empty result if the geometry is not a linestring" do
    point = PostGIS.point(0, 0)
    result = execute(point)
    result["start_azimut"].should be_nil
    result["end_azimut"].should be_nil
  end

  it "handles linestrings with 2 points" do
    linestring = PostGIS.linestring([[0, 0], [1, 0]])
    result = execute(linestring)
    result["start_azimut"].should == "90"
    result["end_azimut"].should == "90"
  end

  it "correctly identifies the start angle" do
    linestring = PostGIS.linestring([[0, 0], [0, -1], [1, 0]])
    result = execute(linestring)
    result["start_azimut"].should == "180"
  end

  it "correctly identifies the end angle" do
    linestring = PostGIS.linestring([[0, 0], [0, -1], [1, 0]])
    result = execute(linestring)
    result["end_azimut"].should == "45"
  end

end
