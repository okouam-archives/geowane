describe Category do

  it "can be instantiated" do
    Location.new.should be_an_instance_of(Location)
  end

  context "when valid" do

    it "can be saved" do
      Factory(:location)
    end

  end

end