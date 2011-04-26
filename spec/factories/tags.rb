Factory.define :tag, :class => Tag do |f|
  f.association :category, :factory => :category
  f.association :location, :factory => :location
end

Factory.define :invalid_tag, :class => Tag do |f|
end
