class CreateMonsterWeaknesses < ActiveRecord::Migration[7.0]
  def change
    create_table :monster_weaknesses do |t|
      t.references :monster, null: false, foreign_key: true
      t.references :element, null: false, foreign_key: true

      t.timestamps
    end
  end
end
