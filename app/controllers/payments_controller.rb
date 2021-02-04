# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :load_payment, only: %i[show pay reject]
  before_action :load_role, only: %i[index]
  before_action :true_role, only: %i[pay reject]

  def index
    render json: payment
  end

  def show
    render json: payment
  end

  def pay
    if payment.waiting_for_payment? || payment.rejected?
      render json: payment if payment.paid!
    else
      payment.errors.add(:payment, 'you already paid')
      render_errors(payment.errors)
    end
  end

  def reject
    if payment.waiting_for_payment? || payment.rejected?
      render json: payment if payment.rejected!
    else
      payment.errors.add(:status, 'paid')
      render_errors(payment.errors)
    end
  end

  private

  attr_reader :payment

  def true_role
    if current_user.role != 'tenant'
      payment.errors.add(:status, "provider can't change status payment")
      render_errors(payment.errors)
    end
  end

  def load_role
    case current_user.role
    when 'provider'
      @payment = current_user.received_payments
    when 'tenant'
      @payment = current_user.sent_payments
    else
      head(:not_found)
    end
  end

  def load_payment
    @payment = load_role.find_by(id: params[:id]) || head(:not_found)
  end
end
