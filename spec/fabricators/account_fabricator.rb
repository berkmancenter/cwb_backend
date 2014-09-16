require 'faker'

Fabricator(:account, from: 'CWB::Account') do
  username        { Faker::Internet.user_name }
  password        { Faker::Internet.password(10, 20) }
end
