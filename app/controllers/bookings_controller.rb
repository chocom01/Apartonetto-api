# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :load_booking, only: %i[show cancel confirm declin]

  def index
    load_bookings_by_role
    render json: @bookings.page(params[:page])
  end

  def show
    render json: @booking
  end

  def create
    new_booking_payment_chat
    return render_errors(@booking.errors) unless
     @booking.save && @payment.save && @chat.save

    # CheckIfAcceptedWorker.set(wait: 8.hour).perform_later
    # CheckIfAcceptedWorker.perform_in(1.second.from_now, booking.id)
    render json: { booking: @booking, payment: @payment, chat: @chat }
  end

  def cancel
    @booking.errors.add(:status, "provider can't change status to canceled")
    return render_errors(@booking.errors) unless current_user.role == 'tenant'

    render json: @booking if @booking.canceled!
  end

  def confirm
    @booking.errors.add(:status, "tenant can't change status to confirmed")
    return render_errors(booking.errors) unless current_user.role == 'provider'

    render json: @booking if @booking.confirmed!
  end

  def declin
    @booking.errors.add(:status, "tenant can't change status to declined")
    return render_errors(@booking.errors) unless current_user.role == 'provider'

    render json: @booking if @booking.declined!
  end

  private

  def booking_params
    params.require(:booking).permit(:property_id,
                                    :start_rent_at, :end_rent_at)
  end

  def payment_params
    { booking: @booking, payer: current_user,
      amount: @booking.property_price_for_all_period,
      recipient: @booking.property.provider, service: 'Paypal',
      info: "payment for #{@booking.property.name.downcase}" }
  end

  def new_booking_payment_chat
    @booking = Booking.new(tenant: current_user, **booking_params)
    @payment = Payment.new(payment_params)
    @chat = Chat.new({ booking: @booking, tenant: current_user,
                       provider: @booking.property.provider })
  end

  def load_booking
    @booking = load_bookings_by_role.find(params[:id])
  end

  def load_bookings_by_role
    @bookings =
      case current_user.role
      when 'provider'
        Booking.where(current_user.properties.include?(:property))
      when 'tenant'
        Booking.where(tenant: current_user)
      else
        head(:not_found)
      end
  end
end
