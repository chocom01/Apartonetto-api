# frozen_string_literal: true

class AddGuestsCapacityColumnToProperty < ActiveRecord::Migration[6.0]
  def change
    change_table(:properties) do |t|
      t.integer :guests_capacity
    end
  end
end
