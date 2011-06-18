module CoreExtensions
  module Array

    def to_geojson(options = {})
      geojson = '{"type": "FeatureCollection", "features": ['
      geojson << collect {|e| e.to_geojson(options) }.join(',')
      geojson << ']}'
      geojson
    end

  end
end

