Factory.define :mapping, :class => Mapping do |f|
  f.association :category
  f.association :classification
end
