# frozen_string_literal: true

class CreateChats < ActiveRecord::Migration[6.0]
  def change
    create_table :chats do |t|
      t.belongs_to :booking
      t.integer :tenant_unread_messages_count, default: 0
      t.integer :provider_unread_messages_count, default: 0

      t.timestamps
    end
  end
end
