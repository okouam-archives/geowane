require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Region do

  it "can be saved when valid" do
   Factory(:valid_region)
  end

  it "cannot be saved when invalid" do
    region = Factory.build(:invalid_region)
    region.save.should be_false
  end

end