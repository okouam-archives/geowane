require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "steak"

Capybara.javascript_driver = :webkit
require "#{File.dirname(__FILE__)}/support/pages/page.rb"
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}