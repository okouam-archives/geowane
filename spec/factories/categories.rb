Factory.define :valid_category, :class => Category do |x|
  x.id {(Category.maximum('id') || 0) + 1}
  x.french {random_token(15)}
  x.english {random_token(15)}
  x.icon {random_token(15)}
end

Factory.define :invalid_category, :class => Category do |x|
end
