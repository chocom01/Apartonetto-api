# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  validates :text, length: { in: 1..50 }
end
