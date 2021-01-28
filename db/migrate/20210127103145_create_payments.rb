# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.belongs_to :tenant
      t.belongs_to :provider
      t.belongs_to :booking
      t.string :service
      t.string :info
      t.integer :amount
      t.column :status, :integer, default: 0
      t.timestamps
    end
  end
end
