# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Ozzy Osbourne"
  user.email                 "ozzy@sabbath.rock"
  user.password              "geezer"
  user.password_confirmation "geezer"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content "Foo bar"
  micropost.association :user
end
