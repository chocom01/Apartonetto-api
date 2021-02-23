# frozen_string_literal: true

class AddRoomsCountColumnToProperty < ActiveRecord::Migration[6.0]
  def change
    change_table(:properties) do |t|
      t.integer :rooms_count
    end
  end
end
