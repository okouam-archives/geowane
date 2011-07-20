
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'aegis/spec/matchers'
require 'database_cleaner'
require 'factory_girl'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  config.mock_with :rspec
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
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

class PostGIS

  def self.define_function(name)
    path = Rails.root.join("db/resources/scripts/functions/#{name}.sql")
    sql = File.read(path)
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.point(x, y)
    "ST_SetSRID(ST_MakePoint(#{x}, #{y}), 4326)"
  end

  def self.linestring(points)
    points = points.map do |point|
      "#{point[0]} #{point[1]}"
    end
    sql = "ST_GeomFromEWKT('SRID=4269;LINESTRING(#{points.join(",")})')"
  end

end