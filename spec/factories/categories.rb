Factory.define :category, :class => Category do |x|
  x.id {(Category.maximum('id') || 0) + 1}
  x.french {Faker::Lorem.words(1)}
  x.english {Faker::Lorem.words(1)}
  x.icon {Faker::Lorem.words(1)}
end

Factory.define :invalid_category, :class => Category do |x|
end
