class CreateItemSets < ActiveRecord::Migration[7.0]
  def change
    create_table :item_sets do |t|
      t.references :item, null: false, foreign_key: true
      t.string :set_key
      t.string :set_subkey

      t.timestamps
    end
  end
end
