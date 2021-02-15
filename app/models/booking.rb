# frozen_string_literal: true

class Booking < ApplicationRecord
  paginates_per 10
  enum status: %i[waiting_for_confirm confirmed declined canceled]

  scope :by_property, ->(property_id) { where(property_id: property_id) }
  scope :reserved_in, lambda { |start_rent_at, end_rent_at|
    where('? < end_rent_at AND ? > start_rent_at', start_rent_at, end_rent_at)
  }

  belongs_to :tenant, class_name: 'User'
  belongs_to :property
  has_one :payment, dependent: :destroy
  has_one :chat, dependent: :destroy

  validate :end_date_is_after_start_date
  validate :free_date, on: :create

  def property_price_for_all_period
    property.price * (end_rent_at - start_rent_at).to_i
  end

  private

  def free_date
    Booking.by_property(property).reserved_in(start_rent_at, end_rent_at)
           .exists? && errors.add(:booking, 'date already taken')
  end

  def end_date_is_after_start_date
    end_rent_at < start_rent_at &&
      errors.add(:end_rent_at, 'cannot be before the start date')
    return if end_rent_at.blank? || start_rent_at.blank?
  end
end
