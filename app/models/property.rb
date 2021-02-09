# frozen_string_literal: true

class Property < ApplicationRecord
  paginates_per 10
  belongs_to :provider, class_name: 'User'
  has_many :reviews, as: :reviewable
  has_many :bookings

  validates :name, :location, length: { in: 4..20 }
  validates_presence_of :description
  validates :price, numericality: { greater_than: 0, less_than: 10_000 }
  validate :true_provider_role

  private

  def true_provider_role
    provider.role == 'provider' || provider.role == 'admin' ||
      errors.add(:provider, 'must be provider or admin')
  end
end
