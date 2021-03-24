# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :authenticate_user
  before_action :find_booking, only: %i[show cancel confirm decline]

  def index
    bookings = policy_scope(Booking).page(params[:page])
    render json: BookingBlueprint.render(bookings, view: :normal)
  end

  def show
    render json: BookingBlueprint.render(@booking, view: :normal)
  end

  def create
    authorize Booking
    result = Bookings::Create.new.call(booking_params, current_user.id)
    return render_errors(result.failure) unless result.success?

    render json: result.success
  end

  def cancel
    @booking.canceled!
    render json: BookingBlueprint.render(@booking, view: :normal)
  end

  def confirm
    @booking.confirmed! && @booking.payments.last.paid!
    render json: BookingBlueprint.render(@booking, view: :normal)
  end

  def decline
    @booking.declined!
    render json: BookingBlueprint.render(@booking, view: :normal)
  end

  private

  def booking_params
    params.require(:booking).permit(
      :property_id,
      :number_of_guests,
      :start_rent_at,
      :end_rent_at
    )
  end

  def find_booking
    authorize @booking = Booking.find(params[:id])
  end
end
