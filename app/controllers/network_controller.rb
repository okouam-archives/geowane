require 'geocms_tools'

class NetworkController < ApplicationController
  resource_controller :singleton
  layout "admin"

  def new
    @network = Network.new
  end

  def create
    network = GeocmsTools::NetworkGenerator.build(params["network"]["input"].tempfile)
    Import.transaction do
      network.edges.each do |e|
        ActiveRecord::Base.connection.execute %{
          INSERT INTO edges (x1,y1, x2, y2, source, target, cost, shape, reverse_cost)
          VALUES (
            #{e.x1},
            #{e.y1},
            #{e.x2},
            #{e.y2}, 
            #{e.source},
            #{e.target},
            #{e.cost},
            ST_GeomFromText('#{e.shape.as_wkt}', 4326),
            #{e.reverse_cost}
          )
        }
      end
    end
  end
end

   