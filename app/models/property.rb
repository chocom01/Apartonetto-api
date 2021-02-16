# frozen_string_literal: true

class Property < ApplicationRecord
  paginates_per 10
  belongs_to :provider, class_name: 'User'
  has_many :reviews, as: :reviewable
  has_many :bookings, dependent: :destroy

  validates :name, :location, length: { in: 4..20 }
  validates :description, presence: true
  validates :price, numericality: { greater_than: 0, less_than: 10_000 }
end
