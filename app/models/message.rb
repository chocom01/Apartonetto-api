# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  validates :text, length: { in: 1..50 }

  after_create :increment_unread_count_in_chat

  private

  def increment_unread_count_in_chat
    role = user.provider? ? :tenant : :provider
    Chat.increment_counter("#{role}_unread_messages_count", chat_id)
  end
end
