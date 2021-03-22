# frozen_string_literal: true

class RemoveLocationFromProperties < ActiveRecord::Migration[6.0]
  def change
    remove_column :properties, :location, :string
  end
end
