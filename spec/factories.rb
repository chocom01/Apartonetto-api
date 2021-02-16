# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'MyString' }
    last_name { 'MyString' }
    phone { 123_456_729_12 }
    email { 'asfasag@gmail.com' }
    password { 'MyString' }
    role { 0 }
  end

  factory :property do
    name { 'MyString' }
    location { 'MyString' }
    description { 'MyText' }
    price { 400 }
    association :provider, factory: :user, role: 1
  end

  factory :booking do
    association :tenant, factory: :user
    property
    status { 0 }
    start_rent_at { '01.01.2000' }
    end_rent_at { '02.01.2000' }
  end

  factory :payment do
    payer { booking.tenant }
    recipient { booking.property.provider }
    service { 'MyString' }
    info { 'MyString' }
    amount { 400 }
  end

  # factory :chat do
  #   booking { 'MyString' }
  #   tenant_unread_messages_count { 1 }
  #   provider_unread_messages_count { 1 }
  #   tenant
  #   provider
  # end
  #
  # factory :message do
  #   user
  #   chat { 'MyString' }
  #   text { 'MyText' }
  # end

  # trait :for_property do
  #   association :reviewable, factory: :property
  # end
  #
  # trait :for_user do
  #   association :reviewable, factory: :user
  # end
end
