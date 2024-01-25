class CreateMonsterTerrains < ActiveRecord::Migration[7.0]
  def change
    create_table :monster_terrains do |t|
      t.references :monster, null: false
      t.references :terrain, null: false

      t.timestamps
    end
  end
end
