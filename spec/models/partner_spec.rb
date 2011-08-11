require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Partner do

  it "can be instantiated" do
    Partner.new.should be_an_instance_of(Partner)
  end

  context "when valid" do

    it "can be saved successfully" do
      Factory.create(:partner)
    end

  end

end