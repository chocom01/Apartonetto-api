# frozen_string_literal: true

class CheckIfPaidWorker
  include Sidekiq::Worker

  def perform(payment_id)
    payment = Payment.find(payment_id)
    return unless payment.waiting_for_payment? || payment.rejected?

    payment.overdue!
  end
end
