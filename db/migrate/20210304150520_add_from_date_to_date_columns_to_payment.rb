class AddFromDateToDateColumnsToPayment < ActiveRecord::Migration[6.0]
  def change
    change_table(:payments) do |t|
      t.date :from_date
      t.date :to_date
    end
  end
end
