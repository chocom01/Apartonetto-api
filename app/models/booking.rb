# frozen_string_literal: true

class Booking < ApplicationRecord
  paginates_per 10
  enum status: {
    payment_waiting: 0,
    waiting_for_confirm: 1,
    confirmed: 2,
    declined: 3,
    canceled: 4
  }

  belongs_to :tenant, class_name: 'User'
  belongs_to :property
  has_many :payments, dependent: :destroy
  has_one :chat, dependent: :destroy

  validate :period_is_free,
           :acceptable_minimum_days,
           on: :create,
           if: -> { start_rent_at && end_rent_at }
  validate :allowable_number_of_guests, on: :create
  validates :number_of_guests, numericality: { other_than: 0 }

  scope :weighted, -> {
    where(status: %i[confirmed waiting_for_confirm payment_waiting])
  }
  scope :by_property, ->(property_id) { where(property_id: property_id) }
  scope :reserved_in, lambda { |start_rent_at, end_rent_at|
    where(':initial_date < end_rent_at AND :finale_date > start_rent_at',
          { initial_date: start_rent_at, finale_date: end_rent_at })
  }
  before_create :property_price_for_all_period

  def property_price_for_all_period
    self.amount_for_period = property.price * nights_number
  end

  private

  def nights_number
    (end_rent_at - start_rent_at).to_i
  end

  def period_is_free
    return unless Booking.by_property(property).weighted
                         .reserved_in(start_rent_at, end_rent_at).exists?

    errors.add(:booking, 'date already taken')
  end

  def acceptable_minimum_days
    return if nights_number >= property.minimum_days

    errors.add(:end_rent_at, "Minimum #{property.minimum_days} days")
  end

  def allowable_number_of_guests
    return if number_of_guests <= property.guests_capacity

    errors.add(
      :number_of_guests, "this apartment doesn't accommodate so many guests"
    )
  end
end
