# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.belongs_to :payment
      t.belongs_to :tenant
      t.belongs_to :property
      t.column :status, :integer, default: 0
      t.datetime :start_rent_at
      t.datetime :end_rent_at

      t.timestamps
    end
  end
end
