require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  describe "when saving" do

    it "creates a new instance given valid attributes" do
      User.create!(:login => "john", :password => "com11", :password_confirmation => "com11", :email => "com@dadad.com", :role_name => "collector")
    end

    it "has a default status of active" do
      user = Factory(:valid_collector)
      user.is_active.should be_true
    end

  end

  describe "scopes" do

    describe "when searching for active users" do

      it "does not featch inactive users" do
        User.delete_all
        inactive_user = Factory(:valid_collector)
        inactive_user.is_active = false
        inactive_user.save!
        active_user = Factory(:valid_collector)
        User.active.should == [active_user]
      end

    end

  end

end