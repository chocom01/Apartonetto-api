# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :find_payment, only: %i[show pay reject]
  before_action :authenticate_user

  def index
    payments = policy_scope(Payment)
    render json: payments
  end

  def show
    render json: @payment
  end

  def pay
    if @payment.from_date == @payment.booking.start_rent_at
      @payment.money_reservation! && @payment.booking.waiting_for_confirm!
    else
      @payment.paid!
    end
    render json: @payment
  end

  def reject
    @payment.rejected!
    render json: @payment
  end

  private

  def find_payment
    authorize @payment = Payment.find(params[:id])
  end
end
