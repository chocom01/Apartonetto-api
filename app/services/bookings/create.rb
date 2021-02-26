require 'dry/monads'

module Bookings
  class Create
    include Dry::Monads[:result]

    def call(booking_params, current_user_id)
      booking = Booking.new(tenant_id: current_user_id, **booking_params)
      booking.amount_for_period = booking.property_price_for_all_period
      payment = Payment.new(
        payer_id: current_user_id,
        amount: booking.amount_for_period,
        booking: booking,
        recipient: booking.property.provider,
        service: 'Paypal',
        info: "Payment for #{booking.property.name.downcase}"
      )
      chat = Chat.new(
        tenant_id: current_user_id,
        booking: booking,
        provider: booking.property.provider
      )
      begin
        booking.transaction do
          booking.save! && payment.save! && chat.save!
          CheckIfAcceptedWorker.perform_in(8.hours, booking.id)
        end
        Success([booking, payment, chat])
      rescue ActiveRecord::RecordInvalid
        Failure([booking.errors, payment.errors, chat.errors])
      end
    end
  end
end
