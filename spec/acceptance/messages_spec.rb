# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Chats' do
  header 'Authorization', :auth_token
  let!(:auth_token) do
    "Bearer #{Knock::AuthToken.new(payload:
    { sub: chat.tenant.id }).token}"
  end

  let!(:chat) { create(:chat) }
  let(:id) { chat.id }

  post '/chats/:id/messages' do
    with_options scope: :message do
      parameter :chat_id, 'Message chat'
      parameter :text, 'Message text'
    end

    let!(:chat) { create(:chat) }

    let(:chat_id) { chat.id }
    let(:text) { 'some new text' }

    example 'Getting chat of current user by id' do
      expect(chat.reload.provider_unread_messages_count).to eq(0)
      expect { do_request }.to change { Message.count }
        .by(1).and change { chat.reload.provider_unread_messages_count }.by(1)
      message = Message.last
      expect(message.chat_id).to eq(chat_id)
      expect(message.user_id).to eq(chat.tenant_id || chat.provider_id)
      expect(message.text).to eq(text)
      expect(status).to eq 200
    end
  end
end
