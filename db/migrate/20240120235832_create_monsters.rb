class CreateMonsters < ActiveRecord::Migration[7.0]
  def change
    create_table :monsters do |t|
      t.string :name
      t.integer :size
      t.boolean :swamp
      t.boolean :dessert
      t.boolean :forest

      t.timestamps
    end
  end
end
