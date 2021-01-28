# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.create(
  [
    { first_name: 'Kolya', last_name: 'Vasyliv', phone: '380631775050',
      email: 'qweasd1@gmail.com', password: 'qweasd' },
    { first_name: 'Igor', last_name: 'Kuzmin', phone: '380631775051',
      email: 'qweasd2@gmail.com', password: 'rtyfgh' },
    { first_name: 'Nazar', last_name: 'Ivleev', phone: '380631775052',
      email: 'qweasd3@gmail.com', password: 'zxcvbn' },
    { first_name: 'Taras', last_name: 'Kravchyk', phone: '380631775053',
      email: 'qweasd4@gmail.com', password: 'vbndfg' }
  ]
)
properties = Property.create(
  [
    { name: 'Apartament', description: 'Smart apartment',
      price: 500, provider_id: 1, location: 'Lviv' },
    { name: 'Apartament', description: 'Luxury apartament',
      price: 400, provider_id: 1, location: 'Lviv' },
    { name: 'Apartament', description: 'Сomfortable apartment ',
      price: 300, provider_id: 1, location: 'Lviv' },
    { name: 'Apartament', description: 'Low cost apartament',
      price: 150, provider_id: 1, location: 'Lviv' },
    { name: 'Apartament', description: 'Small apartament',
      price: 200, provider_id: 1, location: 'Lviv' },
    { name: 'House', description: 'Big house',
      price: 1500, provider_id: 1, location: 'Lviv oblast' }
  ]
)
booking = Booking.create(
  [
    { tenant_id: 2, property_id: 4, start_rent_at: '01.01.21 ', end_rent_at: '02.01.21' },
    { tenant_id: 3, property_id: 3, start_rent_at: '01.01.21', end_rent_at: '02.01.21' },
    { tenant_id: 4, property_id: 3, start_rent_at: '01.01.21', end_rent_at: '02.01.21' }
  ]
)
reviews = Review.create(
  [
    { reviewer_id: 2, reviewable: Property.find(4),
      rate: 3, text: 'Normal apartment' },
    { reviewer_id: 3, reviewable: Property.find(3),
      rate: 4, text: 'comfortable enough ' },
    { reviewer_id: 4, reviewable: Property.find(3),
      rate: 4, text: 'comfortable enough ' }
  ]
)
