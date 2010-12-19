require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do

  it "can have many locations though tags" do
    category = Factory(:valid_category)
    category.tags << Factory(:valid_tag, :category => category)
    category.locations.size.should eql(1)
  end

  describe "when saving" do

     it "can be saved given valid attributes" do
      category = Category.new(:french => "a category", :english => "in french")
      category.save.should be_true
    end

    it "cannot be saved without a french label" do
      category = Category.new(:english => "in french")
      category.save.should be_false
    end

    it "cannot be saved without an english label" do
      category = Category.new(:french => "in french")
      category.save.should be_false
    end

  end

end
