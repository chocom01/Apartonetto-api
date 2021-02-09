# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :load_booking, only: %i[show update cancel confirm declin]

  def index
    load_role
    render json: booking # .page(params[:page])
  end

  def show
    render json: booking
  end

  def create
    creating_params
    return render_errors(booking.errors) unless
     booking.save && payment.save && chat.save

    render json: booking, include: %i[payment chat]
  end

  def update
    return render_errors(booking.errors) unless booking.update(edit_params)

    render json: booking
  end

  def cancel
    booking.errors.add(:status, "provider can't change status to canceled")
    return render_errors(booking.errors) unless current_user.role == 'tenant'

    render json: booking if booking.canceled!
  end

  def confirm
    booking.errors.add(:status, "tenant can't change status to confirmed")
    return render_errors(booking.errors) unless current_user.role == 'provider'

    render json: booking if booking.confirmed!
  end

  def declin
    booking.errors.add(:status, "tenant can't change status to declined")
    return render_errors(booking.errors) unless current_user.role == 'provider'

    render json: booking if booking.declined!
  end

  private

  attr_reader :booking, :payment, :chat

  def booking_params
    params.require(:booking).permit(:property_id,
                                    :start_rent_at, :end_rent_at)
  end

  def payment_params
    { booking: booking, payer: current_user, amount: booking.property_price,
      recipient: booking.property.provider, service: 'Paypal',
      info: "payment for #{booking.property.name.downcase}" }
  end

  def creating_params
    @booking = Booking.new(tenant: current_user, **booking_params)
    @payment = Payment.new(payment_params)
    @chat = Chat.new({ booking: booking, tenant: current_user,
                       provider: booking.property.provider })
  end

  def edit_params
    params.require(:booking).permit(:start_rent_at, :end_rent_at)
  end

  def load_booking
    @booking = load_role.find_by(id: params[:id]) || head(:not_found)
  end

  def load_role
    case current_user.role
    when 'provider'
      @booking = Booking.where(current_user.properties.include?(:property))
    when 'tenant'
      @booking = Booking.where(tenant: current_user)
    else
      head(:not_found)
    end
  end
end
