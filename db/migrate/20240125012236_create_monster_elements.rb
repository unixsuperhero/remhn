class CreateMonsterElements < ActiveRecord::Migration[7.0]
  def change
    create_table :monster_elements do |t|
      t.references :monster, null: false
      t.references :element, null: false

      t.timestamps
    end
  end
end
