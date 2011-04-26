Factory.define :review, :class => Tag do |f|
  f.association :user, :factory => :member
  f.association :location, :factory => :location
  f.content Faker::Lorem.paragraphs
end