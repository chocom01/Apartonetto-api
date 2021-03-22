# frozen_string_literal: true

class AddCoordinateColumnsToProperties < ActiveRecord::Migration[6.0]
  def change
    change_table(:properties) do |t|
      t.float :longitude
      t.float :latitude
    end
  end
end
