class CreateMonsterItems < ActiveRecord::Migration[7.0]
  def change
    create_table :monster_items do |t|
      t.references :monster, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :grade

      t.timestamps
    end
  end
end
