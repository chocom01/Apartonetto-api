# frozen_string_literal: true

class ChatsController < ApplicationController
  before_action :find_chat, only: %i[show messages]
  after_action :read_messages, only: %i[messages]
  before_action :authenticate_user

  def index
    chats = policy_scope(Chat)
    render json: ChatBlueprint.render(chats, view: :normal)
  end

  def show
    render json: ChatBlueprint.render(@chat, view: :normal)
  end

  def messages
    result = @chat.messages.page(params[:page]).per(10)
    render json: MessageBlueprint.render(result)
  end

  private

  def find_chat
    authorize @chat = Chat.find(params[:id])
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
