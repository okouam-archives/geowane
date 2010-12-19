Factory.define :valid_tag, :class => Tag do |f|
  f.association :category, :factory => :valid_category
  f.association :location, :factory => :valid_location
end

Factory.define :invalid_tag, :class => Tag do |f|
end
