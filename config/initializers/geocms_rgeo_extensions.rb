module RGeo
  module Feature
    module LineString

      def last_point
        point_n[points.size]
      end

      def reverse
        self.points = self.points.reverse
      end

    end
  end
end
