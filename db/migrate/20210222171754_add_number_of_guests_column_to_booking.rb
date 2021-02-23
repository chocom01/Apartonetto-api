# frozen_string_literal: true

class AddNumberOfGuestsColumnToBooking < ActiveRecord::Migration[6.0]
  def change
    change_table(:bookings) do |t|
      t.integer :number_of_guests
    end
  end
end
