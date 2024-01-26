class CreateEquipableStats < ActiveRecord::Migration[7.0]
  def change
    create_table :equipable_stats do |t|
      t.string :name
      t.integer :grade
      t.integer :sub_grade
      t.integer :atk
      t.integer :crit
      t.integer :elem
      t.integer :def
      t.boolean :forge
      t.references :equipable, null: false, foreign_key: true

      t.timestamps
    end
  end
end
