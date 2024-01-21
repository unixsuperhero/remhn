class CreateSkillLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :skill_levels do |t|
      t.references :skill, null: false
      t.references :level, null: false
      t.references :equipable, null: false
      t.integer :power
      t.string :grade_number

      t.timestamps
    end
  end
end
