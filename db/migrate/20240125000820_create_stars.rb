class CreateStars < ActiveRecord::Migration[7.0]
  def change
    create_table :stars do |t|
      t.integer :stars
      t.references :monster, null: false
      t.integer :hp
      t.integer :raid_hp

      t.timestamps
    end
  end
end
