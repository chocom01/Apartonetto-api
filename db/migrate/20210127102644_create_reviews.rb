# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.belongs_to :reviewer
      t.references :reviewable, polymorphic: true
      t.integer :rate
      t.text :text

      t.timestamps
    end
  end
end
