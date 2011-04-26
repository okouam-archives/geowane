Factory.define :location, :class => Location do |f|
  f.name {random_token(15)}
  f.latitude {rand}
  f.longitude {rand}
  f.association :user, :factory => :collector
end

Factory.define :invalid_location, :class => Location do |f|
end
