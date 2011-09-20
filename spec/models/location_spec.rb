require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do

  it "can be instantiated" do
    Location.new.should be_an_instance_of(Location)
  end

  it "can save photos" do
    location = Factory(:location)
    photo = Photo.new
    photo.image = File.open(File.expand_path(File.dirname(__FILE__) + '/../fixtures/photo.png'))
    location.photos << photo
    location.save!
    location.reload
    location.photos.count.should == 1
  end

  context "when valid" do

    it "can be saved" do
      Factory.create(:location)
    end

  end

  context "when updated" do

    it "creates an audit trail of changes" do
      Audit.count.should == 0
      location = Factory(:location)
      location.update_attributes(:status => 'audited')
      Audit.count.should == 1
    end

  end

  context "when searching for surrounding landmarks" do

    before(:each) do
      Location.delete_all
      @landmark_category = Factory(:category, :is_landmark => true, :is_hidden => false)
    end

    it "only fetches locations that are in categories marked as containing landmarks" do
      landmark = Factory(:location, :longitude => 0.001, :latitude => 0.001)
      landmark.categories << @landmark_category
      non_landmark = Factory(:location, :longitude => -0.001, :latitude => -0.001)
      poi = Factory(:location, :longitude => 0, :latitude => 0)
      poi.surrounding_landmarks.length.should == 1
    end

    it "only fetches locations that are in visible categories" do
      landmark = Factory(:location, :longitude => 0.001, :latitude => 0.001)
      landmark.categories << @landmark_category
      hidden_category = Factory(:category, :is_landmark => true, :is_hidden => true)
      non_landmark = Factory(:location, :longitude => -0.001, :latitude => -0.001)
      landmark.categories << hidden_category
      poi = Factory(:location, :longitude => 0, :latitude => 0)
      poi.surrounding_landmarks.length.should == 1
    end

    it "only fetches landmarks that are within 500m" do
      landmark = Factory(:location, :longitude => 0.001, :latitude => 0.001)
      landmark.categories << @landmark_category
      outside_catchment = Factory(:location, :longitude =>  2, :latitude => 0.001)
      outside_catchment.categories << @landmark_category
      poi = Factory(:location, :longitude => 0, :latitude => 0)
      poi.surrounding_landmarks.length.should == 1
    end

    it "doesn't fetch the original POI if it's a landmark" do
      landmark = Factory(:location, :longitude => 0.001, :latitude => 0.001)
      landmark.categories << @landmark_category
      poi = Factory(:location, :longitude => 0, :latitude => 0)
      poi.categories << @landmark_category
      poi.surrounding_landmarks.length.should == 1
    end

    it "fetches a maxiumum of 10 landmarks" do
      15.downto 1 do |i|
        location = Factory(:location, :longitude => 0.001, :latitude => i.to_f / 10000.to_f)
        location.categories << @landmark_category
      end
      poi = Factory(:location, :longitude => 0, :latitude => 0)
      poi.surrounding_landmarks.length.should == 10
    end

  end

end