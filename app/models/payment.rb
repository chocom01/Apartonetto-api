# frozen_string_literal: true

class Payment < ApplicationRecord
  enum status: %i[waiting_for_payment paid rejected]

  belongs_to :booking
  belongs_to :tenant, class_name: 'User', foreign_key: 'user_id'
  belongs_to :provider, class_name: 'User', foreign_key: 'user_id'
end
