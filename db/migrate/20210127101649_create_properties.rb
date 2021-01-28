# frozen_string_literal: true

class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.belongs_to :provider
      t.string :name
      t.string :location
      t.text :description
      t.integer :price

      t.timestamps
    end
  end
end
