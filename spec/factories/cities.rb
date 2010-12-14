require File.join(File.dirname(__FILE__), '..', 'factories_helper.rb')

Factory.define :valid_city, :class => City do |city|
  city.id {((City.maximum('id') || 1) + 1)}
  city.name random_token(15)
  city.feature Geometry::square(:center => [rand,rand], :side => rand)
end

Factory.define :invalid_city, :class => City do
end