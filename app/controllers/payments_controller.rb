# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :find_payment, only: %i[show pay reject]
  before_action :authenticate_user

  def index
    payments = policy_scope(Payment)
    render json: PaymentBlueprint.render(payments)
  end

  def show
    render json: PaymentBlueprint.render(@payment)
  end

  def pay
    if @payment.from_date == @payment.booking.start_rent_at
      @payment.money_reservation! && @payment.booking.waiting_for_confirm!
    else
      @payment.paid!
    end
    render json: PaymentBlueprint.render(@payment)
  end

  def reject
    @payment.rejected!
    render json: PaymentBlueprint.render(@payment)
  end

  private

  def find_payment
    authorize @payment = Payment.find(params[:id])
  end
end
