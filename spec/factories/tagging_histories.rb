# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tagging_history do
    account_id 1
    file_tagged "MyString"
    file_untagged "MyString"
  end
end
