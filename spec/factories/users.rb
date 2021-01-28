FactoryBot.define do
  factory :user do
    first_name { "MyString" }
    last_name { "MyString" }
    mobile_phone { 1 }
    email { "MyString" }
    password { "MyString" }
    role { 1 }
  end
end
