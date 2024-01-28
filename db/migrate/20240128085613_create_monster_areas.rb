class CreateMonsterAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :monster_areas do |t|
      t.references :monster, null: false, foreign_key: true
      t.references :area, null: false, foreign_key: true

      t.timestamps
    end
  end
end
