FactoryBot.define do
  factory :booking do
    tenant { "MyString" }
    property { "MyString" }
    payment { "MyString" }
    status { 1 }
    start_rent_at { "2021-01-27 12:22:48" }
    end_rent_at { "2021-01-27 12:22:48" }
  end
end
