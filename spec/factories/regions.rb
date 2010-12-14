require File.join(File.dirname(__FILE__), '..', 'factories_helper.rb')

Factory.define :valid_region, :class => Region do |region|
  region.id {((Region.maximum('id') || 1) + 1)}
  region.name random_token(15)
  region.feature Geometry::square(:center => [rand,rand], :side => rand)
end

Factory.define :invalid_region, :class => Region do
end