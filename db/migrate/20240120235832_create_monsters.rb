class CreateMonsters < ActiveRecord::Migration[7.0]
  def change
    create_table :monsters do |t|
      t.string :name
      t.integer :size
      t.boolean :swamp
      t.boolean :desert
      t.boolean :forest
      t.boolean :fire_weak
      t.boolean :water_weak
      t.boolean :thunder_weak
      t.boolean :dragon_weak
      t.boolean :ice_weak
      t.integer :poison
      t.integer :paralysis
      t.integer :stun
      t.integer :sleep

      t.timestamps
    end
  end
end
