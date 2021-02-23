# frozen_string_literal: true

class AddAddressColumnToProperty < ActiveRecord::Migration[6.0]
  def change
    change_table(:properties) do |t|
      t.string :address
    end
  end
end
