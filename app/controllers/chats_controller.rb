

class ChatsController < ApplicationController
  before_action :for_show, only: %i[show]
  before_action :read_messages, only: %i[messages]

  def show
    render json: chat
  end

  def messages
    render json: message
  end

  private

  attr_reader :chat, :message

  def for_show
    case current_user.role
    when 'tenant'
      @chat = current_user.tenant_chats.find_by({ id: params[:id] }) ||
              head(:not_found)
    when 'provider'
      @chat = current_user.provider_chats.find_by({ id: params[:id] }) ||
              head(:not_found)
    end
  end

  def read_messages
    for_show
    case current_user.role
    when 'tenant'
      @message = chat.update(tenant_unread_messages_count: 0) && chat.messages
    when 'provider'
      @message = chat.update(provider_unread_messages_count: 0) && chat.messages
    end
  end
end
