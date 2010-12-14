require File.join(File.dirname(__FILE__), '..', 'factories_helper.rb')

Factory.define :valid_commune, :class => Commune do |commune|
  commune.id {((Commune.maximum('id') || 1) + 1)}
  commune.name random_token(15)
  commune.feature Geometry::square(:center => [rand,rand], :side => rand)
end

Factory.define :invalid_commune, :class => Commune do
end