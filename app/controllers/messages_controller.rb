# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user

  def create
    @chat = policy_scope(Chat).find(params[:id])
    @message = Message.new(user: current_user, chat: @chat, **message_params)

    return render_errors(@message.errors.full_messages) unless @message.save

    render json: @message
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end
end
