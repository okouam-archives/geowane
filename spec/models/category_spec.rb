describe Category do

  it "can be instantiated" do
    Category.new.should be_an_instance_of(Category)
  end

  context "when valid" do

    it "can be saved" do
      Factory(:category)
    end

  end

  it "can output a JSON representation" do
    category = Category.create!(:id => 23, :icon => "D", :english => "IF", :french => "POS")
    category.json_object.should == {:id => category.id, :icon => "D", :name => "POS"}
  end

  it "can output its bilingual name" do
    category = Category.new(:french => "A", :english => "B")
    category.bilingual_name.should == "A / B"
  end

  it "provides a list of categories for use in dropdowns" do
    Factory.create(:category, :french => "A")
    Factory.create(:category, :french => "K")
    Factory.create(:category, :french => "F")
    categories = Category.dropdown_items
    categories.size.should == 3
    categories.first[0].should == "A"
    categories.last[0].should == "K"
  end


end
