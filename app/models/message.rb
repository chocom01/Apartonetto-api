# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat
end
