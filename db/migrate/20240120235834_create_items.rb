class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :rarity
      t.string :set_key
      t.string :set_subkey

      t.timestamps
    end
  end
end
