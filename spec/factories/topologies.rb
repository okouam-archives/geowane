Factory.define :valid_topology, :class => Topology do |f|
  f.association :commune, :factory => :valid_commune
  f.association :region, :factory => :valid_region
  f.association :country, :factory => :valid_country
  f.association :city, :factory => :valid_city
  f.association :location, :factory => :valid_location
end

Factory.define :invalid_topology, :class => Topology do |f|
end
