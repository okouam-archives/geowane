# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'rack-debug/tasks' if Rails.env.development?

Gowane::Application.load_tasks
spec_prereq = :noop