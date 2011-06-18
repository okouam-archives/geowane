require 'rgeo/geo_json'

module CoreExtensions
  module ActiveRecord
    module Base

      def to_geojson(options = {})
        only = options.delete(:only)
        geoson = { :type => 'Feature' }
        geoson[:properties] = attributes.delete_if do |name, value|
          if value.is_a?(Geometry) then
            factory = RGeo::Geographic.spherical_factory
            geom = factory.point(value.x, value.y)
            geoson[:geometry] = RGeo::GeoJSON.encode(geom) if name == self.class.geometry_column.name
            true
          elsif name == self.class.primary_key then
            geoson[:id] = value
            true
          elsif only
            !only.include?(name.to_sym)
          end
        end
        geoson.to_json
      end

      def update_attributes_from_feature(feature)
        attr = feature.properties
        attr[self.class.geometry_column.name] = feature.geometry
        update_attributes(attr)
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def geometry_column
          @geometry_column ||= columns.detect {|col| col.respond_to?(:geometry_type) }
        end

        def params_from_geojson(geoson)
          name = self.to_s.downcase
          data = geoson.delete(:properties) || {}
          data[geometry_column.name] = Geometry.from_geojson(geoson.delete(:geometry), geometry_column.srid)
          geoson.delete(:type)
          {name => data, primary_key => geoson.delete(:id)}
        end

      end
    end
  end
end
