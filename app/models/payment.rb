# frozen_string_literal: true

class Payment < ApplicationRecord
  enum status: {
    draft: 0,
    waiting_for_payment: 1,
    paid: 2,
    rejected: 3,
    overdue: 4,
    money_reservation: 5
  }

  belongs_to :booking
  belongs_to :payer, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
end
