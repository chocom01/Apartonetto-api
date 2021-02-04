# frozen_string_literal: true

class BookingChangeColumns < ActiveRecord::Migration[6.0]
  def change
    change_column(:bookings, :start_rent_at, :date)
    change_column(:bookings, :end_rent_at, :date)
  end
end
