class CreateSkillLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :skill_levels do |t|
      t.references :skill, null: false, foreign_key: true
      t.references :level, null: false, foreign_key: true
      t.references :equipable, null: false, foreign_key: true
      t.integer :power

      t.timestamps
    end
  end
end
