describe Classification do

  it "can be instantiated" do
    Classification.new.should be_an_instance_of(Classification)
  end

  context "when valid" do

    it "can be saved successfully" do
      Classification.create(:partner)
    end

  end

end