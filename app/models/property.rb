# frozen_string_literal: true

class Property < ApplicationRecord
  belongs_to :provider, class_name: 'User'
  has_many :reviews, as: :reviewable
  has_many :bookings, dependent: :destroy
  has_many :photos

  validates :name, :address, length: { in: 4..20 }
  validates :description, presence: true
  validates :price, numericality: { greater_than: 0, less_than: 10_000 }
  validates :minimum_days, numericality: { greater_than: 0 }
  validates :guests_capacity, numericality: { greater_than: 0, less_than: 15 }
  validates :rooms_count, numericality: { greater_than: 0, less_than: 12 }

  scope :min_price, ->(amount) { where('price >= ?', amount) }
  scope :max_price, ->(amount) { where('price <= ?', amount) }

  scope :min_capacity, ->(number) { where('guests_capacity >= ?', number) }
  scope :max_capacity, ->(number) { where('guests_capacity <= ?', number) }

  scope :min_rooms, ->(number) { where('rooms_count >= ?', number) }
  scope :max_rooms, ->(number) { where('rooms_count <= ?', number) }

  scope :by_address, lambda { |address|
    where('lower(address) like ?', "%#{address.downcase}%")
  }

  scope :by_coordinates, lambda {
    |longitude_down, longitude_up, latitude_left, latitude_right|
    where(
      'longitude BETWEEN :bottom_point AND :top_point AND
      latitude BETWEEN :left_point AND :right_point',
      bottom_point: longitude_down, top_point: longitude_up,
      left_point: latitude_left, right_point: latitude_right
    )
  }

  scope :vacant_properties_in_dates, lambda { |initial_date, finale_date|
    booking_table = Booking.arel_table
    property_table = Property.arel_table
    find_by_sql(
      property_table.join(booking_table, Arel::Nodes::OuterJoin)
                    .on(property_table[:id].eq(booking_table[:property_id])
                    .and(booking_table[:end_rent_at].gt(initial_date))
                    .and(booking_table[:start_rent_at].lt(finale_date)))
                    .where(booking_table[:id].eq(nil))
                    .order(property_table[:id].asc).project('properties.*')
    )
  }
end
