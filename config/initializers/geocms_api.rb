module API
  ROOT = "#{Rails.root}/app/api"
end

require 'sinatra/base'
require 'json'
require 'RMagick'
require 'rack/contrib/jsonp'
require "#{API::ROOT}/base.rb"
require "#{API::ROOT}/categories.rb"
require "#{API::ROOT}/locations.rb"
require "#{API::ROOT}/images.rb"
require "#{API::ROOT}/routing.rb"
require "#{API::ROOT}/features.rb"