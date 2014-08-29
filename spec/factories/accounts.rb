FactoryGirl.define do
  factory :account, class: CWB::Account do
    name            { Faker::Name.name }
    email           { Faker::Internet.email }
    password        { Faker::Internet.password(10, 20) }
  end
end
