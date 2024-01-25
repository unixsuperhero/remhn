class CreateMonsters < ActiveRecord::Migration[7.0]
  def change
    create_table :monsters do |t|
      t.string :name
      t.integer :size
      t.integer :poison
      t.integer :paralysis
      t.integer :stun
      t.integer :sleep

      t.timestamps
    end
  end
end
