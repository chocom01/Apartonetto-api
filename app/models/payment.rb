# frozen_string_literal: true

class Payment < ApplicationRecord
  enum status: { waiting_for_payment: 0, paid: 1, rejected: 2 }

  belongs_to :booking
  belongs_to :payer, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
end
