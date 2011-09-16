require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Export do

  describe "when locating locations" do

    context "and no filter criteria were provided" do

      before(:all) do
        @result = Export.locate({})
      end

      it "returns an empty set" do
        @result[:query].count.should == 0
      end

      it "returns a message explaining no filter critera were provided" do
         @result[:query].count.should == 0
      end

    end

  end

end