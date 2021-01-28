# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.belongs_to :user
      t.belongs_to :chat
      t.text :text

      t.timestamps
    end
  end
end
