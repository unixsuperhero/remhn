class CreateLocationAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :location_areas do |t|
      t.references :location, null: false, foreign_key: true
      t.references :area, null: false, foreign_key: true

      t.timestamps
    end
  end
end
