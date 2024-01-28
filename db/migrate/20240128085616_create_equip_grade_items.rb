class CreateEquipGradeItems < ActiveRecord::Migration[7.0]
  def change
    create_table :equip_grade_items do |t|
      t.references :equip, null: false, foreign_key: true
      t.references :equip_grade, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :qty

      t.timestamps
    end
  end
end
