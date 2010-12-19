require File.join(File.dirname(__FILE__), '..', 'factories_helper.rb')

Factory.define :valid_country, :class => Country do |country|
  country.id {((Country.maximum('id') || 1) + 1)}
  country.name random_token(15)
  country.feature Geometry::square(:center => [rand,rand], :side => rand)
end

Factory.define :invalid_country, :class => Country do
end
