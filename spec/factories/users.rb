Factory.define :collector, :class => User do |f|
  password = "password"
  f.login { Factory.next :username  }
  f.email { Faker::Internet.email }
  f.password {password}
  f.password_confirmation {password}
  f.role_name "collector"
end

Factory.define :administrator, :class => User do |f|
  password = "password"
  f.login { Factory.next :username }
  f.email { Faker::Internet.email }
  f.password {password}
  f.password_confirmation {password}
  f.role_name "administrator"
end

Factory.define :auditor, :class => User do |f|
  password = "password"
  f.login { Factory.next :username }
  f.email { Faker::Internet.email }
  f.password {password}
  f.password_confirmation {password}
  f.role_name "auditor"
end

Factory.define :invalid_user, :class => User do |f|
end

Factory.sequence :username do |n|
  "user_#{n}"
end