FactoryGirl.define do
  factory :account, class: CWB::Account do
    username            { Faker::Internet.user_name }
    password        { Faker::Internet.password(10, 20) }
    profile
  end
end
