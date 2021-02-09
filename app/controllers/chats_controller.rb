# frozen_string_literal: true

class ChatsController < ApplicationController
  before_action :find_chat, only: %i[show messages]
  after_action :read_messages, only: %i[messages]

  def show
    render json: @chat
  end

  def messages
    render json: @chat.messages
  end

  private

  def find_chat
    @chat =
      case current_user.role
      when 'tenant'
        current_user.tenant_chats.find(params[:id])
      when 'provider'
        current_user.provider_chats.find(params[:id])
      end
  end

  def read_messages
    case current_user.role
    when 'tenant'
      @chat.update(tenant_unread_messages_count: 0)
    when 'provider'
      @chat.update(provider_unread_messages_count: 0)
    end
  end
end
