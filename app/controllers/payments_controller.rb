# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :load_payment, only: %i[show pay reject]
  before_action :authenticate_user

  def index
    payments = policy_scope(Payment)
    render json: payments
  end

  def show
    render json: @payment
  end

  def pay
    @payment.paid!
    render json: @payment
  end

  def reject
    @payment.rejected!
    render json: @payment
  end

  private

  def load_payment
    authorize @payment = Payment.find(params[:id])
  end
end
