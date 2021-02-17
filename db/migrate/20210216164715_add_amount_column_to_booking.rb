class AddAmountColumnToBooking < ActiveRecord::Migration[6.0]
  def change
    change_table(:bookings) do |t|
      t.integer :amount_for_period
    end
  end
end
