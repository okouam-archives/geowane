require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do

  it "can be instantiated" do
    Location.new.should be_an_instance_of(Location)
  end

  context "when valid" do

    it "can be saved" do
      Factory(:location)
    end

  end

  context "when updated" do

    it "creates an audit trail of changes" do
      Audit.count.should == 0
      location = Factory(:location)
      location.update_attributes(:status => 'audited')
      Audit.count.should == 1
    end

    it "records all the model changes" do
      location = Factory(:location)
      location.update_attributes(:status => 'field_checked')
      pending
    end

  end

  context "when creating GeoJSON representation" do

    it "does not add an icon if not in a category" do
      pending
    end

    it "adds the icon of the category to which it belongs" do
      pending
    end

    it "adds the city name if attached to a city" do
      pending
    end

    it "adds the location's main attributes" do
      pending
    end

    it "adds the username of the owner if the property is availabe" do
      pending
    end

    it "adds the name of ther owner if there is no username property available" do
      pending
    end

  end

end