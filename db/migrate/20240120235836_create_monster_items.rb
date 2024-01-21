class CreateMonsterItems < ActiveRecord::Migration[7.0]
  def change
    create_table :monster_items do |t|
      t.references :monster, null: false
      t.references :item, null: false
      t.integer :grade

      t.timestamps
    end
  end
end
