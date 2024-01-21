class CreateForgeItems < ActiveRecord::Migration[7.0]
  def change
    create_table :forge_items do |t|
      t.references :equipable, null: false, foreign_key: true
      t.references :level, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :qty

      t.timestamps
    end
  end
end
