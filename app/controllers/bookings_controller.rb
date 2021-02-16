# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :load_booking, only: %i[show cancel confirm declin]
  before_action :authenticate_user

  def index
    bookings = policy_scope(Booking)
    render json: bookings.page(params[:page])
  end

  def show
    render json: @booking
  end

  def create
    @booking = authorize Booking.new(tenant: current_user, **booking_params)
    @payment = Payment.new(payment_params)
    @chat = Chat.new(chat_params)
    unless @booking.save && @payment.save && @chat.save
      return render_errors(@booking.errors)
    end
    render json: { booking: @booking, payment: @payment, chat: @chat }
  end

  def cancel
    @booking.canceled!
    render json: @booking
  end

  def confirm
    @booking.confirmed!
    render json: @booking
  end

  def decline
    @booking.declined!
    render json: @booking
  end

  private

  def booking_params
    params.require(:booking).permit(
      :property_id,
      :start_rent_at,
      :end_rent_at
    )
  end

  def payment_params
    { booking: @booking,
      payer: current_user,
      amount: @booking.property_price_for_all_period,
      recipient: @booking.property.provider,
      service: 'Paypal',
      info: "payment for #{@booking.property.name.downcase}" }
  end

  def chat_params
    { booking: @booking,
      tenant: current_user,
      provider: @booking.property.provider }
  end

  def load_booking
    authorize @booking = Booking.find(params[:id])
  end
end
