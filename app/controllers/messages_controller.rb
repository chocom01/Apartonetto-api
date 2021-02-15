# frozen_string_literal: true

class MessagesController < ApplicationController
  after_action :add_unread_count, only: %i[create]
  before_action :authenticate_user

  def create
    @chat = policy_scope(Chat).find(params[:id])
    @message = Message.new(user: current_user, chat: @chat, **message_params)

    return render_errors(@message.errors) unless @message.save

    render json: @message
  end

  private

  def message_params
    params.require(:message).permit(:text)
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
