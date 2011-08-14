require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require "rails/application"
  Spork.trap_method(Rails::Application, :reload_routes!)
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'aegis/spec/matchers'
  require 'factory_girl'
  require 'capybara/rspec'
  require 'database_cleaner'

  RSpec.configure do |config|

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
end

Spork.each_run do
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  Factory.definition_file_paths = [File.join(Rails.root, 'spec', 'factories')]
  Factory.find_definitions
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

