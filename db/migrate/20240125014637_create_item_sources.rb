class CreateItemSources < ActiveRecord::Migration[7.0]
  def change
    create_table :item_sources do |t|
      t.references :item, null: false, foreign_key: true
      t.references :source, polymorphic: true, null: false
      t.integer :stars

      t.timestamps
    end
  end
end
