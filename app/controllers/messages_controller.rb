# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :chat_params, only: %i[create]

  def create
    return render_errors(message.errors) unless message.save && add_unread_count

    render json: message
  end

  private

  attr_reader :message, :chat

  def chat_load
    case current_user.role
    when 'tenant'
      @chat = current_user.tenant_chats.find_by({ id: params[:id] }) ||
              head(:not_found)
    when 'provider'
      @chat = current_user.provider_chats.find_by({ id: params[:id] }) ||
              head(:not_found)
    end
  end

  def chat_params
    chat_params = params.require(:message).permit(:text)
    @message = Message.new(user: current_user, chat: chat_load, **chat_params)
  end

  def add_unread_count
    chat_load
    case current_user.role
    when 'tenant'
      chat.update(provider_unread_messages_count:
         (chat.provider_unread_messages_count + 1))
    when 'provider'
      chat.update(tenant_unread_messages_count:
         (chat.tenant_unread_messages_count + 1))
    end
  end
end
