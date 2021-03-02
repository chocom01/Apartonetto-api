# frozen_string_literal: true

class AddMinimumDaysToProperty < ActiveRecord::Migration[6.0]
  def change
    change_table(:properties) do |t|
      t.integer :minimum_days
    end
  end
end
