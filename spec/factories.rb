# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Kolya' }
    last_name { 'Vasyliv' }
    phone { rand(100_000_000_00..600_000_000_00).to_s }
    email { "#{SecureRandom.alphanumeric[0...-7]}@gmail.com" }
    password { 'qweasdzxc' }
    role { 0 }
  end

  factory :property do
    name { 'Apartament' }
    description { 'Big apartament' }
    address { 'Lincoln 1' }
    price { 100 }
    rooms_count { 4 }
    guests_capacity { 9 }
    minimum_days { 1 }
    association :provider, factory: :user, role: 'provider'
  end

  factory :booking do
    association :tenant, factory: :user
    property
    start_rent_at { '2000.01.01' }
    end_rent_at { '2000.01.02' }
    number_of_guests { 5 }
    amount_for_period { 100 }
  end

  factory :payment do
    booking
    payer { booking.tenant }
    recipient { booking.property.provider }
    service { 'Paypal' }
    info { 'payment for big apartament' }
    amount { 100 }
  end

  factory :chat do
    booking
    tenant_unread_messages_count { 0 }
    provider_unread_messages_count { 0 }
    tenant { booking.tenant }
    provider { booking.property.provider }
  end

  factory :message do
    user { chat.provider }
    chat
    text { 'some text' }
  end
end
