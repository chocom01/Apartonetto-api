class AddColumnsToChat < ActiveRecord::Migration[6.0]
  def change
    change_table(:chats) do |t|
      t.belongs_to :tenant
      t.belongs_to :provider
    end
  end
end
