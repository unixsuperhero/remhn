class CreateEquipables < ActiveRecord::Migration[7.0]
  def change
    create_table :equipables do |t|
      t.string :key
      t.string :set_name
      t.string :name
      t.integer :group
      t.integer :sub_group
      t.integer :unlock_grade
      t.boolean :starter
      t.boolean :event_only
      t.string :atk_scheme
      t.string :crit_scheme
      t.string :elem_scheme
      t.string :def_scheme
      t.references :element, null: true
      t.references :monster, null: true

      t.timestamps
    end
  end
end
