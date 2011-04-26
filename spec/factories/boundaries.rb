Factory.define :boundary, :class => Boundary do |x|
  x.name Faker::Lorem.words(1)
  x.level rand(5)
  x.classification Faker::Lorem.words(1)
end
