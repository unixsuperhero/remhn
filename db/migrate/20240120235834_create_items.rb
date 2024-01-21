class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.boolean :swamp
      t.boolean :swamp_outcrop
      t.boolean :dessert
      t.boolean :dessert_outcrop
      t.boolean :forest
      t.boolean :forest_outcrop

      t.timestamps
    end
  end
end
