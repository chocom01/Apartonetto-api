# frozen_string_literal: true

class CheckIfAcceptedWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(booking_id)
    booking = Booking.find(booking_id)
    return unless booking.waiting_for_confirm?

    booking.declined!
  end
end
