class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :rarity
      t.boolean :forest
      t.boolean :swamp
      t.boolean :dessert
      t.boolean :forest_outcrop
      t.boolean :swamp_outcrop
      t.boolean :dessert_outcrop

      t.timestamps
    end
  end
end
