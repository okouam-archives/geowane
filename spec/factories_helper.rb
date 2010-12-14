def random_token(length)
  chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'
  token = ''
  length.times {token << chars[rand(chars.length)] }
  token
end

class Geometry

  def self.square(options)
    slide = options[:side] / 2
    center = options[:center]
    	GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[center[0] - slide, center[1] - slide],
                                                          [center[0] - slide, center[1] + slide],
                                                          [center[0] + slide, center[1] + slide],
                                                          [center[0] + slide, center[1] - slide],
                                                          [center[0] - slide, center[1] - slide]]], 4326)
  end

end