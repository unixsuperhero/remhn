class CreateLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :levels do |t|
      t.references :equipable, null: false
      t.string :grade_number

      t.timestamps
    end
  end
end
