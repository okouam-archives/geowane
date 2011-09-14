Factory.define :category, :class => Category do |x|
  x.id {(Category.maximum('id') || 0) + 1}
  x.french "Maisons"
  x.english "Houses"
  x.icon "image.jpg"
end

Factory.define :invalid_category, :class => Category do |x|
end
