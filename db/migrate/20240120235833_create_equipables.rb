class CreateEquipables < ActiveRecord::Migration[7.0]
  def change
    create_table :equipables do |t|
      t.string :key
      t.string :name
      t.integer :group
      t.integer :subgroup
      t.integer :power
      t.integer :affinity
      t.integer :element_power
      t.integer :grade
      t.references :element, null: true
      t.references :monster, null: true

      t.timestamps
    end
  end
end
