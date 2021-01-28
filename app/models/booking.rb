# frozen_string_literal: true

class Booking < ApplicationRecord
  enum status: %i[waiting for confirm confirmed declined canceled]

  belongs_to :tenant, class_name: 'User'
  belongs_to :property
  has_one :payment
  has_one :chat

  validates_presence_of :start_rent_at, :end_rent_at
  validate :end_date_is_after_start_date

  private

  def end_date_is_after_start_date
    end_rent_at < start_rent_at &&
      errors.add(:end_rent_at, 'cannot be before the start date')
    return if end_rent_at.blank? || start_rent_at.blank?
  end
end
