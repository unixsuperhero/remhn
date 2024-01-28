class CreateMonsters < ActiveRecord::Migration[7.0]
  def change
    create_table :monsters do |t|
      t.string :name
      t.string :key
      t.integer :size

      t.timestamps
    end
  end
end
