Factory.define :partner_category, :class => PartnerCategory do |f|
  f.association :partner
  f.french {Faker::Lorem.words(1)}
  f.english {Faker::Lorem.words(1)}
end