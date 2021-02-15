# frozen_string_literal: true

class Payment < ApplicationRecord
  enum status: %i[waiting_for_payment paid rejected]

  belongs_to :booking
  belongs_to :payer, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
end
