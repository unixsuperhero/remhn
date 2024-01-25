class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :terrain_name
      t.references :terrain, null: false

      t.timestamps
    end
  end
end
