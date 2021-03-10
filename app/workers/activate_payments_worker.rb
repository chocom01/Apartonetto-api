# frozen_string_literal: true

require 'sidekiq-scheduler'

class ActivatePaymentsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    payments_for_next_month = Payment.where(status: 'draft').where(
      'from_date = :next_month_first_day',
      next_month_first_day: Date.current.next_month.beginning_of_month
    )
    payments_for_next_month.map do |payment|
      payment.waiting_for_payment!
    end
  end
end
