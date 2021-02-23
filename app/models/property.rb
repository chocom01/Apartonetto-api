# frozen_string_literal: true

class Property < ApplicationRecord
  paginates_per 10
  belongs_to :provider, class_name: 'User'
  has_many :reviews, as: :reviewable
  has_many :bookings, dependent: :destroy

  validates :name, :location, :address, length: { in: 4..20 }
  validates :description, presence: true
  validates :price, numericality: { greater_than: 0, less_than: 10_000 }
  validates :guests_capacity, numericality: { greater_than: 1, less_than: 15 }
  validates :rooms_count, numericality: { greater_than: 0, less_than: 12 }

  scope :price_more_than, ->(amount) { where('price >= ?', amount) }
  scope :price_less_than, ->(amount) { where('price <= ?', amount) }

  scope :capacity_more_than, ->(number) { where('guests_capacity >= ?', number) }
  scope :capacity_less_than, ->(number) { where('guests_capacity <= ?', number) }

  scope :minimum_rooms, ->(number) { where('rooms_count >= ?', number) }
  scope :maximum_rooms, ->(number) { where('rooms_count <= ?', number) }

  scope :by_address, ->(address) { where('lower(address) like ?', "#{address.downcase}%") }
end
