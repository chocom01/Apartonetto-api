# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :booking
  belongs_to :tenant, class_name: 'User'
  belongs_to :provider, class_name: 'User'
  has_many :messages
end
