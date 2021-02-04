# frozen_string_literal: true

class Payment < ApplicationRecord
  enum status: %i[waiting_for_payment paid rejected]

  belongs_to :booking
  belongs_to :payer, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validate :true_user
  validate :true_amount
  validate :true_booking

  private

  def true_user
    booking.property.provider == recipient && booking.tenant == payer ||
      errors.add(:booking, 'failed role')
  end

  def true_amount
    booking.property.price *
      (booking.end_rent_at - booking.start_rent_at).to_i == amount ||
      errors.add(:amount, 'must be price property')
  end

  def true_booking
    booking_id == booking.id || errors.add(:booking, 'failed booking')
  end
end
