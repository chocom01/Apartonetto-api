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

  get '/chats' do
    example_request 'Getting all chats of current user' do
      chats_hash = JSON.parse(response_body, symbolize_names: true)
      expect(chats_hash[0][:id]).to eq(chat.id)
      expect(chats_hash[0][:booking_id]).to eq(chat.booking_id)
      expect(chats_hash[0][:tenant_unread_messages_count])
        .to eq(chat.tenant_unread_messages_count)
      expect(chats_hash[0][:provider_unread_messages_count])
        .to eq(chat.provider_unread_messages_count)
      expect(chats_hash[0][:tenant_id]).to eq(chat.tenant_id)
      expect(chats_hash[0][:provider_id]).to eq(chat.provider_id)
      expect(status).to eq 200
    end
  end

  get '/chats/:id' do
    example_request 'Getting chat of current user by id' do
      chats_hash = JSON.parse(response_body, symbolize_names: true)
      expect(chats_hash[:id]).to eq(chat.id)
      expect(chats_hash[:booking_id]).to eq(chat.booking_id)
      expect(chats_hash[:tenant_unread_messages_count])
        .to eq(chat.tenant_unread_messages_count)
      expect(chats_hash[:provider_unread_messages_count])
        .to eq(chat.provider_unread_messages_count)
      expect(chats_hash[:tenant_id]).to eq(chat.tenant_id)
      expect(chats_hash[:provider_id]).to eq(chat.provider_id)
      expect(status).to eq 200
    end
  end

  get '/chats/:id/messages' do
    let!(:chat) { create(:chat) }
    let!(:message) { create(:message, chat: chat) }
    let!(:message1) { create(:message, chat: chat) }

    example 'Getting chat of current user by id' do
      expect(chat.reload.tenant_unread_messages_count).to eq(2)
      do_request
      expect(chat.reload.tenant_unread_messages_count).to eq(0)
      messages_hash = JSON.parse(response_body, symbolize_names: true)
      expect(messages_hash.pluck(:id))
        .to match_array([message.id, message1.id])

      expect(messages_hash.pluck(:user_id))
        .to match_array([message.user_id, message1.user_id])

      expect(messages_hash.pluck(:chat_id))
        .to match_array([message.chat_id, message1.chat_id])

      expect(messages_hash.pluck(:text))
        .to match_array([message.text, message1.text])
      expect(status).to eq 200
    end
  end
end
