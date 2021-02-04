# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :booking
  has_many :messages

  validate :true_booking

  private

  def true_booking
    booking_id == booking.id || errors.add(:booking, 'invalid booking')
  end
end
