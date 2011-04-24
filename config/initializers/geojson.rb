require 'geo_ruby'

module GeoRuby
  module SimpleFeatures
    class Geometry
      def self.from_geojson(data, srid=DEFAULT_SRID)
        data ||= {}
        if data.class==String
          require 'active_support'
          data = ActiveSupport::JSON::decode(data)
        end
        coords = data['coordinates'] || data[:coordinates]
        case data['type'] || data[:type]
        when "Point"
          Point.from_coordinates(coords, srid)
        when "LineString"
          LineString.from_coordinates(coords, srid)
        when "Polygon"
          Polygon.from_coordinates(coords, srid)
        when "MultiPoint"
          MultiPoint.from_coordinates(coords, srid)
        when "MultiLineString"
          MultiLineString.from_coordinates(coords, srid)
        when "MultiPolygon"
          MultiPolygon.from_coordinates(coords, srid)
        when "GeometryCollection"
          geometries_json=data['geometries'] || data[:geometries]
          geometries=geometries_json.collect { |cur| from_geojson(cur, srid) }
          GeometryCollection.from_geometries(geometries, srid)
        when "Feature"
          geometries_json=data['geometry'] || data[:geometry]
          properties=data['properties'] || data[:properties]
          id=data['id'] || data[:id]
          Feature.new(from_geojson(geometries_json, srid), properties, id)
        when "FeatureCollection"
          features=data['features'] || data[:features]
          FeatureCollection.new(features.collect { |cur| from_geojson(cur, srid) })
        end
      end
    end
    class Point
      def to_json(options = nil)
        {:type => "Point",
          :coordinates => [self.x, self.y]}.to_json(options)
      end
    end
    class LineString
      def to_json(options = nil)
        coords = self.points.collect {|point| [point.x, point.y] }
        {:type => "LineString",
          :coordinates => coords}.to_json(options)
      end
    end
    class Polygon
      def to_json(options = nil)
        coords = self.collect {|ring| ring.points.collect {|point| [point.x, point.y] } }
        {:type => "Polygon",
          :coordinates => coords}.to_json(options)
      end
    end
    class MultiPoint
      def to_json(options = nil)
        coords = self.geometries.collect {|geom| [geom.x, geom.y] }
        {:type => "MultiPoint",
          :coordinates => coords}.to_json(options)
      end
    end
    class MultiLineString
      def to_json(options = nil)
        coords = self.geometries.collect {|geom| geom.points.collect {|point| [point.x, point.y] } }
        {:type => "MultiLineString",
          :coordinates => coords}.to_json(options)
      end
    end
    class MultiPolygon
      def to_json(options = nil)
        coords = self.geometries.collect {|geom| geom.collect {|ring| ring.points.collect {|point| [point.x, point.y] } } }
        {:type => "MultiPolygon",
          :coordinates => coords}.to_json(options)
      end
    end
    class GeometryCollection
      def to_json(options = nil)
        {:type => "GeometryCollection",
          :geometries => self.geometries}.to_json(options)
      end
    end

    class Feature
      attr_accessor :geometry
      attr_accessor :properties
      attr_accessor :id

      def initialize(geometry, properties={}, id=nil)
        @geometry=geometry
        @properties=properties
        @id=id
      end

      def to_json(options = nil)
        result = {:type=>"Feature", :geometry=>@geometry, :properties=>@properties}
        result[:id] = @id if @id != nil
        result.to_json(options)
      end

      def ==(other)
        if other.class != self.class
          false
        else
          @geometry==other.geometry and @properties==other.properties and @id==other.id
        end
      end
    end

    class FeatureCollection
      attr_accessor :features
      def initialize(features=[])
        @features=features
      end

      def to_json(options = nil)
        {:type=>"FeatureCollection",
          :features=>@features}.to_json(options)
      end

      def ==(other)
        if other.class != self.class
          false
        else
          @features==other.features
        end
      end
    end
  end
end
