class CreateEquipGrades < ActiveRecord::Migration[7.0]
  def change
    create_table :equip_grades do |t|
      t.string :name
      t.integer :grade
      t.integer :sub_grade
      t.integer :atk_power
      t.integer :crit_power
      t.integer :elem_power
      t.integer :def_power
      t.boolean :forge
      t.references :equip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
