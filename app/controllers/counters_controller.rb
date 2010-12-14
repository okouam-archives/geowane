class CountersController < ApplicationController
  resource_controller
  layout "admin"

  def index
    @counters = User.order("login").find_all {|u| u.locations.count > 0}.map {|c| Counter.new(c)}
  end

end