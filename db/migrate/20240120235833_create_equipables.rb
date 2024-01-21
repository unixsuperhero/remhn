class CreateEquipables < ActiveRecord::Migration[7.0]
  def change
    create_table :equipables do |t|
      t.integer :group
      t.integer :subgroup
      t.references :monster, null: true

      t.timestamps
    end
  end
end
