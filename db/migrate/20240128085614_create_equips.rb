class CreateEquips < ActiveRecord::Migration[7.0]
  def change
    create_table :equips do |t|
      t.string :name
      t.string :set_key
      t.string :set_name
      t.integer :equip_type
      t.integer :equip_subtype
      t.integer :unlock
      t.boolean :starter
      t.boolean :event_only
      t.string :atk_scheme
      t.string :crit_scheme
      t.string :elem_scheme
      t.string :def_scheme
      t.string :f_code
      t.string :g_code
      t.string :h_code
      t.integer :alt_monster_id
      t.references :monster, null: true
      t.references :element, null: true

      t.timestamps
    end
  end
end
