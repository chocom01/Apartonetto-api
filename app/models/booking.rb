# frozen_string_literal: true

class Booking < ApplicationRecord
  paginates_per 10
  enum status: {
    waiting_for_confirm: 0,
    confirmed: 1,
    declined: 2,
    canceled: 3
  }

  belongs_to :tenant, class_name: 'User'
  belongs_to :property
  has_one :payment, dependent: :destroy
  has_one :chat, dependent: :destroy

  validate :period_is_free,
           :end_date_is_after_start_date,
           on: :create,
           if: -> { start_rent_at && end_rent_at }
  validate :allowable_number_of_guests, on: :create
  validates :number_of_guests, numericality: { other_than: 0 }

  scope :weighted, -> { where(status: %i[confirmed waiting_for_confirm]) }
  scope :by_property, ->(property_id) { where(property_id: property_id) }
  scope :reserved_in, lambda { |start_rent_at, end_rent_at|
    where(':initial_date < end_rent_at AND :finale_date > start_rent_at',
          { initial_date: start_rent_at, finale_date: end_rent_at })
  }

  def property_price_for_all_period
    property.price * (end_rent_at - start_rent_at).to_i
  end

  private

  def period_is_free
    return unless Booking.by_property(property).weighted
                         .reserved_in(start_rent_at, end_rent_at).exists?

    errors.add(:booking, 'date already taken')
  end

  def end_date_is_after_start_date
    return if end_rent_at > start_rent_at

    errors.add(:end_rent_at, 'cannot be before the start date')
  end

  def allowable_number_of_guests
    return if number_of_guests <= property.guests_capacity

    errors.add(
      :number_of_guests, "this apartment doesn't accommodate so many guests"
    )
  end
end
