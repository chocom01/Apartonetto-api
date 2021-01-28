# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :booking
  has_many :messages
end
