class CreateEquips < ActiveRecord::Migration[7.0]
  def change
    create_table :equips do |t|
      t.string :name
      t.string :set_name
      t.integer :equip_type
      t.integer :equip_subtype
      t.integer :unlock
      t.boolean :starter
      t.boolean :event_only
      t.string :atk_scheme
      t.string :crit_scheme
      t.string :elem_scheme
      t.references :monster, null: false, foreign_key: true
      t.references :element, null: false, foreign_key: true

      t.timestamps
    end
  end
end
