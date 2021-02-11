# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :load_payment, only: %i[show pay reject]
  before_action :right_role_for_status_update, only: %i[pay reject]

  def index
    load_payments_by_role
    render json: @payments
  end

  def show
    render json: @payment
  end

  def pay
    check_status || (render json: @payment if @payment.paid!)
  end

  def reject
    check_status || (render json: @payment if @payment.rejected!)
  end

  private

  def check_status
    @payment.paid? &&
      @payment.errors.add(:payment, 'you paid') &&
      (render json: { errors: @payment.errors }, status: :unprocessable_entity)
  end

  def right_role_for_status_update
    if current_user.role != 'tenant'
      @payment.errors.add(:status, "provider can't change status payment")
      render_errors(@payment.errors)
    end
  end

  def load_payments_by_role
    case current_user.role
    when 'provider'
      @payments = current_user.received_payments
    when 'tenant'
      @payments = current_user.sent_payments
    else
      head(:not_found)
    end
  end

  def load_payment
    @payment = load_payments_by_role.find(params[:id])
  end
end
