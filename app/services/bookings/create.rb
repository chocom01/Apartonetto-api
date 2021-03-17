# frozen_string_literal: true

require 'dry/monads'

module Bookings
  class Create
    include Dry::Monads[:result]

    def call(booking_params, current_user_id)
      @booking = Booking.new(tenant_id: current_user_id, **booking_params)
      @payment = Payment.new(status: 'waiting_for_payment', **payment_params)
      chat = Chat.new(chat_params)

      @start_booking = @booking.start_rent_at
      @end_booking = @booking.end_rent_at
      @price = @booking.property.price

      begin
        @booking.transaction do
          payment_creating
          @booking.save! && @payment.save! && chat.save!
          CheckIfAcceptedWorker.perform_in(8.hours, @booking.id)
        end
        Success([@booking, @payment, chat])
      rescue ActiveRecord::RecordInvalid
        Failure([@booking.errors, @payment.errors, chat.errors])
      end
    end

    private

    def payment_params
      { payer_id: @booking.tenant_id,
        booking: @booking,
        recipient: @booking.property.provider,
        service: 'Paypal',
        info: "Payment for #{@booking.property.name.downcase}" }
    end

    def chat_params
      { tenant_id: @booking.tenant_id,
        booking: @booking,
        provider: @booking.property.provider }
    end

    def payment_creating
      if small_period? && (@end_booking - @start_booking).to_i < 62
        @payment.amount = @booking.property_price_for_all_period
        @payment.from_date = @start_booking
        @payment.to_date = @end_booking
      else
        first_payment && monthly_payments
        last_payment if @end_booking.day > 10
      end
    end

    def small_period?
      @end_booking < @start_booking.next_month - 1.day ||
        (@start_booking.next_month.month == @end_booking.month) ||
        (@start_booking.next_month(2).month == @end_booking.month &&
          @start_booking.end_of_month.day - @start_booking.day < 10 &&
          @end_booking.day <= 10)
    end

    def first_payment
      if @start_booking == @start_booking.beginning_of_month
        @payment.amount = (@start_booking.end_of_month - @start_booking).to_i * @price
      elsif @start_booking == @start_booking.end_of_month
        @payment.amount = @price * @start_booking.next_month.end_of_month.day
      elsif @start_booking.end_of_month.day - @start_booking.day < 10
        days = @start_booking.end_of_month.day - @start_booking.day
        @payment.amount = @price * (days + @start_booking.next_month.end_of_month.day)
      else
        days = @start_booking.end_of_month.day - @start_booking.day
        @payment.amount = @price * days
      end
      @payment.to_date = (@start_booking + @payment.amount / @price)
      @payment.from_date = @start_booking
    end

    def monthly_payments
      comparative_date = @payment.to_date.next_day
      while @end_booking.month > comparative_date.month || @end_booking.year > comparative_date.year
        payment = Payment.new(payment_params)
        days = comparative_date.end_of_month.day
        payment.amount = days * @price
        payment.from_date = comparative_date
        payment.to_date = comparative_date.end_of_month
        comparative_date += 1.month
        if comparative_date.month == @end_booking.month && @end_booking.day <= 10 && comparative_date.year == @end_booking.year
          payment.amount += @end_booking.day * @price
          payment.to_date = @end_booking
        end
        payment.save
      end
    end

    def last_payment
      last_payment = Payment.new(**payment_params)
      last_payment.amount = @end_booking.day * @price
      last_payment.from_date = @end_booking.beginning_of_month
      last_payment.to_date = @end_booking
      last_payment.save
    end
  end
end
