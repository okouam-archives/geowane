
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'aegis/spec/matchers'
require 'database_cleaner'
require 'factory_girl'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  config.mock_with :rspec
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

def current_user(stubs = {})
  @current_user ||= double(User, stubs)
end

def user_session(stubs = {}, user_stubs = {})
  @current_session ||= double('UserSession', {:user => current_user(user_stubs)}.merge(stubs))
end

def login_as_collector(session_stubs = {})
  @current_user = Factory(:collector)
  login(session_stubs)
end

def login_as(role, session_stubs = {})
  blueprint = (role).to_sym
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
