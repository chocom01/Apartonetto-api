# frozen_string_literal: true

class MessagesController < ApplicationController
  after_action :add_unread_count, only: %i[create]

  def create
    new_message_with_params
    return render_errors(@message.errors) unless @message.save

    render json: @message
  end

  private

  def new_message_with_params
    @chat = current_user.tenant_chats.find(params[:id]) if current_user.tenant?
    @chat = current_user.provider_chats.find(params[:id]) if current_user.provider?
    message_params = params.require(:message).permit(:text)
    @message = Message.new(user: current_user, chat: @chat, **message_params)
  end

  def add_unread_count
    case current_user.role
    when 'tenant'
      @chat.update(provider_unread_messages_count:
         (@chat.provider_unread_messages_count + 1))
    when 'provider'
      @chat.update(tenant_unread_messages_count:
         (@chat.tenant_unread_messages_count + 1))
    end
  end
end
