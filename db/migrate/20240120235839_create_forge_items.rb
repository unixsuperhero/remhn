class CreateForgeItems < ActiveRecord::Migration[7.0]
  def change
    create_table :forge_items do |t|
      t.references :equipable, null: false
      t.references :level, null: false
      t.references :item, null: false
      t.integer :qty

      t.timestamps
    end
  end
end
