class CreateTerrains < ActiveRecord::Migration[7.0]
  def change
    create_table :terrains do |t|
      t.string :name

      t.timestamps
    end
  end
end
