# frozen_string_literal: true

class Property < ApplicationRecord
  paginates_per 10
  belongs_to :provider, class_name: 'User'
  has_many :reviews, as: :reviewable
  has_many :bookings, dependent: :destroy
  has_many :photos

  validates :name, :location, :address, length: { in: 4..20 }
  validates :description, presence: true
  validates :price, numericality: { greater_than: 0, less_than: 10_000 }
  validates :guests_capacity, numericality: { greater_than: 1, less_than: 15 }
  validates :rooms_count, numericality: { greater_than: 0, less_than: 12 }

  scope :min_price, ->(amount) { where('price >= ?', amount) }
  scope :max_price, ->(amount) { where('price <= ?', amount) }

  scope :min_capacity, ->(number) { where('guests_capacity >= ?', number) }
  scope :max_capacity, ->(number) { where('guests_capacity <= ?', number) }

  scope :min_rooms, ->(number) { where('rooms_count >= ?', number) }
  scope :max_rooms, ->(number) { where('rooms_count <= ?', number) }

  scope :by_address, ->(address) { where('lower(address) like ?', "#{address.downcase}%") }
end
