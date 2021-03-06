# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@users = User.create(
  [
    { first_name: 'test', last_name: 'test', phone: '000000000000',
      email: 'test@gmail.com', password: 'admin', role: 0 },
    { first_name: 'Kolya', last_name: 'Vasyliv', phone: '380631775050',
      email: 'qweasd1@gmail.com', password: 'provider', role: 1 },
    { first_name: 'Igor', last_name: 'Kuzmin', phone: '380631775051',
      email: 'qweasd2@gmail.com', password: 'tenant', role: 0 },
    { first_name: 'Nazar', last_name: 'Ivleev', phone: '380631775052',
      email: 'qweasd3@gmail.com', password: 'tenant' },
    { first_name: 'Taras', last_name: 'Kravchyk', phone: '380631775053',
      email: 'qweasd4@gmail.com', password: 'provider', role: 1 }
  ]
)
@properties = Property.create(
  [
    { name: 'Apartament', description: 'Smart apartment',
      address: 'Lincoln 1', guests_capacity: 2, rooms_count: 1,
      price: 500, provider_id: 2, minimum_days: 10,
      longitude: 49.808544, latitude: 24.046864 },

    { name: 'Apartament', description: 'Luxury apartament',
      address: 'Lincoln 2', guests_capacity: 3, rooms_count: 2,
      price: 400, provider_id: 2, minimum_days: 10,
      longitude: 49.808544, latitude: 24.046864 },

    { name: 'Apartament', description: '–°omfortable apartment',
      address: 'Lincoln 3', guests_capacity: 4, rooms_count: 3,
      price: 300, provider_id: 2, minimum_days: 25 },

    { name: 'Apartament', description: 'Low cost apartament',
      address: 'Lincoln 4', guests_capacity: 5, rooms_count: 4,
      price: 150, provider_id: 2, minimum_days: 10,
      longitude: 49.808544, latitude: 24.046864 },

    { name: 'Apartament', description: 'Small apartament',
      address: 'Lincoln 5', guests_capacity: 6, rooms_count: 5,
      price: 200, provider_id: 2, minimum_days: 10,
      longitude: 49.808544, latitude: 24.046864 },

    { name: 'House', description: 'Big house',
      address: 'Lincoln 6', guests_capacity: 7, rooms_count: 6,
      price: 1500, provider_id: 2, minimum_days: 10,
      longitude: 49.808544, latitude: 24.046864 }
  ]
)
@booking = Booking.create(
  [
    { tenant_id: 3, property_id: 3, number_of_guests: 2, amount_for_period: 10_500,
      start_rent_at: '2021.01.01', end_rent_at: '2021.02.05' },
    { tenant_id: 3, property_id: 3, number_of_guests: 3, amount_for_period: 9300,
      start_rent_at: '2021.05.01', end_rent_at: '2021.06.01' }
  ]
)
@payment = Payment.create(
  [
    { payer_id: 3, recipient_id: 2, booking_id: 1, amount: 10_500,
      service: 'Paypal', info: 'payment for apartament', from_date: '2021.01.01' },
    { payer_id: 3, recipient_id: 2, booking_id: 2, amount: 9300,
      service: 'Paypal', info: 'payment for apartament', from_date: '2021.05.01' }
  ]
)

@chat = Chat.create(
  [
    { booking_id: 1, tenant_id: 3, provider_id: 2 },
    { booking_id: 2, tenant_id: 3, provider_id: 2 }
  ]
)
# @reviews = Review.create(
#   [
#     { reviewer_id: 2, reviewable: Property.find(4),
#       rate: 3, text: 'Normal apartment' },
#     { reviewer_id: 3, reviewable: Property.find(3),
#       rate: 4, text: 'comfortable enough ' },
#     { reviewer_id: 4, reviewable: Property.find(3),
#       rate: 4, text: 'comfortable enough ' }
#   ]
# )
