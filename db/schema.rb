# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_01_28_085617) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "elements", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equip_grade_items", force: :cascade do |t|
    t.bigint "equip_id", null: false
    t.bigint "equip_grade_id", null: false
    t.bigint "item_id", null: false
    t.integer "qty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equip_grade_id"], name: "index_equip_grade_items_on_equip_grade_id"
    t.index ["equip_id"], name: "index_equip_grade_items_on_equip_id"
    t.index ["item_id"], name: "index_equip_grade_items_on_item_id"
  end

  create_table "equip_grades", force: :cascade do |t|
    t.string "name"
    t.integer "grade"
    t.integer "sub_grade"
    t.integer "atk_power"
    t.integer "crit_power"
    t.integer "elem_power"
    t.integer "def_power"
    t.boolean "forge"
    t.bigint "equip_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equip_id"], name: "index_equip_grades_on_equip_id"
  end

  create_table "equips", force: :cascade do |t|
    t.string "name"
    t.string "set_key"
    t.string "set_name"
    t.integer "equip_type"
    t.integer "equip_subtype"
    t.integer "unlock"
    t.boolean "starter"
    t.boolean "event_only"
    t.string "atk_scheme"
    t.string "crit_scheme"
    t.string "elem_scheme"
    t.string "def_scheme"
    t.string "f_code"
    t.string "g_code"
    t.string "h_code"
    t.integer "alt_monster_id"
    t.bigint "monster_id"
    t.bigint "element_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_equips_on_element_id"
    t.index ["monster_id"], name: "index_equips_on_monster_id"
  end

  create_table "item_sources", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.string "source_type", null: false
    t.bigint "source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_sources_on_item_id"
    t.index ["source_type", "source_id"], name: "index_item_sources_on_source"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "rarity"
    t.string "set_key"
    t.string "set_subkey"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "location_areas", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "area_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_location_areas_on_area_id"
    t.index ["location_id"], name: "index_location_areas_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "monster_areas", force: :cascade do |t|
    t.bigint "monster_id", null: false
    t.bigint "area_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_monster_areas_on_area_id"
    t.index ["monster_id"], name: "index_monster_areas_on_monster_id"
  end

  create_table "monster_elements", force: :cascade do |t|
    t.bigint "monster_id", null: false
    t.bigint "element_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_monster_elements_on_element_id"
    t.index ["monster_id"], name: "index_monster_elements_on_monster_id"
  end

  create_table "monster_weaknesses", force: :cascade do |t|
    t.bigint "monster_id", null: false
    t.bigint "element_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_monster_weaknesses_on_element_id"
    t.index ["monster_id"], name: "index_monster_weaknesses_on_monster_id"
  end

  create_table "monsters", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.integer "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "equip_grade_items", "equip_grades"
  add_foreign_key "equip_grade_items", "equips"
  add_foreign_key "equip_grade_items", "items"
  add_foreign_key "equip_grades", "equips"
  add_foreign_key "item_sources", "items"
  add_foreign_key "location_areas", "areas"
  add_foreign_key "location_areas", "locations"
  add_foreign_key "monster_areas", "areas"
  add_foreign_key "monster_areas", "monsters"
  add_foreign_key "monster_elements", "elements"
  add_foreign_key "monster_elements", "monsters"
  add_foreign_key "monster_weaknesses", "elements"
  add_foreign_key "monster_weaknesses", "monsters"
end
