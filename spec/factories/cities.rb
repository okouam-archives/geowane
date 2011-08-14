Factory.define :city, :class => City do |f|
  f.id {(City.maximum('id') || 0) + 1}
end