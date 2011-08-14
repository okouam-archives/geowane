describe Category do

  it "can be instantiated" do
    Category.new.should be_an_instance_of(Category)
  end

  context "when valid" do

    it "can be saved" do
      Factory(:category)
    end

    context "when saving" do

      context "and the icon link starts with http" do

        before(:each) do
          @category = Factory.build(:category)
          @category.icon = "http://getfirebug.com/img/mozilla-logo.jpg"
          @category.stub(:icon_directory).and_return(Dir.tmpdir)
        end

        it "checks to find the directory in which the icons are stored" do
          @category.should_receive(:icon_directory).and_return(Dir.tmpdir)
          @category.save!
        end

        it "renames the icon link to be the local path" do
          @category.should_receive(:relative_icon_directory).and_return("A")
          @category.save!
          @category.icon.should == "A/mozilla-logo.jpg"
        end

        it "copies the external resource to the local filesystem if not already present" do
          @category.save!
          File.exists?("#{Rails.root}/public/images/icons/mozilla-logo.jpg").should be_true
        end

      end

      context "and the icon link does not start with http" do

        it "does not modify the icon link" do
          category = Factory.build(:category)
          category.icon = "A"
          category.save!
          category.icon.should == "A"
        end

      end

    end

  end

  it "can output a JSON representation" do
    category = Category.create!(:id => 23, :icon => "D", :english => "IF", :french => "POS", :shape => "Location")
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
