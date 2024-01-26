class CreateItemStats < ActiveRecord::Migration[7.0]
  def change
    create_table :item_stats do |t|
      t.references :item, null: false
      t.references :equipable_stat, null: false
      t.references :equipable, null: false
      t.references :monster, null: false
      t.integer :grade
      t.integer :sub_grade
      t.integer :qty

      t.timestamps
    end
  end
end
