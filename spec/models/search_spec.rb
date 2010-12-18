require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Search do

  before(:all) do
    @john = Factory(:valid_administrator)
    @richard = Factory(:valid_administrator)
    @carl = Factory(:valid_administrator)
    @tom = Factory(:valid_administrator)
  end

  before(:each) do
    @a = Factory(:valid_location, :user => @john)
    @b = Factory(:valid_location, :user => @richard)
  end

  describe "when criteria are provided" do

    describe "and searching by 'Audited By'" do

      it "returns the correct results" do

        Audit.as_user(@richard) { @a.status = :audited; @a.save! }
        Audit.as_user(@carl) { @b.status = :audited; @b.save! }

        Audit.as_user(@john) { @a.status = :invalid; @a.save! }
        Audit.as_user(@tom) { @b.status = :invalid; @b.save! }

        sql = Search.create(:audited_by => @carl.id)
        results = Location.find_by_sql(sql)
        results.size.should eql(1)
        results.should == [@b]
      end

    end

    describe "and searching by 'Modified By'" do

      it "returns the correct results" do

        Audit.as_user(@john) { @a.longitude = 1; @a.save! }
        Audit.as_user(@tom) { @b.longitude = 3; @b.save! }

        sql = Search.create(:modified_by => @tom.id)
        results = Location.find_by_sql(sql)
        results.should have(1).item
        results.should == [@b]
      end

    end

    describe "and searching by 'Category Missing'" do

      it "returns the correct results" do
        @a.category = Factory(:valid_category)
        @a.save!
        sql = Search.create(:category_missing => "1")
        results = Location.find_by_sql(sql)
        results.should have(1).item
        results.should include(@b)
      end

    end

    describe "and searching by 'Category Present'" do

      it "returns the correct results" do
        @a.category = Factory(:valid_category)
        @a.save!
        sql = Search.create(:category_present => "1")
        results = Location.find_by_sql(sql)
        results.should have(1).item
        results.should include(@a)
      end

    end

  end

  describe "when no criteria are provided" do

    it "returns the correct results" do
        sql = Search.create
        results = Location.find_by_sql(sql)
        results.should have(2).items
        results.should include(@b, @a)
    end

  end

end