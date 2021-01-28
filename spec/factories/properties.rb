FactoryBot.define do
  factory :property do
    provider { "MyString" }
    name { "MyString" }
    location { "MyString" }
    discribe { "MyText" }
    price { 1.5 }
  end
end
