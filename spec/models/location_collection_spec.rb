require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocationCollection do

  describe "when instantiating" do

    it "accepts an array Location objects" do
      a, b = [Factory(:location), Factory(:location)]
      LocationCollection.new([a, b]).items.should == [a, b]
    end

    it "accepts an array of identifiers" do
      a, b = [Factory(:location), Factory(:location)]
      LocationCollection.new([a.id, b.id]).items.should == [a, b]
    end

  end

  describe "when adding tags" do

    context "and the location does not belong to the category" do

      it "adds a tag to the location" do
        location = Factory(:location)
        category = Factory(:category)
        collection = LocationCollection.new([location])
        collection.add_tag(category)
        location.tags.count.should == 1
        tag = location.tags.first
        tag.category.should == category
      end

    end

    context "and the location belongs to the category" do

      it "does not change the tagging for the location" do
        location = Factory(:location)
        category = Factory(:category)
        location.tags.create(category: category)
        collection = LocationCollection.new([location])
        location.tags.count.should == 1
        collection.add_tag(category)
        location.tags.count.should == 1
      end

    end

  end

  describe "when removed tags" do

    context "and the location does not belong to the category" do

      it "does not change the tagging for the location" do
        location = Factory(:location)
        category = Factory(:category)
        collection = LocationCollection.new([location])
        location.tags.count.should == 0
        collection.remove_tag(category)
        location.tags.count.should == 0
      end

    end

    context "and the location belongs to the category" do

      it "removes the tag from the location" do
        location = Factory(:location)
        category = Factory(:category)
        location.tags.create(category: category)
        collection = LocationCollection.new([location])
        location.tags.count.should == 1
        collection.remove_tag(category)
        location.tags.count.should == 0
      end

    end

  end

end