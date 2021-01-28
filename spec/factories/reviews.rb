FactoryBot.define do
  factory :review do
    tenant { "MyString" }
    rate { 1 }
    text { "MyText" }
  end
end
