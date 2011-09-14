require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mapping do

  it "can be instantiated" do
    Mapping.new.should be_an_instance_of(Mapping)
  end

  context "when valid" do

    it "can be saved successfully" do
      Factory.create(:mapping)
    end

  end

end