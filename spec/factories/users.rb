Factory.define :collector, :class => User do |f|
  password = random_token(15)
  f.login {random_token(15)}
  f.email {random_token(15) + "@" + random_token(10) + ".com" }
  f.password {password}
  f.password_confirmation {password}
  f.role_name "collector"
end

Factory.define :administrator, :class => User do |f|
  password = random_token(15)
  f.login {random_token(15)}
  f.email {random_token(15) + "@" + random_token(10) + ".com" }
  f.password {password}
  f.password_confirmation {password}
  f.role_name "administrator"
end

Factory.define :member, :class => User do |f|
  password = random_token(15)
  f.login { random_token(15)}
  f.email { random_token(15) + "@" + random_token(10) + ".com" }
  f.password {password}
  f.password_confirmation {password}
  f.role_name "member"
end


Factory.define :auditor, :class => User do |f|
  password = random_token(15)
  f.login { random_token(15)}
  f.email { random_token(15) + "@" + random_token(10) + ".com" }
  f.password {password}
  f.password_confirmation {password}
  f.role_name "auditor"
end

Factory.define :invalid_user, :class => User do |f|
end