# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'aegis/spec/matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end

def current_user(stubs = {})
  @current_user ||= double(User, stubs)
end

def user_session(stubs = {}, user_stubs = {})
  @current_session ||= double('UserSession', {:user => current_user(user_stubs)}.merge(stubs))
end

def login_as_collector(session_stubs = {})
  @current_user = Factory(:valid_collector)
  login(session_stubs)
end

def login_as(role, session_stubs = {})
  blueprint = ("valid_" + role).to_sym
  @current_user = Factory(blueprint)
  login(session_stubs)
end

def login(session_stubs = {}, user_stubs = {})
  UserSession.stub!(:find).and_return(user_session(session_stubs, user_stubs))
end

def logout
  @current_session = nil
  @user_session = nil
end